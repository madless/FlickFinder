//
//  CustomTableViewCell.swift
//  FlickFinder
//
//  Created by dmikhov on 23.10.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet var customImage: UIImageView!
    @IBOutlet var customTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Here you can customize the appearance of your cell
    override func layoutSubviews() {
        super.layoutSubviews()
        // Customize imageView like you need
        
//        self.customImage?.frame = CGRect(x : 0, y : 0,width: 50, height: 50)
//        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        // Costomize other elements
//        self.textLabel?.frame = CGRect(x: 60, y: 0, width: self.frame.width - 45, height: 20)
//        self.detailTextLabel?.frame = CGRect(x: 60, y: 20, width: self.frame.width - 45, height: 15)
    }
}
