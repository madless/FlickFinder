//
//  ImageHelper.swift
//  FlickFinder
//
//  Created by dmikhov on 23.10.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class ImageHelper {
    public static func showImage(url: String, view: UIImageView) {
//        let imageUrl = URL(string: url)!
//        let task = URLSession.shared.dataTask(with: imageUrl) {
//            (data, resp, error) in
//            DispatchQueue.main.async {
//                if error == nil {
//                    let downloadedImage = UIImage(data: data!)
//                    view.image = downloadedImage
//                    // print("Successfully loaded!")
//                } else {
//                    print("Error on loading!: ", url)
//                }
//            }
//        }
//        task.resume()
        Alamofire.request(url).responseImage {
            response in
            if let data = response.data {
                let image = UIImage(data: data)
                let circularImage = image?.af_imageRoundedIntoCircle()
                view.image = circularImage
            }
        }
    }
}
