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

class ALMAccountAPIService {
  
  private let loginUrl = "https://api.parse.com/1/login"
  
  func logIn(email: String, password: String) -> Observable<Bool> {
    
    return Observable.create { [unowned self] observer in
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey
      ]
      
      let parameters = [
        "username": email,
        "password": password
      ]
      
      let request = Alamofire.request(.GET, self.loginUrl, parameters: parameters, headers: headers)
        .response(completionHandler: { (request, response, data, error) -> Void in
          
          debugPrint(response)
          
          if let error = error {
            observer.onError(error)
          }
          else {
            observer.on(.Next(true))
            observer.on(.Completed)
          }
        })
      return AnonymousDisposable({
        request.cancel()
      })
    }
  }
  
  //  func signUp(email: String, password: String, firstname: String, lastname: String) -> Observable<Bool> {
  //
  //  }
  //
  //  func currentAccount() -> AccountProtocol? {
  //
  //  }
  //
  //  func logOut() {
  //   
  //  }
}