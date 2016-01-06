//
//  AccountLogInViewModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AccountLogInViewModel {
  
  let validatedEmail: Driver<ValidationResult>
  let validatedPassword: Driver<ValidationResult>
  
  let loginEnabled: Driver<Bool>
  
  let logIn: Driver<Bool>
  let logingIn: Driver<Bool>
  
  init(
      input: (
          email: Driver<String>,
          password: Driver<String>,
          loginTaps: Driver<Void>
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
      
      let activityIndic = ActivityIndicator()
      self.logingIn = activityIndic.asDriver()
      
      let emailAndPassword = Driver.combineLatest(input.email, input.password) { ($0, $1) }
      
      logIn = input.loginTaps.withLatestFrom(emailAndPassword)
        .flatMapLatest { (email, password) in
          return API.logIn(email, password: password)
            .trackActivity(activityIndic)
            .asDriver(onErrorJustReturn: false)
        }
        .flatMapLatest { loggedIn -> Driver<Bool> in
          
          let message = loggedIn ? "Connexion réussi" : "La connexion a échouée"
          return wireframe.promptFor("Connexion", message: message, cancelAction: "OK", actions: [])
            .map { _ in
              loggedIn
            }
            .asDriver(onErrorJustReturn: false)
      }
      
      loginEnabled = Driver.combineLatest(
        validatedEmail,
        validatedPassword,
        logingIn
        )   { email, password, logingIn in
          email.isValid &&
            password.isValid &&
            !logingIn
        }
        .distinctUntilChanged()
  }

}