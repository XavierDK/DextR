//
//  QCM.swift
//  DextR
//
//  Created by Xavier De Koninck on 19/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

class QCM: ParseModel, QCMProtocol {
  
  var name : String?
  var duration : Int?

  required init?(_ map: Map) {
    super.init(map)
  }
  
  override func mapping(map: Map) {
    
    super.mapping(map)
    
    name     <- map["name"]
    duration <- map["duration"]
  }
}