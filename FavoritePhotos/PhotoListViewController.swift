//
//  PhotoListViewController.swift
//  FavoritePhotos
//
//  Created by Kiana Caston on 4/30/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit
import Firebase

class PhotoListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let photoCellIdentifier = "PhotoCell"
    @IBOutlet var collectionView: [UICollectionView]!
    
    var dataSnapshots = [DocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func takePhoto(_ sender: Any) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
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
    


}
