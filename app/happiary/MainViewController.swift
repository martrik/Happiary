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

    @IBOutlet weak var chart: LineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        entriesTableView.delegate = self
        entriesTableView.dataSource = self
        
        self.chart.addLine([1, 1])
        self.chart.area = false
        self.chart.x.grid.visible = false
        self.chart.x.labels.visible = false
        self.chart.y.grid.visible = false
    }
    
    override func viewWillAppear(animated: Bool) {
        if EntryManager.sharedInstance.entriesArray.count > 1 {
            var serieData: [CGFloat] = []
            
            for (var i = 0; i<EntryManager.sharedInstance.entriesArray.count; i++) {
                print(CGFloat(round((EntryManager.sharedInstance.entriesArray[i].score+1)*10)))
                serieData.append(CGFloat(round((EntryManager.sharedInstance.entriesArray[i].score+1)*10)))
            }
            
            self.chart.clear()
            self.chart.addLine(serieData)

        }
        
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
        
        let score = round(EntryManager.sharedInstance.entriesArray[row].score*100)/100
        
        if (score > 0) {
            cell.detailTextLabel?.text = "Hapiness score: " + String(score)
        } else {
            cell.detailTextLabel?.text = "Sadness score: " + String(score)
        }
        
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

