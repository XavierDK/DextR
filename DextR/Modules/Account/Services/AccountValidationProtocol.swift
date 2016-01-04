//
//  AccountValidationProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

protocol AccountValidationProtocol {
  
  func validateEmail(email: String) -> ValidationResult
  func validatePassword(password: String) -> ValidationResult
  func validateConfirmedPassword(password: String, repeatedPassword: String) -> ValidationResult
  func validateFirstname(firstname: String) -> ValidationResult
  func validateLastname(lastname: String) -> ValidationResult
}