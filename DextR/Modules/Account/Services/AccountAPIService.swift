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
  private let logoutUrl = "https://api.parse.com/1/logout"
  
  private let currentSessionTokenKey = "__Current_Session_Token__"
  private let currentUserObjectId = "__Current_User_Object_ID__"
  
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
                
                if let sessionToken = account?.sessionToken {
                  self.saveCurrentSessionToken(sessionToken)
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
                
                if let sessionToken = account?.sessionToken {
                  self.saveCurrentSessionToken(sessionToken)
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
    
    NSUserDefaults.standardUserDefaults().setObject(sessionToken, forKey: self.currentSessionTokenKey)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  func saveUserObjectId(objectId: String) {
    
    NSUserDefaults.standardUserDefaults().setObject(objectId, forKey: self.currentUserObjectId)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  func resetCurrentSessionToken() {
    NSUserDefaults.standardUserDefaults().removeObjectForKey(self.currentSessionTokenKey)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  func currentAccount() -> Observable<RequestResult<AccountProtocol>>? {
    
    let currentSessionToken = NSUserDefaults.standardUserDefaults().objectForKey(self.currentSessionTokenKey)
    
    if let currentSessionToken = currentSessionToken as? String {
      return Observable.create { [unowned self] observer in
        let headers = [
          "X-Parse-Application-Id": AppConstant.ApplicationKey,
          "X-Parse-REST-API-Key": AppConstant.RestAPIKey,
          "X-Parse-Session-Token": currentSessionToken
        ]
        
        let request = Alamofire.request(.GET, self.currentUserUrl, parameters: nil, headers: headers)
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
                  
                  if let sessionToken = account?.sessionToken {
                    self.saveCurrentSessionToken(sessionToken)
                  }
                  if let userId = account?.objectId {
                    self.saveUserObjectId(userId)
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
    return nil
  }
  
  func logOut() -> Observable<RequestResult<AccountProtocol>>? {
    
    let currentSessionToken = NSUserDefaults.standardUserDefaults().objectForKey(self.currentSessionTokenKey)
    
    if let currentSessionToken = currentSessionToken as? String {
      return Observable.create { [unowned self] observer in
        
        let headers = [
          "X-Parse-Application-Id": AppConstant.ApplicationKey,
          "X-Parse-REST-API-Key": AppConstant.RestAPIKey,
          "X-Parse-Session-Token": currentSessionToken
        ]
        
        let request = Alamofire.request(.POST, self.logoutUrl, parameters: nil, headers: headers)
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
                  
                  self.resetCurrentSessionToken()
                  
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
    return nil
  }
}