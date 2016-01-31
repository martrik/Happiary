//
//  EntryViewController.swift
//  happiary
//
//  Created by Sadir Abdulhadi on 1/30/16.
//  Copyright (c) 2016 Sadir. All rights reserved.
//

import UIKit
import EZLoadingActivity

class SaveEntryViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var entryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.entryTextView.delegate = self
        self.entryTextView.text = "How do you feel today?"
        self.entryTextView.textColor = UIColor.lightGrayColor()
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()

    }
    
    @IBAction func didTapSave(sender: AnyObject) {
        EZLoadingActivity.Settings.ActivityColor = UIColor.orangeColor()
        EZLoadingActivity.show("Analysing...", disableUI: false)

        EntryManager.sharedInstance.saveEntry(self.entryTextView.text, date: NSDate(timeIntervalSince1970: 60)) {
            (completion: Entry) in
                EZLoadingActivity.hide(success: true, animated: false)
                self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.grayColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "How do you feel today?"
            textView.textColor = UIColor.lightGrayColor()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

