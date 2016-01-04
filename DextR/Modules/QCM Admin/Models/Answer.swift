//
//  Answer.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import Parse

class Answer: PFObject, PFSubclassing, AnswerProtocol {
 
  override class func initialize() {
    struct Static {
      static var onceToken : dispatch_once_t = 0;
    }
    dispatch_once(&Static.onceToken) {
      self.registerSubclass()
    }
  }
  
  static func parseClassName() -> String {
    return "Answer"
  }
  
  var questionParent : QuestionProtocol? {
    return question
  }
  
  @NSManaged var title: String?
  @NSManaged var correct: Bool
  @NSManaged var question: Question?
}