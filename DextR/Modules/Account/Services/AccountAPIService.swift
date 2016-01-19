//
//  ALMAccountAPIService.swift
//  DextR
//
//  Created by Xavier De Koninck on 18/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import ObjectMapper

class AccountAPIService : AccountAPIProtocol {
  
  private let loginUrl = "https://api.parse.com/1/login"
  private let signupUrl = "https://api.parse.com/1/users"
  private let currentUserUrl = "https://api.parse.com/1/users/me"
  
  private let currentSessionToken = "__Current_Session_Token__"
  
  func logIn(email: String, password: String) -> Observable<RequestResult<AccountProtocol>> {
    
    return Observable.create { [unowned self] observer in
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey,
        "X-Parse-Revocable-Session": "1"
      ]
      
      let parameters = [
        "username": email,
        "password": password
      ]
      
      let request = Alamofire.request(.GET, self.loginUrl, parameters: parameters, headers: headers)
        .responseJSON(completionHandler: { response -> Void in
          
          if let error = response.result.error {
            observer.onError(error)
          }
          else {
            print (response.result.value)
            
            if let value = response.result.value {
              if let code = value["code"] as? Int,
                let message = value["error"] as? String {
                  observer.on(.Next(RequestResult<AccountProtocol>(isSuccess: false, code: code, message: message, modelObject: nil)))
              }
              else {
                let account = Mapper<Account>().map(value)
                
                if let account = account {
                  self.saveCurrentSessionToken(account)
                }
                
                observer.on(.Next(RequestResult<AccountProtocol>(isSuccess: true, code: nil, message: nil, modelObject: account)))
              }
            }
            observer.on(.Completed)
          }
          
        })
      return AnonymousDisposable({
        request.cancel()
      })
    }
  }
  
  func signUp(email: String, password: String, firstname: String, lastname: String) -> Observable<RequestResult<AccountProtocol>> {
    
    return Observable.create { [unowned self] observer in
      
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey,
        "X-Parse-Revocable-Session": "1",
        "Content-Type": "application/json"
      ]
      
      let parameters = [
        "username": email,
        "email": email,
        "password": password,
        "firstname": firstname,
        "lastname": lastname
      ]
      
      let request = Alamofire.request(.POST, self.signupUrl, parameters: parameters, encoding: .JSON, headers: headers)
        .responseJSON(completionHandler: { response -> Void in
          
          if let error = response.result.error {
            observer.onError(error)
          }
          else {
            print (response.result.value)
            
            if let value = response.result.value {
              if let code = value["code"] as? Int,
                let message = value["error"] as? String {
                  observer.on(.Next(RequestResult<AccountProtocol>(isSuccess: false, code: code, message: message, modelObject: nil)))
              }
              else {
                let account = Mapper<Account>().map(value)
                
                if let account = account {
                  self.saveCurrentSessionToken(account)
                }
                
                observer.on(.Next(RequestResult<AccountProtocol>(isSuccess: true, code: nil, message: nil, modelObject: account)))
              }
            }
            observer.on(.Completed)
          }
        })
      return AnonymousDisposable({
        request.cancel()
      })
    }
  }
  
  func saveCurrentSessionToken(sessionToken: String) {
    
  }
  
  func currentAccount() -> AccountProtocol? {
    
//    let currentAccount = NSUserDefaults.standardUserDefaults().objectForKey(self.currentAccountKey)
    
//    let currentAccount = Mapper<Account>().map(currentAccountJson)
    return nil
  }
  
  func logOut() {
    
  }
}