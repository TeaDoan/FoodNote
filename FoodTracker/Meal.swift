//
//  Meal.swift
//  FoodTracker
//
//  Created by Thao Doan on 4/17/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Meal: NSObject,NSCoding {
    
        var name : String
        var photo : UIImage?
        var rating : Int
        init?(name:String,photo:UIImage?, rating: Int) {
    
            // the name property must not be empty
            guard !name.isEmpty else {
                return nil
            }
    
            // The rating must be between 0 and 5 inclusively
            guard (rating >= 0) && (rating <= 5) else {
                return nil
            }
    
            self.name = name
            self.photo = photo
            self.rating = rating
    
        }
    
    //Mark: NSCoding
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
    }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)


}
     //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
}


struct PropertyKey {
    
    static let name = "name"
    static let photo = "photo"
    static let rating = "rating"
}







