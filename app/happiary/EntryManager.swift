//
//  EntryManager.swift
//  happiary
//
//  Created by Martí Serra Vivancos on 30/01/16.
//  Copyright © 2016 Sadir. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/*class Entry: Object {
    dynamic var date = NSDate(timeIntervalSince1970: 1)
    dynamic var score = 0
    dynamic var text = ""
    dynamic var backgroundImage = ""
    dynamic var faceImage = ""
    dynamic var shirtImage = ""
}*/

class Entry : NSObject, NSCopying {
    var date : NSDate
    var score : Double
    var text : String
    var backgroundImage : String
    var faceImage : Array<String>
    var shirtText : String
    
    required override init() {
        self.date = NSDate()
        self.score = 0.0
        self.text = ""
        self.backgroundImage = ""
        self.faceImage = Array<String>()
        self.shirtText = ""
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let theCopy = self.dynamicType.init()
        theCopy.date = self.date
        theCopy.score = self.score
        theCopy.text = self.text
        theCopy.backgroundImage = self.backgroundImage
        theCopy.faceImage = Array<String>(self.faceImage)
        theCopy.shirtText = self.shirtText
        
        return theCopy
    }
}

class EntryManager: NSObject {
    
    var entriesArray = [Entry]()
    
    static let sharedInstance = EntryManager()
    
    func saveEntry(text: String, date: NSDate, completion: (result: Entry) -> Void) {
        Alamofire.request(.POST, "https://hackcambridge-3253.appspot.com/entry", parameters: ["text": text])
            .responseData { response in

            let json = JSON(data: response.data!)
            let newEntry = Entry()
            newEntry.text = text

            if let score = json["score"].double {
                newEntry.score = score
            }
            
            print(json)
                
            if let backgroundUrl = json["entities"]["places_eng"][0]["additional_information"]["image"].string {
                newEntry.backgroundImage = backgroundUrl
            }
                
                
            if let faces = json["entities"]["people_eng"].array {
                for (var i = 0; i<faces.count; i++) {
                    newEntry.faceImage.append(faces[i]["additional_information"]["image"].string!)
                }
            }
                
            if let company = json["entities"]["companies_eng"][0]["normalized_text"].string {
                newEntry.shirtText = company
            }
            self.entriesArray.append(newEntry.copy() as! Entry)
            completion(result: newEntry)

        }
        
    }
    
}
