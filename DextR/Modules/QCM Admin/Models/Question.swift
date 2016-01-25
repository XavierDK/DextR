//
//  Question.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

class Question: ParseModel, QuestionProtocol {
    
  var title : String?
  var type : QuestionType?
  var order : Int?
  var answers: Array<AnswerProtocol> = Array<AnswerProtocol>()
  
  required init?(_ map: Map) {
    super.init(map)
  }
  
  override func mapping(map: Map) {
    
    super.mapping(map)
    
    let transform = TransformOf<QuestionType, Int>(fromJSON: { (value: Int?) -> QuestionType? in
      
      if let value = value {
        let questionType = QuestionType(rawValue: value)
        if let questionType = questionType {
          return questionType
        }
      }
      return .Unknown
      
      }, toJSON: { (value: QuestionType?) -> Int? in
      
        if let value = value {
          return value.rawValue
        }
        return 0
    })
    
    title   <- map["title"]
    type    <- (map["type"], transform)
    order   <- map["order"]
    answers <- map["answers"]
  }
}