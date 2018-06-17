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

    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var urlTextField: UITextField!
    
    // MARK: - Actions
    
    @IBAction func getImageBtn(_ sender: Any) {
        
        urlTextField.resignFirstResponder()
        if let urlTextField = self.urlTextField.text {
            if urlTextField.isEmpty == false {
                if validateURL(from: urlTextField) {
                    startAnimateImageView(with: true)
                    downloadImage(from: URL(string: urlTextField)!)
                    
                } else {
                    showAllert(message: "Invalid URL")
                }
                
            } else {
                showAllert(message: "Please Enter the URL to get the Image")
            }
        }
    }

    func showAllert(message: String) {
        let alertView = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    
    
    func downloadImage(from url: URL) {
        
        let sesion = URLSession.shared
        
        let task = sesion.dataTask(with: url) { (data, responce, error) in
            
            if let data = data {
                let downloadedImage = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self.startAnimateImageView(with: false)
                    self.imageView.image = downloadedImage
                }
                
            } else {
                
                
                
//                if let responce = responce?.mimeType {
//                    if responce != "image/png" || responce != "image/jpeg" || responce != "image/gif" || responce != "image/bmp" || responce != "image/tiff" {
//                        self.showAllert(message: "Invalid Image file type")
//
//                    }
//                }
            }
            
        }
        
        task.resume()
        
    }
    
    // MARK: - Helper method
    func validateURL(from url: String) -> Bool {
        let urlRegEx = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: url)
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










