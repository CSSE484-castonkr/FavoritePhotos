//
//  PhotoListViewController.swift
//  FavoritePhotos
//
//  Created by Kiana Caston on 4/30/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit
import Firebase

class PhotoListViewController: ImagePickerViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let photoCellIdentifier = "PhotoCell"
    @IBOutlet var collectionView: [UICollectionView]!
    
    var photosStorageRef: StorageReference!
    var photosCollectionRef: CollectionReference!
    var photosListener: ListenerRegistration!
    
    var dataSnapshots = [DocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosStorageRef = Storage.storage().reference(withPath: "photos")
        photosCollectionRef = Firestore.firestore().collection("photos")
    }
    
    // TODO: add and remove a firestore listener
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSnapshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellIdentifier,
                                                      for: indexPath) as! PhotoViewCell
        
        // Configure the cell
        //        cell.captionLabel.text = "Best Photo Ever!"
        //        cell.imageView.image = #imageLiteral(resourceName: "fab")
        cell.display(snapshot: dataSnapshots[indexPath.row])
        
        return cell
    }
    
    override func uploadImage(_ image: UIImage) {
        guard let data = ImageUtils.resize(image: image) else { return }
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        // Identical
        //            photosCollectionRef.addDocument(data: <#T##[String : Any]#>)
        //            photosCollectionRef.document().setData(<#T##documentData: [String : Any]##[String : Any]#>)
        
        let photoDocumentRef = photosCollectionRef.document()
        let photoStorageRef = photosStorageRef.child(photoDocumentRef.documentID)
        
        photoStorageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
            if let error = error {
                print("Error with upload \(error.localizedDescription)")
                return
                
            }
            photoStorageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("Error getting the download url. \(error.localizedDescription)")
                }
                if let url = url {
                    print("Saving the url \(url.absoluteString)")
                    photoDocumentRef.setData(["url" : url.absoluteString,
                                              "caption": "Best photo ever",
                                              "created": Date()])
                }
            })
        }
    }
}
