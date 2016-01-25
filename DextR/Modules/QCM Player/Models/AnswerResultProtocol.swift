//
//  AnswerResultProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

protocol AnswerResultProtocol : ParseProtocolModel {
  
  var answer : AnswerProtocol? {get set}
  var selected : Bool? {get set}
}