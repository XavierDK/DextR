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

class ALMAccountAPIService : AccountAPIProtocol {
  
  private let loginUrl = "https://api.parse.com/1/login"
  private let signupUrl = "https://api.parse.com/1/users"
  
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
              observer.on(.Next(RequestResult<AccountProtocol>(isSuccess: true, code: code, message: message, modelObject: nil)))
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
            
            //          if let code = response.result.value {
            observer.on(.Next(RequestResult<AccountProtocol>(isSuccess: true, code: 200, message: "", modelObject: nil)))
            //          }
            observer.on(.Completed)
          }
          
        })
      return AnonymousDisposable({
        request.cancel()
      })
    }
  }

    func currentAccount() -> AccountProtocol? {
      
      return nil
    }
  
    func logOut() {
  
    }
}