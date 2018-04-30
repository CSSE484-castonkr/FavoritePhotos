//
//  FavoritePhotoViewController.swift
//  FavoritePhotos
//
//  Created by Kiana Caston on 4/30/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit

class FavoritePhotoViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true)
    }
}

// MARK: UIImagePicker controller delegate methods

extension FavoritePhotoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // TODO: Upload the data to Storage, display AFTER the storage save is done
            self.imageView.image = image // Cheat TODO: Delete this line
        }
        picker.dismiss(animated: true)
    }
}
