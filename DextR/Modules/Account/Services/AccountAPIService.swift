//
//  AccountAPIService.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import Parse

class AccountAPIService: AccountAPIProtocol {
  
  func logIn(email: String, password: String) -> Observable<Bool> {
    
    return PFUser.rx_login(email, password: password)
      .map({ (user) in
        true
      })
  }
  
  func signUp(email: String, password: String, firstname: String, lastname: String) -> Observable<Bool> {
    
    let user = Account()
    user.username = email
    user.password = password
    user.email = email
    user.firstname = firstname
    user.lastname = lastname
    user.admin = false
    
    return user.rx_signUp()
    
  }
  
  func currentAccount() -> AccountProtocol? {
    return PFUser.currentUser() as? Account
  }
  
  func logOut() {
    PFUser.logOut()
  }
}