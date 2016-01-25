//
//  QCMProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

protocol QCMProtocol: ParseProtocolModel {
  
  var name : String? {get set}
  var duration : Int? {get set}
  var questions: Array<QuestionProtocol> {get set}
}