//
//  QCMValidationService.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift

class QCMValidationService: QCMValidationProtocol {
  
  func validateQCMName(name: String) -> ValidationResult {
  
    if name.characters.count == 0 {
      return .Empty
    }
    return .OK(message: "Nom OK")
  }
  
  func validateDuration(duration: String) -> ValidationResult {
    
    if duration.characters.count == 0 {
      return .Empty
    }
    
    guard (Int(duration) != nil) else {
      return .Failed(message: "La durée doit être un nombre en minutes")
    }
    return .OK(message: "Durée OK")
  }
  
  func validateQuestionTitle(title: String) -> ValidationResult {
    
    if title.characters.count == 0 {
      return .Empty
    }
    return .OK(message: "Titre OK")
  }
  
  func validateQuestionType(type: String) -> ValidationResult {
  
    if type.characters.count == 0 {
      return .Empty
    }
    return .OK(message: "Type OK")
  }
  
  func validateAnswerTitle(title: String) -> ValidationResult {
  
    if title.characters.count == 0 {
      return .Empty
    }
    return .OK(message: "Titre OK")
  }
}
