//
//  Question.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

class Question: QuestionProtocol, Mappable {
    
  var title : String?
  var type : QuestionType?
  
  required init?(_ map: Map) {
    
  }
  
  func mapping(map: Map) {
    
    let transform = TransformOf<QuestionType, Int>(fromJSON: { (value: Int?) -> QuestionType? in
      
      if let value = value {
        let questionType = QuestionType(rawValue: value)
        if let questionType = questionType {
          return questionType
        }
      }
      return .Unknown
      
      }, toJSON: { (value: QuestionType?) -> Int? in
        // transform value from Int? to String?
        if let value = value {
          return value.rawValue
        }
        return 0
    })
    
    title <- map["title"]
    type  <- (map["type"], transform)
  }
}