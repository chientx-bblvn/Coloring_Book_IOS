import Foundation
import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet private weak var viewIconAlert: UIView!
    @IBOutlet private weak var imageViewAlert: UIImageView!
    @IBOutlet private weak var labelTitleView: UILabel!
    @IBOutlet private weak var labelMessageView: UITextView!
    @IBOutlet private weak var btnCancel: UIButton!
    @IBOutlet private weak var agreeView: ButtonView!
    @IBOutlet private weak var alertView: UIView!
    
    fileprivate var titleAlert = ""
    fileprivate var imgIcon: UIImage?
    fileprivate var cancelAlert = ""
    fileprivate var okAlert = ""
    var cancelTouchOutSide = false
    var messageAlertAttr: NSAttributedString?
    
    private let buttonGradien = CAGradientLayer()
    
    typealias CancelBlock = (_ controller: AlertViewController?) -> Void
    fileprivate var cancelBlock: CancelBlock?
    typealias CompletionBlock = (_ controller: AlertViewController?) -> Void
    fileprivate var completionBlock: CompletionBlock?
    var handleTextInteract: ((_ alert: AlertViewController, _ textView: UITextView, _ URL: URL, _ characterRange: NSRange) -> Bool)?
    
    class func create() -> AlertViewController {
        let customAlert = AlertViewController.loadController()
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        return customAlert
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingView()
        animateView()
        
        labelMessageView.delegate = self
        agreeView.setOnClickListener {
            self.dismissAlert(animated: false) { [weak self] in
                guard let self = self else { return }
                self.completionBlock?(self)
            }
        }
    }
    
    func animateView() {
        alertView.alpha = 0
        self.alertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: .curveEaseInOut,
                       animations: { () -> Void in
            self.alertView.alpha = 1.0
            self.alertView.transform = .identity
        })
    }
    
    fileprivate func settingView() {
        
        viewIconAlert.isHidden = imgIcon == nil
        imageViewAlert.image = imgIcon
        
        labelTitleView.text = titleAlert
        labelTitleView.isHidden = titleAlert.isEmpty
        labelMessageView.textContainerInset = .zero
        labelMessageView.contentInset = .zero
        labelMessageView.textContainer.lineFragmentPadding = 0
        labelMessageView.attributedText = messageAlertAttr
        labelMessageView.isHidden = messageAlertAttr == nil
        
        agreeView.isHidden = okAlert.isEmpty
        agreeView.title = okAlert
        btnCancel.borderColor = R.color.mainPrimary()
        UIView.setAnimationsEnabled(false)
        btnCancel.borderWidth = 1
        btnCancel.titleLabel?.textAlignment = .center
        btnCancel.isHidden = cancelAlert.isEmpty
        btnCancel.setTitle(cancelAlert, for: .normal)
        UIView.setAnimationsEnabled(true)
        let tapClose = UITapGestureRecognizer(target: self, action: #selector(closeOnTouchOutside(_:)))
        view.addGestureRecognizer(tapClose)
    }
    
    @objc func closeOnTouchOutside(_ sender: Any) {
        if !cancelTouchOutSide {
            return
        }
        self.dismissAlert(animated: false)
    }
    
    func setTitle(title: String) {
        titleAlert = title
    }
    
    func setIcon(icon: UIImage?) {
        imgIcon = icon
    }
    
    func setMessage(message: NSAttributedString) {
        messageAlertAttr = message
    }
    
    func setCancelBlock(title: String = LocalizableUtils.commonCancel(), cancelBlock: CancelBlock?) {
        cancelAlert = title
        self.cancelBlock = cancelBlock
    }
    
    func setOKBlock(title: String = LocalizableUtils.commonOK(), completionBlock: CompletionBlock?) {
        okAlert = title
        self.completionBlock = completionBlock
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        btnCancel.isClicked(true)
        self.dismissAlert(animated: false) { [weak self] in
            self?.cancelBlock?(self)
        }
    }
    
    func dismissAlert(animated: Bool, completion: (() -> Void)? = nil) {
        alertView.alpha = 1
        self.alertView.transform = .identity
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { () -> Void in
            self.alertView.alpha = 0
            self.alertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            super.dismiss(animated: animated, completion: completion)
        })
    }
    
    private func addBorderGradient() {
        
        let path = UIBezierPath(roundedRect: btnCancel.bounds.insetBy(dx: 1, dy: 1),
                                cornerRadius: 8)
        
        buttonGradien.frame = CGRect(origin: CGPoint.zero, size: btnCancel.frame.size)
        buttonGradien.startPoint = CGPoint(x: 0.0, y: 0.5)
        buttonGradien.endPoint = CGPoint(x: 1.0, y: 0.5)
        let colors = [R.color.mainPrimary()?.cgColor, R.color.mainPrimary()?.cgColor, R.color.mainPrimary()?.cgColor].compactMap({ $0 })
        buttonGradien.colors = colors
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        buttonGradien.mask = shape
        
        btnCancel.layer.insertSublayer(buttonGradien, at: 0)
    }
        
}

extension AlertViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return handleTextInteract?(self, textView, URL, characterRange) ?? true
    }
    
}
