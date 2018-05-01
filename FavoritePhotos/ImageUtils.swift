//
//  ImageUtils.swift
//  FavoritePhotos
//
//  Created by Kiana Caston on 5/1/18.
//  Copyright © 2018 Kiana Caston. All rights reserved.
//

import UIKit
import Kingfisher

class ImageUtils: NSObject {
    
    static func load(imageView: UIImageView, from url: String) {
        if let imgUrl = URL(string: url) {
            
            imageView.kf.setImage(with: imgUrl)
            
//            DispatchQueue.global().async {
//                do {
//                    let data = try Data(contentsOf: imgUrl)
//                    DispatchQueue.main.async {
//                        imageView.image = UIImage(data: data)
//                    }
//                } catch {
//                    print("Error downloading image: \(error.localizedDescription)")
//                }
//            }
        }
    }
}
