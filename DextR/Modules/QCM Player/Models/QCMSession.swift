//
//  QCMSession.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

class QCMSession: ParseModel, QCMSessionProtocol {
  
  var player: AccountProtocol?
  var qcm: QCMProtocol?
  var totalTime: Int?
  var questionsAnswers: Array<QuestionAnswersProtocol> = Array<QuestionAnswersProtocol>()
  
  required init?(_ map: Map) {
    super.init(map)
  }
  
  override func mapping(map: Map) {
    
    super.mapping(map)

    player      <- map["player"]
    qcm         <- map["qcm"]
    totalTime   <- map["totalTime"]
  }
  
  func addQuestionAnswer(questionAnswer: QuestionAnswersProtocol) {
    
    self.questionsAnswers.append(questionAnswer)
  }
}