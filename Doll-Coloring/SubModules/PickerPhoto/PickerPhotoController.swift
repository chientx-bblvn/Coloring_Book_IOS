//
//  PickerPhotoController.swift
// Doll-Coloring
//
//  Created by BBLabs on 11/20/21.
//  Copyright © 2021 BBLabs.All rights reserved.
//

import AVFoundation
import Foundation
import Photos
import RxSwift
import UIKit

class PickerPhotoController: BaseViewController {
    
    @IBOutlet private weak var viewDimmer: UIView!
    @IBOutlet private weak var viewMain: UIView!
    @IBOutlet private weak var viewGallery: UIView!
    @IBOutlet private weak var viewCamera: UIView!
    @IBOutlet private weak var lblGallery: UILabel!
    @IBOutlet private weak var lblCamera: UILabel!
    
    private var onPickPhoto: ((_ img: UIImage, _ fileName: String) -> Void)?
    
    class func show(in parent: UIViewController, 
                    onPickPhoto: @escaping ((_ img: UIImage, _ fileName: String) -> Void)) {
        if let picker = PickerPhotoRoute.main.screen as? PickerPhotoController {
            picker.onPickPhoto = onPickPhoto
            picker.showInView(parent: parent)
        }
    }
    
    override func setup() {
        super.setup()
        viewMain.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 16)
        viewGallery.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickGallery)))
        viewCamera.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickCamera)))
        viewDimmer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickHidePicker)))
        loadText()
    }
    
    override func onLanguageChange() {
        super.onLanguageChange()
        loadText()
    }
    
    @objc private func clickGallery() {
        viewGallery.isClicked(true)
        if #available(iOS 14.0, *) {
            presentPhotobrowser()
            return
        }
        checkPhotoAccess { _, message in
            self.createMyAlert(icon: nil /** TODO */, message)
        }
    }
    
    @objc
    private func clickCamera() {
        viewCamera.isClicked(true)
        checkCameraAccess { _, message in
            self.createMyAlert(icon: nil  /** TODO */, message)
        }
    }
    
    @objc
    private func clickHidePicker() {
        self.removeAnimate()
    }
    
    func checkCameraAccess(completion: @escaping (String, String) -> Void) {
        let title = LocalizableUtils.title_open_camera()
        let message = LocalizableUtils.message_open_camera()
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            completion(title, message)
            return
        }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            debugPrint("Denied, request permission from settings")
            completion(title, message)
        case .restricted:
            debugPrint("Restricted, device owner must approve")
        case .authorized:
            presentCamera()
            debugPrint("Authorized, proceed")
        case .notDetermined:
            debugPrint("Permission notDetermined")
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] (granted: Bool) in
                if granted {
                    DispatchQueue.main.asyncSafety{
                        self?.presentCamera()
                    }
                    debugPrint("Granted access to camera")
                }
            })
        default:
            debugPrint(ErrorUtils.photo_PERMISSION_DENIED())
        }
    }
    
    func checkPhotoAccess(completion: @escaping (String, String) -> Void) {
        let title = LocalizableUtils.title_open_library()
        let message = LocalizableUtils.message_open_libary()
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            completion(title, message)
            return
        }
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .limited:
            let photoCount = PHAsset.fetchAssets(with: .image, options: nil).count
            print("Photo access permission is limited \(photoCount)")
            if photoCount > 0 {
                presentPhotobrowser()
            } else {
                completion(title, ErrorUtils.photo_IS_LIMITED())
            }
        case .authorized:
            let photoCount = PHAsset.fetchAssets(with: .image, options: nil).count
            print("Photo access permission is limited \(photoCount)")
            if photoCount > 0 {
                presentPhotobrowser()
            } else {
                completion(title, ErrorUtils.photo_IS_LIMITED())
            }
//        case .authorized:
//            presentPhotobrowser()
//            break
            // handle authorized status
        case .denied, .restricted: 
            debugPrint(ErrorUtils.photo_PERMISSION_DENIED())
            completion(title, message)
            // handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization({ [weak self] status in
                if status == .authorized {
                    DispatchQueue.main.asyncSafety{
                        self?.presentPhotobrowser()
                    }
                }
            })
        default:
            debugPrint(ErrorUtils.photo_PERMISSION_DENIED())
        }
    }
    
    func presentCameraSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func presentPhotobrowser() {
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func loadText() {
        lblGallery.text = LocalizableUtils.commonPhotoPickerGallery()
        lblCamera.text = LocalizableUtils.commonPhotoPickerCamera()
    }
}

// MARK: - Handle for photo picker
extension PickerPhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        self.removeAnimate {
            var image = (info[.originalImage] as? UIImage)?.fixedOrientation()
            if let size = image?.size {
                if size.width > 720 {
                    let width = 720.0
                    let height = width * size.height / size.width
                    image = image?.resizeVI(size: CGSize(width: width, height: height))
                }
            }
            
            var fileName = ""
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                fileName = url.lastPathComponent
            }
            
            DispatchQueue.main.asyncSafety{
                if let img = image {
                    self.onPickPhoto?(img, fileName)
                }
            }
        }
    }
    
}

// MARK: - Show/hide view
extension PickerPhotoController {
    
    func showInView(parent: UIViewController) {
        self.modalPresentationStyle = .overFullScreen
        parent.present(self, animated: false) {
            self.showAnimate()
        }
    }
    
    private func showAnimate() {
        self.viewMain.transform.ty = self.viewMain.frame.origin.y + self.viewMain.frame.height
        self.viewDimmer.alpha = 0.0
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.viewDimmer.alpha = 1.0
            self.viewMain.transform = .identity
        })
    }
    
    private func removeAnimate(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.viewMain.transform.ty = self.viewMain.frame.origin.y + self.viewMain.frame.height
            self.viewDimmer.alpha = 0.0
            completion?()
        }, completion: { [weak self] (_: Bool) in
            self?.dismiss(animated: false)
        })
    }
    
    private func updateConstraints(_ parentView: UIView) {
        guard let view = self.view else { return }
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingContraint = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leadingConstraint,
            trailingContraint
        ])
    }
    
}
