//
//  ViewController.swift
//  ImageLoader
//
//  Created by Vitaliy Maksymlyuk on 6/14/18.
//  Copyright © 2018 Vitaliy Maksymlyuk. All rights reserved.
//

import UIKit
import SkeletonView
import CoreData


class ImageLoaderVC: UIViewController {

    var image: UIImage? = nil
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var urlTextField: UITextField!
    
    // MARK: - Actions
    
    @IBAction func getImageBtn(_ sender: Any) {
        urlTextField.resignFirstResponder()
        startAnimateImageView(with: true)
        if let theInput = urlTextField.text, let theURL = URL(string: theInput) {
            ImageManager.shared.requestImage(URL: theURL) { [weak self] data, resivedImageURL in
                guard let weakSelf = self else { return }
                
                DispatchQueue.main.async {
                    weakSelf.imageView.image = UIImage(data: data)
                    weakSelf.startAnimateImageView(with: false)
                }
            }
        }
    }
    
    
    func showAllert(message: String) {
        let alertView = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    // MARK: - Life Cycle methods of the View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextField.delegate = self
        
        // Listeners for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    // Removing the keyboard observers and stop listening
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    
    @objc func keyboardWillChange(_ notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }

    
    func startAnimateImageView(with state: Bool) {
        if state == true {
            imageView.isSkeletonable = true
            let gradient = SkeletonGradient(baseColor: UIColor.clouds, secondaryColor: UIColor.silver)
            let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
            imageView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        } else {
            imageView.stopSkeletonAnimation()
            imageView.hideSkeleton()
        }
        
    }
}

extension ImageLoaderVC: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        urlTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}










