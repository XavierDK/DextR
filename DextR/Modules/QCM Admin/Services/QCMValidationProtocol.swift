//
//  QCMValidationProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

protocol QCMValidationProtocol {
  
  func validateQCMName(name: String) -> ValidationResult
  func validateDuration(duration: String) -> ValidationResult
  func validateQuestionTitle(title: String) -> ValidationResult
  func validateQuestionType(type: String) -> ValidationResult
  func validateAnswerTitle(title: String) -> ValidationResult
}