//
//  FavoritePhotoViewController.swift
//  FavoritePhotos
//
//  Created by Kiana Caston on 4/30/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit
import Firebase

class FavoritePhotoViewController: ImagePickerViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var storageRef: StorageReference!
    var photoDocRef: DocumentReference!
    var photoListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = Storage.storage().reference(withPath: "favorite")
        photoDocRef = Firestore.firestore().collection("favorite").document("photo")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoListener = photoDocRef.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print("Error getting the Firestore document \(error.localizedDescription)")
            }
            if let url = snapshot?.get("url") as? String {
                print("Loading image from url")
                // TODO: Make a helper class that everyone can use
                ImageUtils.load(imageView: self.imageView, from: url)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if photoListener != nil {
            photoListener.remove()
        }
    }
    
    override func uploadImage(_ image: UIImage) {
        guard let data = UIImageJPEGRepresentation(image, 0.5) else { return }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        progressView.isHidden = false
        progressView.progress = 0
        
        let uploadTask = storageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
            if let error = error {
                print("Error with upload \(error.localizedDescription)")
            }
        }
        uploadTask.observe(StorageTaskStatus.progress) { (snapshot) in
            guard let progress = snapshot.progress else { return }
            self.progressView.progress = Float(progress.fractionCompleted)
        }
        uploadTask.observe(StorageTaskStatus.success) { (snapshot) in
            print("Your upload is finished")
            self.progressView.isHidden = true
            
            self.storageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("Error getting the download url. \(error.localizedDescription)")
                }
                if let url = url {
                    print("Saving the url \(url.absoluteString)")
                    // Save the download url to the firestore
                    self.photoDocRef.setData(["url" : url.absoluteString])
                }
            })
        }
        
    }
}

