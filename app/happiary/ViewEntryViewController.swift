//
//  ViewEntryViewController.swift
//  happiary
//
//  Created by Martí Serra Vivancos on 31/01/16.
//  Copyright © 2016 Sadir. All rights reserved.
//

import UIKit
import Auk

class ViewEntryViewController: UIViewController {
    
    var entry = Entry()
    
    @IBOutlet weak var happinnessLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryText: UITextView!
    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var slideShow: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        let string = dateFormatter.stringFromDate(entry.date)
        
        dateLabel.text = "Date: " + string
        entryText.text = entry.text
                
        //self.backgroundImage.contentMode = .Center
        downloadImage(NSURL(string: self.entry.backgroundImage)!, imageView: self.backgroundImage)
        
        for (var i = 0; i<self.entry.faceImage.count; i++) {
            self.slideShow.auk.show(url: self.entry.faceImage[i])
        }
        
        let score = round(entry.score*100)/100
        if (score > 0) {
            self.happinnessLabel.text = "Hapiness score: " + String(score)
        } else {
            self.happinnessLabel.text = "Sadness score: " + String(score)
        }
    }

    
    func downloadImage(url: NSURL, imageView: UIImageView){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                let image = UIImage(data: data)
                let width = image!.size.width
                let height = image!.size.height;
                let apect = width/height;
                
                let nHeight = imageView.frame.size.width/apect;
                self.imageHeightConstraint.constant = nHeight;
                [self ]
                imageView.image = image
                
            }
        }
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
