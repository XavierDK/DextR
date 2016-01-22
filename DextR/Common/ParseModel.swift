//
//  ParseModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 21/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

class ParseModel: Mappable, ParseProtocolModel {
  
  var objectId: String?
  var createdAt: NSDate?
  var updatedAt: NSDate?
  
  let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    
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
        
        if let value = value {
          let dateFormatter = NSDateFormatter()
          dateFormatter.dateFormat = self.dateFormat
          return dateFormatter.stringFromDate(value)
        }
        return nil        
    })
    
    objectId     <- map["objectId"]
    createdAt    <- (map["createdAt"], transform)
    updatedAt    <- (map["updatedAt"], transform)
  }
}