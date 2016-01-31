//
//  ViewController.swift
//  happiary
//
//  Created by Sadir Abdulhadi on 1/30/16.
//  Copyright (c) 2016 Sadir. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var entriesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        entriesTableView.delegate = self
        entriesTableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        entriesTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryManager.sharedInstance.entriesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EntryCell", forIndexPath: indexPath) as UITableViewCell
        
        let row = indexPath.row
        let date = EntryManager.sharedInstance.entriesArray[row].date

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        let string = dateFormatter.stringFromDate(date)
        
        cell.textLabel?.text = "Entry of: " + string
    
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("SelectedEntry", sender: self.entriesTableView.cellForRowAtIndexPath(indexPath))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectedEntry" {
            if let cell = sender as? UITableViewCell {
                let indexPath = self.entriesTableView.indexPathForCell(cell)
                if let index = indexPath?.row {
                    if let viewEntryVC = segue.destinationViewController as? ViewEntryViewController {
                        viewEntryVC.entry = EntryManager.sharedInstance.entriesArray[index]
                    }
                }
            }
        }
    }

}

