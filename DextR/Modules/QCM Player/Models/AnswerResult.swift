//
//  AnswerResult.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

class AnswerResult: ParseModel, AnswerResultProtocol {
  
  var answer : AnswerProtocol?
  var selected : Bool?
  
  required init?(_ map: Map) {
    super.init(map)
  }
  
  override func mapping(map: Map) {
    
    super.mapping(map)
    
    answer      <- map["answer"]
    selected    <- map["selected"]
  }
}