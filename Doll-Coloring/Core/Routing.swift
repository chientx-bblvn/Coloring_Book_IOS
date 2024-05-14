//
//  Routing.swift
//  BBLabs.
//
//  Created by BBLabs on 4/4/18.
//  Copyright © 2018 BBLabs.All rights reserved.
//

import Foundation
import UIKit

/**
 The base router class implements the router protocol
 exposing basic behaviour extensible via inheritance.
 
 For example, you should subclass if you want to add
 some logic to the initial route by checking something
 stored in your keychain.
 */
public class BaseRouter: Router {
    public var rootViewController: UINavigationController?
    public var currentViewController: UIViewController?
    
    public required init(with route: Route) {
        let screen = route.screen
        if let navigation = screen as? UINavigationController {
            rootViewController = navigation
            currentViewController = navigation.viewControllers.first
        } else {
            let viewController = screen
            rootViewController = UINavigationController(rootViewController: viewController)
            rootViewController?.isNavigationBarHidden = true
            currentViewController = viewController
        }
    }
}

/**
 The Router is the base of this framework, it handles all
 your application navigation stack.
 
 It keeps thrack of your root NavigationController and the
 ViewController that is currently displayed. This way it can
 handle any kind of navigation action that you might want to dispatch.
 */
public protocol Router: class {
    /// The root navigation controller of your stack.
    var rootViewController: UINavigationController? { get set }
    
    /// The currently visible ViewController
    var currentViewController: UIViewController? { get set }
    
    /// Convencience init to set your application starting screen.
    init(with route: Route)
    
    /**
     Navigate from your current screen to a new route.
     
     - Parameters:
     - route: The destination route of your navigation action.
     - transition: The transition type that you want to use.
     - animated: Animate the transition or not.
     - completion: Completion handler.
     */
    func navigate(root: UINavigationController?, to route: Route, with transition: TransitionType, animated: Bool, completion: (() -> Void)?)
    
    /**
     Navigate from your current screen to a new entire router. Can only push a router as a modal. Afterwards, other controllers can be pushed inside the presented Router.
     
     - Parameters:
     - Router: The destination router that you want to navigate to
     - animated: Animate the transition or not.
     - completion: Completion handler.
     */
    func navigate(to router: Router, animated: Bool, completion: (() -> Void)?)
    
    /**
     Handles backwards navigation through the stack.
     
     - Parameters:
     - route: The destination route of your navigation action, pass nil if you want to pop just to the previous controller.
     - animated: Animate the transition or not.
     */
    func popTo(index: Int, animated: Bool)
    
    /**
     Dismiss your current ViewController.
     
     - Parameters:
     - animated: Animate the transition or not.
     - completion: Completion handler.
     */
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

public extension Router {
    func navigate(root navigation: UINavigationController? = nil, to route: Route, with transition: TransitionType,
                  animated: Bool = true, completion: (() -> Void)? = nil) {
        let viewController = route.screen
        switch transition {
        case .modal:
            viewController.modalPresentationStyle = .overFullScreen
            getTopMostViewController()?.present(viewController, animated: animated, completion: completion)
            currentViewController = viewController
        case .push:
            if let navigation = navigation {
                rootViewController = navigation
                navigation.pushViewController(viewController, animated: animated)
            } else {
                rootViewController?.pushViewController(viewController, animated: animated)
            }
            currentViewController = viewController
        case .reset:
            rootViewController?.setViewControllers([viewController], animated: animated)
            currentViewController = viewController
        case .changeRoot:
            if let navigation = (viewController as? UINavigationController) {
                var window = UIApplication.shared.keyWindow
                if window == nil {
                    window = UIWindow(frame: UIScreen.main.bounds)
                    (UIApplication.shared.delegate as? AppDelegate)?.window = window
                }
                window?.rootViewController = navigation
                rootViewController = navigation
                currentViewController = rootViewController?.topViewController
                if let newWindow = window, animated {
                    UIView.transition(with: newWindow, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                }
            } else {
                let navigationController = UINavigationController(rootViewController: viewController)
                var window = UIApplication.shared.keyWindow
                if window == nil {
                    window = UIWindow(frame: UIScreen.main.bounds)
                    (UIApplication.shared.delegate as? AppDelegate)?.window = window
                }
                window?.rootViewController = navigationController
                rootViewController = navigationController
                rootViewController?.isNavigationBarHidden = true
                window?.makeKeyAndVisible()
                currentViewController = viewController
                
                if let newWindow = window, animated {
                    UIView.transition(with: newWindow, duration: 1, options: .transitionCrossDissolve, animations: nil)
                }
            }
        case .open:
            rootViewController?.open(viewController: viewController)
        case .close:
            rootViewController?.close()
        }
    }
    
    func navigate(to router: Router, animated: Bool, completion: (() -> Void)?) {
        guard let viewController = router.rootViewController else {
            assert(false, "Router does not have a root view controller")
            return
        }
        
        currentViewController?.present(viewController, animated: animated, completion: completion)
        currentViewController = viewController
    }
    
    func popToRoot(animated: Bool = true) {
        rootViewController?.popToRootViewController(animated: animated)
        currentViewController = rootViewController?.topViewController
    }
    
    func popTo(index: Int, animated: Bool = true) {
        guard
            let viewControllers = rootViewController?.viewControllers,
            viewControllers.count > index
            else { return }
        let viewController = viewControllers[index]
        rootViewController?.popToViewController(viewController, animated: animated)
        currentViewController = viewController
    }
    
    func dismiss<T>(to controller: T.Type, animated: Bool = true) where T: UIViewController {
        guard
            let viewControllers = rootViewController?.viewControllers,
            !viewControllers.isEmpty
            else { return }
        if let viewController = viewControllers.first(where: {
            return $0 is T
        }) {
            rootViewController?.popToViewController(viewController, animated: animated)
        } else {
            rootViewController?.popViewController(animated: animated)
        }
        currentViewController = rootViewController?.topViewController
    }
    
    func dismissDetail(animated: Bool = true) {
        guard
            let viewControllers = rootViewController?.viewControllers,
            !viewControllers.isEmpty
            else { return }
        rootViewController?.popViewController(animated: animated)
        currentViewController = rootViewController?.topViewController
    }
    
    func popToController(controller: AnyClass, animated: Bool = true) {
        guard
            let viewControllers = rootViewController?.viewControllers, let viewController = viewControllers.first(where: {$0.isKind(of: controller)})
            else { return }
        
        rootViewController?.popToViewController(viewController, animated: animated)
        currentViewController = viewController
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
//        let presentingViewController = currentViewController?.presentingViewController
        currentViewController?.dismiss(animated: animated, completion: completion)
//        currentViewController = presentingViewController
        currentViewController = rootViewController?.topViewController
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.windows.last?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
}

/**
 Protocol used to define a set a Route. The route contains
 all the information necessary to instantiate it's screen.
 
 For example, you could have a LoginRoute, that knows how
 to instantiate it's viewModel, and also forward any
 information that it's passed to the Route.
 */
public protocol Route {
    // The screen that should be returned for that Route.
    var screen: UIViewController { get }
}

/// Available Transition types for navigation actions.
public enum TransitionType {
    /// Presents the screen modally on top of the current ViewController
    case modal
    
    /// Pushes the next screen to the rootViewController navigation Stack.
    case push
    
    /// Resets the rootViewController navitationStack and set's the Route's screen as the initial view controller of the stack.
    case reset
    
    /// Replaces the key window's Root view controller with the Route's screen.
    case changeRoot
    
    case open
    
    case close
}
