//
//  ParseHelper.swift
//  DextR
//
//  Created by Xavier De Koninck on 21/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

class ParseHelper {

  static  func createJsonPointer(className: String, objectId: String) -> [String: String] {
    
    return ["__type": "Pointer", "className": className, "objectId": objectId]    
  }
  
  static  func createStringPointer(className: String, objectId: String) -> String {
    
    return "{\"__type\":\"Pointer\",\"className\":\"\(className)\",\"objectId\":\"\(objectId)\"}"
  }
}