//
//  BaseDragViewController.swift
//  Doll-Coloring
//
//  Created by MacBookPro on 5/8/24.
//

import UIKit


class BaseDragViewController: BaseViewController, UIViewControllerTransitioningDelegate {
    
    var height: CGFloat = 0.0 {
        didSet {
            customSizePresentController?.height = height
        }
    }
    
    var customSizePresentController: CustomSizePresentationController?
    
    @objc func didEndDragController() {
    }
    
    @objc func isEnableDrag() -> Bool {
        return true
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let custom = CustomSizePresentationController(presentedViewController: presented, presenting: presentingViewController, enableDrag: isEnableDrag())
        custom.height = height
        custom.delegateEndDrag = {
            self.didEndDragController()
        }
        customSizePresentController = custom
        return custom
    }
}

class CustomSizePresentationController: UIPresentationController {
    var lastCenterY: CGFloat = 0.0
    var height: CGFloat = 0
    var delegateEndDrag: (() -> Void)!
    
    private var dimmingView: UIView!
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, enableDrag: Bool = true) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
        if enableDrag {
            self.enableDrag(controller: presentedViewController)
        }
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else { return }
        containerView.insertSubview(dimmingView, at: 0)
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        presentedView?.frame = frameOfPresentedViewInContainerView
        // UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
        presentedView?.layoutIfNeeded()
        // })
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            guard let theView = containerView else {
                return CGRect.zero
            }
            
            return CGRect(x: 0, y: height == 0 ? theView.bounds.height / 3 : theView.bounds.height - height, width: theView.bounds.width, height: height == 0 ? theView.bounds.height * 2 / 3 : height)
        }
    }
    
    func enableDrag(controller: UIViewController) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragInput(_:)))
        controller.view.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func dragInput(_ gesture: UIPanGestureRecognizer) {
        guard let presentedView = presentedViewController.view, let parentView = presentedView.superview else { return }
        switch gesture.state {
        case .began:
            lastCenterY = presentedView.center.y
        case .changed:
            parentView.bringSubviewToFront(presentedView)
            let translation = gesture.translation(in: parentView)
            let y = presentedView.center.y + translation.y
            if y >= lastCenterY {
                let x = presentedView.center.x
                presentedView.center = CGPoint(x: x, y: y)
            }
            gesture.setTranslation(CGPoint.zero, in: parentView)
        case .ended:
            let currentY = presentedView.center.y - lastCenterY
            
            if currentY <= 100 {
                // TOP SNAP POINT
                sendToLastPosition()
                gesture.setTranslation(CGPoint.zero, in: parentView)
            } else {
                // BOTTOM SNAP POINT
                presentedView.removeGestureRecognizer(gesture)
                delegateEndDrag()
            }
        default:
            break
        }
    }
    
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.isUserInteractionEnabled = true
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        let tapToCloseGesture = UITapGestureRecognizer(target: self,
                                                       action: #selector(clickOutside(_:)))
        dimmingView.addGestureRecognizer(tapToCloseGesture)
    }
    
    @objc
    private func clickOutside(_ gesture: UITapGestureRecognizer) {
        guard let presentedView = gesture.view else { return }
        presentedView.removeGestureRecognizer(gesture)
        delegateEndDrag()
    }
    
    private func sendToLastPosition() {
        guard let presentedView = presentedViewController.view else { return }
        let topYPosition: CGFloat = lastCenterY
        let topXPosition: CGFloat = presentedView.center.x
        UIView.animate(withDuration: 0.25) {
            presentedView.center = CGPoint(x: topXPosition, y: topYPosition)
        }
    }
}
