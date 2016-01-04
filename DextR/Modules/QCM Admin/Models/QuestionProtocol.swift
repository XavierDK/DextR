//
//  QuestionProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

enum QuestionType: String {
  case Unknown = ""
}

protocol QuestionProtocol {
  
  var title : String? {get set}
  var questionType : QuestionType {get set}
  var qcmParent : QCMProtocol? {get}
  var qcmAnswers : [AnswerProtocol]? {get}
  
  func addAnswer(qcmAnswer: AnswerProtocol)
}