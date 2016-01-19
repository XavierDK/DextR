//
//  QuestionProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

enum QuestionType: Int {
  case Unknown
  case Selection
  case TrueFalse
  
  static func valueFromString(str: String) -> QuestionType {
    
    if str == "Vrai/Faux" {
      return .TrueFalse
    }
    else if str == "Séléction" {
      return .Selection
    }
    
    return .Unknown
  }
}

protocol QuestionProtocol {
  
  var title : String? {get set}
  var questionType : QuestionType {get}
//  var qcmParent : QCMProtocol? {get}
  var qcmAnswers : [AnswerProtocol]? {get}
  
  func addAnswer(qcmAnswer: AnswerProtocol)
}