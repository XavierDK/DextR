//
//  AnswerProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

@objc protocol AnswerProtocol {
  
  var title : String? {get set}
  var correct : Bool {get set}
  var questionParent : QuestionProtocol? {get}
}