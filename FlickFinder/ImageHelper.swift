//
//  ImageHelper.swift
//  FlickFinder
//
//  Created by dmikhov on 23.10.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    public static func showImage(url: String, view: UIImageView) {
        // view.image = nil
        let imageUrl = URL(string: url)!
        let task = URLSession.shared.dataTask(with: imageUrl) {
            (data, resp, error) in
            DispatchQueue.main.async {
                if error == nil {
                    let downloadedImage = UIImage(data: data!)
                    view.image = downloadedImage
                    // print("Successfully loaded!")
                } else {
                    print("Error on loading!: ", url)
                }
            }
        }
        task.resume()
    }
}
