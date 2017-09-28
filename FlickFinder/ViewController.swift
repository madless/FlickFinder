//
//  ViewController.swift
//  FlickFinder
//
//  Created by dmikhov on 28.09.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var fieldLatitude: UITextField!
    @IBOutlet var fieldLongitude: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fieldLatitude.delegate = self
        fieldLongitude.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickedFindByText() {
        print("onClickedFindByText")
    }
    
    @IBAction func onClickedFindByCoordinates() {
        print("onClickedFindByCoordinates")
    }
    
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -80
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up {
            movement = movementDistance
        }
        else {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        self.animateTextField(textField: fieldLatitude, up:true)
        self.animateTextField(textField: fieldLongitude, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        self.animateTextField(textField: fieldLatitude, up:false)
        self.animateTextField(textField: fieldLongitude, up:false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        fieldLongitude.resignFirstResponder()
        fieldLatitude.resignFirstResponder()
        return false
    }
}

