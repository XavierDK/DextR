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
  
  static func convertString(str: String) -> QuestionType {
    
    var questionType: QuestionType = .Unknown
    switch str {
    case "Vrai/Faux":
      questionType = .TrueFalse
      break
    case "Séléction":
      questionType = .Selection
      break
    default:
      break
    }
    return questionType
  }
}

protocol QuestionProtocol {
  
  var title : String? {get set}
  var type : QuestionType? {get set}
}