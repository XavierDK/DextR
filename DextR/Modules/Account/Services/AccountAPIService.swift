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
  
  //  func currentAccount() -> Account? {
  //    return PFUser.currentUser() as? Account
  //  }
  //
  //  func logOut() {
  //    PFUser.logOut()
  //  }
  //
  //  func signUp(email: String, firstname: String, lastname: String, password: String, completionSuccess: (Account) -> (), completionError: (NSError) -> ()) {
  //
  //    SVProgressHUD.showWithMaskType(.Gradient)
  //
//      let user = ParseAccount()
//      user.username = email
//      user.password = password
//      user.email = email
//      user.firstname = firstname
//      user.lastname = lastname
//      user.admin = false
  //
  //    user.signUpInBackgroundWithBlock {
  //      (succeeded: Bool, error: NSError?) -> Void in
  //
  //      SVProgressHUD.dismiss()
  //      if succeeded == false {
  //        completionError(error!)
  //      } else {
  //        completionSuccess(user)
  //      }
  //    }
  //  }
  //
  //  func logIn(email: String, password: String, completionSuccess: (Account) -> (), completionError: (NSError) -> ()) {
  //
  //    SVProgressHUD.showWithMaskType(.Gradient)
  //
  //    PFUser.logInWithUsernameInBackground(email, password: password) {
  //      (user: PFUser?, error: NSError?) -> Void in
  //
  //      SVProgressHUD.dismiss()
  //      if user == nil {
  //        completionError(error!)
  //      } else if let user = user as? Account {
  //        completionSuccess(user)
  //      }
  //    }
  //  }
}