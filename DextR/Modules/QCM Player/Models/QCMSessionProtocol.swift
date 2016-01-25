//
//  QCMSessionProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

protocol QCMSessionProtocol : ParseProtocolModel {
  
  var player: AccountProtocol? {get set}
  var qcm: QCMProtocol? {get set}
  var totalTime: Int? {get set}
  var questionsAnswers: Array<QuestionAnswersProtocol> {get set}
  
  func addQuestionAnswer(questionAnswer: QuestionAnswersProtocol) 
}