//
//  Answer.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

class Answer: ParseModel, AnswerProtocol {
 
  var title: String?
  var correct: Bool?
  var order: Int?
  
  required init?(_ map: Map) {
    super.init(map)
  }
  
  override func mapping(map: Map) {
    
    super.mapping(map)
    
    title     <- map["title"]
    correct   <- map["type"]
    order     <- map["order"]
  }

}