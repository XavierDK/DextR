//
//  Account.swift
//  DextR
//
//  Created by Xavier De Koninck on 19/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

class Account: ParseModel, AccountProtocol {
  
  var email : String?
  var firstname : String?
  var lastname : String?
  var password : String?
  var sessionToken : String?
  var admin : Bool?
  
  required init?(_ map: Map) {
    
    super.init(map)
  }
  
  override func mapping(map: Map) {
    
    super.mapping(map)
    
    email         <- map["email"]
    firstname     <- map["firstname"]
    lastname      <- map["lastname"]
    password      <- map["password"]
    sessionToken  <- map["sessionToken"]
    admin         <- map["admin"]
  }
}