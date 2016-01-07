//
//  Question.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import Parse

class Question: PFObject, PFSubclassing, QuestionProtocol {
  
  override class func initialize() {
    struct Static {
      static var onceToken : dispatch_once_t = 0;
    }
    dispatch_once(&Static.onceToken) {
      self.registerSubclass()
    }
  }
  
  static func parseClassName() -> String {
    return "Question"
  }
  
  var qcmParent : QCMProtocol? {
    return qcm
  }
  
  var qcmAnswers : [AnswerProtocol]?  {
    return answers
  }
    
  func addAnswer(qcmAnswer: AnswerProtocol) {
    if let answ = qcmAnswer as? Answer {
      if var answers = answers {
        answers.append(answ)
      }
      else {
        answers = [answ]
      }
    }
  }
  
  var questionType: String {
    
    return ""
  }
  
//  var questionType: QuestionType {
//    get {
//      if let t = type {
//        if let qt = QuestionType(rawValue: t) {
//          return qt
//        }
//      }
//      return .Unknown
//    }
//    set {      
//      type = newValue.rawValue
//    }
//  }
  
  @NSManaged var title : String?
  @NSManaged var type : String?
  @NSManaged var qcm: QCM?
  @NSManaged var answers: [Answer]?
}