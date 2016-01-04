//
//  AccountValidationService.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift

class AccountValidationService: AccountValidationProtocol {
 
  let minPasswordCount = 5
  
  func validateEmail(email: String) -> ValidationResult {
    if email.characters.count == 0 {
      return .Empty
    }
    
    let emailRegEx = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    if emailPredicate.evaluateWithObject(email) == false {
      return .Failed(message: "Email invalide")
    }
    
    return .OK(message: "Email OK")
  }
  
  
  func validatePassword(password: String) -> ValidationResult {
    let numberOfCharacters = password.characters.count
    if numberOfCharacters == 0 {
      return .Empty
    }
    
    if numberOfCharacters < minPasswordCount {
      return .Failed(message: "Le mot de passe doit contenir au moins \(minPasswordCount) caractères")
    }
    return .OK(message: "Mot de passe OK")
  }
  
  
  func validateConfirmedPassword(password: String, repeatedPassword: String) -> ValidationResult {
    if repeatedPassword.characters.count == 0 {
      return .Empty
    }
    
    if repeatedPassword == password {
      return .OK(message: "Mot de passe confirmé")
    }
    else {
      return .Failed(message: "Mot de passe différent")
    }
  }
  
  func validateFirstname(firstname: String) -> ValidationResult {
    let numberOfCharacters = firstname.characters.count
    if numberOfCharacters == 0 {
      return .Empty
    }
    return .OK(message: "Prénom OK")
  }
  
  func validateLastname(lastname: String) -> ValidationResult {
    let numberOfCharacters = lastname.characters.count
    if numberOfCharacters == 0 {
      return .Empty
    }
    return .OK(message: "Nom OK")
  }
}