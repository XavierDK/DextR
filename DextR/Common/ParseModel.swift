//
//  ParseModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 21/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

struct ParseModel: Mappable {
  
  var objectId: String?
  var createdAt: NSDate?
  var updatedAt: NSDate?
  
  let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
  
  init?(_ map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    
    let transform = TransformOf<NSDate, String>(fromJSON: { (value: String?) -> NSDate? in
      
      if let value = value {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = self.dateFormat
        if let datePublished = dateFormatter.dateFromString(value) {
          return datePublished
        }
      }
      return nil
      
      }, toJSON: { (value: NSDate?) -> String? in
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = self.dateFormat
        if let dateString = dateFormatter.dateFromString(dateString) {
          return datePublished
        }
    })

    
    objectId     <- map["objectId"]
    createdAt    <- map["duration"]
  }
}