//
//  ViewEntryViewController.swift
//  happiary
//
//  Created by Martí Serra Vivancos on 31/01/16.
//  Copyright © 2016 Sadir. All rights reserved.
//

import UIKit

class ViewEntryViewController: UIViewController {
    
    var entry = Entry()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var entryText: UITextView!
    @IBOutlet weak var backgroundImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        let string = dateFormatter.stringFromDate(entry.date)
        
        dateLabel.text = "Date: " + string
        entryText.text = entry.text
                
        self.backgroundImage.contentMode = .ScaleAspectFit
        downloadImage(NSURL(string: self.entry.backgroundImage)!, imageView: self.backgroundImage)
        

    }
    
    func downloadImage(url: NSURL, imageView: UIImageView){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                imageView.image = UIImage(data: data)
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
