//
//  AccountSignUpViewModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AccountSignUpViewModel {
  
  let validatedEmail: Driver<ValidationResult>
  let validatedPassword: Driver<ValidationResult>
  let validatedPasswordRepeated: Driver<ValidationResult>
  let validatedLastname: Driver<ValidationResult>
  let validatedFirstname: Driver<ValidationResult>
  
  let signupEnabled: Driver<Bool>
  
  let signupIn: Driver<Bool>
  let signingUp: Driver<Bool>
  
  init(
    input: (
    email: Driver<String>,
    password: Driver<String>,
    repeatedPassword: Driver<String>,
    lastname: Driver<String>,
    firstname: Driver<String>,
    signupTaps: Driver<Void>
    ),
    dependency: (
    API: AccountAPIProtocol,
    validationService: AccountValidationProtocol,
    wireframe: Wireframe
    )
    ) {
      
      let API = dependency.API
      let validationService = dependency.validationService
      let wireframe = dependency.wireframe
      
      validatedEmail = input.email
        .map { email in
          return validationService.validateEmail(email)
      }
      
      validatedPassword = input.password
        .map { password in
          return validationService.validatePassword(password)
      }
      
      validatedPasswordRepeated = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateConfirmedPassword)
      
      validatedLastname = input.lastname
        .map { lastname in
          return validationService.validateLastname(lastname)
      }
      
      validatedFirstname = input.firstname
        .map { firstname in
          return validationService.validateFirstname(firstname)
      }
      
      let activityIndic = ActivityIndicator()
      self.signingUp = activityIndic.asDriver()
      
      let signupDatas = Driver.combineLatest(input.email, input.password, input.lastname, input.firstname) { ($0, $1, $2, $3) }
      
      signupIn = input.signupTaps.withLatestFrom(signupDatas)
        .flatMapLatest { (email, password, lastname, firstname) in
          return API.signUp(email, password: password, firstname: firstname, lastname: lastname)
            .trackActivity(activityIndic)
            .asDriver(onErrorJustReturn: false)
        }
        .flatMapLatest { signUpedIn -> Driver<Bool> in
          let message = signUpedIn ? "Inscription réussie" : "Inscription échouée"
          return wireframe.promptFor("Inscription", message: message, cancelAction: "OK", actions: [])
            .map { _ in
              signUpedIn
            }
            .asDriver(onErrorJustReturn: false)
      }
      
      signupEnabled = Driver.combineLatest(
        validatedEmail,
        validatedPassword,
        validatedPasswordRepeated,
        validatedLastname,
        validatedFirstname,
        signingUp
        )   { email, password, passwordRepeated, lastname, firstname, signingUp in
          
          if email.isValid &&
            password.isValid &&
            passwordRepeated.isValid {
              return lastname.isValid &&
                firstname.isValid &&
                !signingUp
          }
          return false
        }
        .distinctUntilChanged()
  }
  
}