//
//  ViewController.swift
//  FlickFinder
//
//  Created by dmikhov on 28.09.17.
//  Copyright © 2017 dmikhov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet var labelError: UILabel!
    @IBOutlet var fieldLatitude: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var fieldLongitude: UITextField!
    @IBOutlet var fieldText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
        fieldLatitude.delegate = self
        fieldLongitude.delegate = self
        fieldText.delegate = self
        loadingIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickedFindByText() {
        clearError()
        print("onClickedFindByText")
        let isValid = isTextValid()
        if(isValid) {
            let text = fieldText.text!
            var params:[[String:String]] = [[:]]
            params.append([Const.FlickrParameterKeys.SafeSearch : Const.FlickrParameterValues.UseSafeSearch])
            params.append([Const.FlickrParameterKeys.Method : Const.FlickrParameterValues.SearchMethod])
            params.append([Const.FlickrParameterKeys.Extras : Const.FlickrParameterValues.MediumURL])
            params.append([Const.FlickrParameterKeys.Format : Const.FlickrParameterValues.ResponseFormat])
            params.append([Const.FlickrParameterKeys.NoJSONCallback : Const.FlickrParameterValues.DisableJSONCallback])
            params.append([Const.FlickrParameterKeys.APIKey : Const.FlickrParameterValues.APIKey])
            params.append([Const.FlickrParameterKeys.Text : text])
            requestRandomPageSearch(params: params)
        } else {
            showError(msg: "Text is not valid")
        }
    }
    
    @IBAction func onClickedFindByCoordinates() {
        clearError()
        print("onClickedFindByCoordinates")
        let isValid = isCoordinatesValid()
        if(isValid) {
            var params:[[String:String]] = [[:]]
            params.append([Const.FlickrParameterKeys.SafeSearch : Const.FlickrParameterValues.UseSafeSearch])
            params.append([Const.FlickrParameterKeys.Method : Const.FlickrParameterValues.SearchMethod])
            params.append([Const.FlickrParameterKeys.Extras : Const.FlickrParameterValues.MediumURL])
            params.append([Const.FlickrParameterKeys.Format : Const.FlickrParameterValues.ResponseFormat])
            params.append([Const.FlickrParameterKeys.NoJSONCallback : Const.FlickrParameterValues.DisableJSONCallback])
            params.append([Const.FlickrParameterKeys.APIKey : Const.FlickrParameterValues.APIKey])
            params.append([Const.FlickrParameterKeys.BoundingBox : bboxString()])
            requestRandomPageSearch(params: params)
        } else {
            showError(msg: "Coordinates is not valid")
        }
    }
    
    func requestSearch(params:[[String:String]], randomPageNumber: Int) {
        print("requestSearch at page ", randomPageNumber)
        var extraParams = params
        extraParams.append([Const.FlickrParameterKeys.Page : "\(randomPageNumber)"])
        let url = getRequestUrlByParams(params: extraParams)
        print("url ", url)
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if (error == nil) {
                if let data = data {
                    let parsedResult:[String:AnyObject]
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                        let photosDictionary = parsedResult[Const.FlickrResponseKeys.Photos] as! [String:AnyObject]
                        let photosArray = photosDictionary[Const.FlickrResponseKeys.Photo] as! [[String:AnyObject]]
                        let randomNumber = Int(arc4random_uniform((UInt32(photosArray.count))))
                        let photo = photosArray[randomNumber]
                        let url = photo[Const.FlickrResponseKeys.MediumURL] as! String
                        self.showImage(url: url)
                    } catch {
                        
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
            
            
        }
        task.resume()
    }
    
    func requestRandomPageSearch(params:[[String:String]]) {
        print("requestRandomPageSearch")
        self.loadingIndicator.startAnimating()
        let url = getRequestUrlByParams(params: params)
        print("url ", url)
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if (error == nil) {
                if let data = data {
                    let parsedResult:[String:AnyObject]
                    do {
                        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
                        let photosDictionary = parsedResult[Const.FlickrResponseKeys.Photos] as! [String:AnyObject]
                        let pages = min(photosDictionary[Const.FlickrResponseKeys.Pages] as! UInt32, 40)
                        let randomPageNumber = Int(arc4random_uniform((pages))) + 1
                        self.requestSearch(params: params, randomPageNumber: randomPageNumber)
                    } catch {
                        
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
            
            
        }
        task.resume()
    }
    
    private func showImage(url: String) {
        let imageUrl = URL(string: url)!
        let task = URLSession.shared.dataTask(with: imageUrl) {
            (data, resp, error) in
            DispatchQueue.main.async {
                if error == nil {
                    let downloadedImage = UIImage(data: data!)
                    self.imageView.image = downloadedImage
                    print("Successfully loaded!")
                } else {
                    print("Error on loading!")
                }
                self.loadingIndicator.stopAnimating()
                
            }
        }
        
        task.resume()
    }
    
    func getRequestUrlByParams(params:[[String:String]]) -> URL {
        var components = URLComponents()
        components.scheme = Const.Flickr.APIScheme
        components.host = Const.Flickr.APIHost
        components.path = Const.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for param in params {
            for (key, value) in param {
                let item = URLQueryItem(name: key, value: value)
                components.queryItems?.append(item)
            }
        }
        
        return components.url!
    }
    
    private func bboxString() -> String {
        let lat = Double(fieldLatitude.text!)!
        let lon = Double(fieldLongitude.text!)!
        let x1 = max(lat - Const.Flickr.SearchBBoxHalfHeight, Const.Flickr.SearchLatRange.0)
        let y1 = max(lon - Const.Flickr.SearchBBoxHalfWidth, Const.Flickr.SearchLonRange.0)
        let x2 = min(lat + Const.Flickr.SearchBBoxHalfHeight, Const.Flickr.SearchLatRange.1)
        let y2 = min(lon + Const.Flickr.SearchBBoxHalfWidth, Const.Flickr.SearchLonRange.1)
        return "\(x1),\(y1),\(x2),\(y2)"
    }
    
    // MARK: KEYBOARD
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // MARK: VALIDATE
    
    func isCoordinatesValid() -> Bool {
        if (fieldLatitude.text?.isEmpty)! || (fieldLongitude.text?.isEmpty)! {
            return false;
        }
        if (Double(fieldLongitude.text!) == nil) ||
            (Double(fieldLatitude.text!) == nil) ||
            (Double(fieldLongitude.text!)! < Const.Flickr.SearchLonRange.0) ||
            (Double(fieldLongitude.text!)! > Const.Flickr.SearchLonRange.1) ||
            (Double(fieldLatitude.text!)! < Const.Flickr.SearchLatRange.0) ||
            (Double(fieldLatitude.text!)! > Const.Flickr.SearchLatRange.1)
        {
            return false
        }
        return true
    }
    
    func isTextValid() -> Bool {
        if fieldText.text!.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    // MARK: Error showing
    
    func showError(msg: String) {
        labelError.text = msg
    }
    
    func clearError() {
        labelError.text = ""
    }
}
