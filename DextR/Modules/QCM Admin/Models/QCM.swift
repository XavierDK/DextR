//
//  QCM.swift
//  DextR
//
//  Created by Xavier De Koninck on 19/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

struct QCM: QCMProtocol, Mappable {
  
  var name : String?
  var duration : Int?

  init?(_ map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    
    name     <- map["name"]
    duration <- map["duration"]
  }
}