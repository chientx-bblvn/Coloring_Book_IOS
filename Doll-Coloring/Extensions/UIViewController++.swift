//
//  UIViewController++.swift
// Doll-Coloring
//
//  Created by BBLabs on 05/04/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import MessageUI
import SafariServices

extension UIViewController {
    
    func createMyQuestion(icon: UIImage? = nil,
                          title: String = "",
                          message: String = "",
                          positiveTitle: String = LocalizableUtils.commonOK(),
                          negativeTitle: String = LocalizableUtils.commonCancel(),
                          alignment: NSTextAlignment = .center,
                          cancelOnTouchOutside: Bool = false,
                          handler: (() -> Void)? = nil,
                          cancel: (() -> Void)? = nil) -> AlertViewController {
        let alert = AlertViewController.create()
        alert.setTitle(title: title)
        alert.setIcon(icon: icon)
        if !message.isEmpty {
            let messageAttr = NSMutableAttributedString(string: message)
            
            let font = UIFont.systemFont(ofSize: 14)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = alignment
            paragraphStyle.lineSpacing = 0.25 * font.lineHeight
            messageAttr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: messageAttr.length))
            messageAttr.addAttribute(.foregroundColor, value: R.color.textColor() ?? UIColor.systemBrown,
                                     range: NSRange.init(location: 0, length: messageAttr.length))
            
            messageAttr.addAttribute(.font, value: font, range: NSRange.init(location: 0, length: messageAttr.length))
            
            alert.setMessage(message: messageAttr)
        }
        alert.setOKBlock(title: positiveTitle) { _ in
            handler?()
        }
        
        alert.setCancelBlock(title: negativeTitle) { _ in
            cancel?()
        }
        alert.cancelTouchOutSide = cancelOnTouchOutside
        present(alert, animated: false)
        return alert
    }
    
    func createMyAlertInteract(icon: UIImage? = nil,
                               title: String = "",
                               message: String,
                               links: [LinkAttribute] = [],
                               okTitle: String = LocalizableUtils.commonOK(),
                               cancelTouchOutSide: Bool = false,
                               handlerInteract: ((_ alert: AlertViewController, _ linkName: String) -> Bool)? = nil,
                               handler: (() -> Void)? = nil) -> AlertViewController {
        let font = UIFont.systemFont(ofSize: 14)
        let mutableAttributedString = NSMutableAttributedString(string: message)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 0.25 * font.lineHeight
        mutableAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: mutableAttributedString.length))
        mutableAttributedString.addAttribute(.foregroundColor, value: R.color.textColor() ?? .systemBrown,
                                             range: NSRange.init(location: 0, length: mutableAttributedString.length))
        
        mutableAttributedString.addAttribute(.font, value: font, range: NSRange.init(location: 0, length: mutableAttributedString.length))
        
        // set link
        links.forEach { attr in
            mutableAttributedString.setAsLink(
                textToFind: attr.linkFind,
                linkName: attr.linkName,
                foreground: attr.linkColor,
                underline: attr.underline ? attr.linkColor : .clear)
        }
        
        let alertViewContronller = AlertViewController.create()
        alertViewContronller.setIcon(icon: icon)
        alertViewContronller.setTitle(title: title)
        alertViewContronller.setMessage(message: mutableAttributedString)
        alertViewContronller.setOKBlock(title: okTitle) { _ in
            handler?()
        }
        alertViewContronller.handleTextInteract = { (alert, _, URL, _) in
            return handlerInteract?(alert, URL.absoluteString) ?? false
        }
        alertViewContronller.cancelTouchOutSide = cancelTouchOutSide
        self.present(alertViewContronller, animated: false, completion: nil)
        return alertViewContronller
    }
    
    @discardableResult
    func createMyAlert(icon: UIImage? = nil, 
                       title: String = "",
                       _ message: String = "",
                       okTitle: String = LocalizableUtils.commonOK(),
                       cancelTouchOutSide: Bool = false,
                       handler: (() -> Void)? = nil) -> AlertViewController {
        let alert = AlertViewController.create()
        alert.setTitle(title: title)
        alert.setIcon(icon: icon)
        if !message.isEmpty {
            let messageAttr = NSMutableAttributedString(string: message)
            
            let font = UIFont.systemFont(ofSize: 14)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineSpacing = 0.25 * font.lineHeight
            messageAttr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: messageAttr.length))
            messageAttr.addAttribute(.foregroundColor, value: R.color.textColor() ?? .systemBrown,
                                     range: NSRange.init(location: 0, length: messageAttr.length))
            
            messageAttr.addAttribute(.font, value: font, range: NSRange.init(location: 0, length: messageAttr.length))
            alert.setMessage(message: messageAttr)
        }
        alert.setOKBlock(title: okTitle) { _ in
            handler?()
        }
        alert.cancelTouchOutSide = cancelTouchOutSide
        present(alert, animated: false)
        return alert
    }
    
    func createToast(type: ToastView.TypeToast, title: String, topLayout: CGFloat = 76, duration: TimeInterval = 5) {
        let toastView = ToastView.shared
        toastView.removeFromSuperview()
        toastView.work.cancel()
        
        toastView.type = type
        toastView.titleToast = title
        
        self.view.addSubview(toastView)
        NSLayoutConstraint(item: toastView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: topLayout).isActive = true
        NSLayoutConstraint(item: toastView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: toastView, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20).isActive = true
        
        toastView.work = DispatchWorkItem {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [.curveEaseOut], animations: {
                toastView.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
                toastView.alpha = 0
            }, completion: { _ in
                toastView.removeFromSuperview()
            })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: toastView.work)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [.curveEaseIn], animations: {
            toastView.transform = .identity
            toastView.alpha = 1
        }, completion: nil)
        
    }

    func shareContent(text: String? = nil, url: URL? = nil, image: UIImage? = nil,
                          sourceView: UIView?) {
            var sharedObjects: [AnyObject] = []
            if let someText = text, !someText.isEmpty {
                sharedObjects.append(someText as AnyObject)
            }
            if let webUrl = url {
                sharedObjects.append(webUrl as AnyObject)
            }
            if let imageShare = image {
                sharedObjects.append(imageShare as AnyObject)
            }
            let activityViewController = UIActivityViewController(activityItems: sharedObjects, applicationActivities: nil)
            if DeviceInfos.isIpad() {
                if let view = sourceView ?? self.view {
                    activityViewController.popoverPresentationController?.sourceView = view
                    activityViewController.popoverPresentationController?.sourceRect = view.bounds
                }
            }
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.saveToCameraRoll]

            self.present(activityViewController, animated: true, completion: nil)
        }
    
}

struct LinkAttribute {
    var linkName: String
    var linkFind: String
    var linkColor: UIColor
    var underline: Bool
}

extension UIViewController: MFMailComposeViewControllerDelegate {
    
    func sendMail(title: String = "", email recipientEmail: String, subject: String = "", body: String = "", isHTML: Bool = false) {
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            if !title.isEmpty {
                mail.title = title
            }
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: isHTML)
            
            present(mail, animated: true)
            
            // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(error?.localizedDescription ?? "")")
        @unknown default:
            print("Mail send failed")
        }
        controller.dismiss(animated: true)
    }
}

// MARK: - Handle font picker on iOS
extension UIViewController: UIFontPickerViewControllerDelegate {
    
    public typealias HandlerFontDelegate = ((_ fontName: String) -> Void)
    
    private static var handlerFontDelegate: HandlerFontDelegate?
    
    func showFontPicker(completion: HandlerFontDelegate?) {
        UIViewController.handlerFontDelegate = completion
        let familyNames = UIFont.familyNames.sorted()
        
        for family in familyNames {
            print("Family name " + family)
            let fontNames = UIFont.fontNames(forFamilyName: family)
            
            for font in fontNames {
                print("    Font name: " + font)
            }
        }
        
        if #available(iOS 13.0, *) {
            let configuration = UIFontPickerViewController.Configuration()
            configuration.includeFaces = true
            configuration.displayUsingSystemFont = true
            //        configuration.filteredTraits = [.classModernSerifs]
            let viewController = UIFontPickerViewController(configuration: configuration)
            viewController.delegate = self
            present(viewController, animated: true)
        } else {
            // Fallback on earlier versions
            completion?("")
        }
    }
    
    @available(iOS 13.0, *)
    public func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        let fontPicker = viewController.selectedFontDescriptor
        let fontName = fontPicker?.postscriptName ?? ""
        UIViewController.handlerFontDelegate?(fontName)
    }
    
}

extension UIViewController {
    
    public typealias HandlerColorDelegate = ((_ colorSelected: UIColor) -> Void)
    
    private static var handlerColor: HandlerColorDelegate?
    
    func createQuestion(_ title: String = "", _ message: String, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizableUtils.commonOK(),
                                      style: .default, handler: { (_) in
            handler?()
        }))
        alert.addAction(UIAlertAction(title: LocalizableUtils.commonCancel(), style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func createAlert(title: String = "", 
                     _ message: String,
                     titleBtn: String = LocalizableUtils.commonOK(),
                     handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleBtn, style: .cancel, handler: { (_) in
            handler?()
        }))
        present(alert, animated: true)
    }
    
}

extension UIViewController {
    
    func showQuestionChoicePhoto(onPickPhoto: @escaping ((_ img: UIImage, _ fileName: String) -> Void)) {
        PickerPhotoController.show(in: self, onPickPhoto: onPickPhoto)
    }
    
    static func loadController() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
    
}
