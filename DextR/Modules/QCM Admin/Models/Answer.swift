//
//  Answer.swift
//  DextR
//
//  Created by Xavier De Koninck on 03/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import Parse

class Answer: AnswerProtocol {
 
  @NSManaged var title: String?
  @NSManaged var correct: Bool
}