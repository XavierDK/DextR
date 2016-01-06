//
//  AccountAPIService.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift

protocol AccountAPIProtocol {
  
  func logIn(email: String, password: String) -> Observable<Bool>  
  func signUp(email: String, password: String, firstname: String, lastname: String) -> Observable<Bool>
  func currentAccount() -> AccountProtocol?
  func logOut()
}