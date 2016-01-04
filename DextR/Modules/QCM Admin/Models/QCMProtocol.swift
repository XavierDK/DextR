//
//  QCMProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

protocol QCMProtocol {
  
  var name : String? {get set}
  var duration : Int {get set}
  var qcmQuestions : [QuestionProtocol]? {get}
  
  func addQuestion(qcmQuestion: QuestionProtocol)
}