//
//  QCM.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import Parse

class QCM: PFObject, PFSubclassing, QCMProtocol {
  
  override class func initialize() {
    struct Static {
      static var onceToken : dispatch_once_t = 0;
    }
    dispatch_once(&Static.onceToken) {
      self.registerSubclass()
    }
  }
  
  static func parseClassName() -> String {
    return "QCM"
  }
  
  @NSManaged var name: String?
  @NSManaged var duration: Int
  @NSManaged var questions: [Question]?
  
  var qcmQuestions: [QuestionProtocol]? {
    return questions
  }
  
  func addQuestion(qcmQuestion: QuestionProtocol) {
    if let quest = qcmQuestion as? Question {
      if var questions = questions {
        questions.append(quest)
      }
      else {
        questions = [quest]
      }
    }
  }
}