//
//  QuestionAnswersProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

protocol QuestionAnswersProtocol : ParseProtocolModel {
  
  var qcmSession: QCMSessionProtocol? {get set}
  var question: QuestionProtocol? {get set}
  var answersResult: Array<AnswerResultProtocol> {get set}
  
  func addAnswerResult(answerResult: AnswerResultProtocol)
}