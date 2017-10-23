//
//  PhotoViewController.swift
//  FlickFinder
//
//  Created by dmikhov on 20.10.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet var photoLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!

    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let p = photo {
            print("Show photo: ", p.name)
            ImageHelper.showImage(url: (p.url)!, view: photoImageView)
            photoLabel.text = p.name
        } else {
            print("The photo was not sent!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
