//
//  QuestionAnswers.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

class QuestionAnswers: ParseModel, QuestionAnswersProtocol {
  
  var qcmSession: QCMSessionProtocol?
  var question: QuestionProtocol?
  var answersResult: Array<AnswerResultProtocol> = Array<AnswerResultProtocol>()
  
  required init?(_ map: Map) {
    super.init(map)
  }
  
  override func mapping(map: Map) {
    
    super.mapping(map)
    
    qcmSession      <- map["qcmSession"]
    question        <- map["question"]
    answersResult   <- map["answersResult"]
  }
  
  func addAnswerResult(answerResult: AnswerResultProtocol) {
    
    self.answersResult.append(answerResult)
  }
}