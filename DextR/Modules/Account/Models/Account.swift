//
//  Account.swift
//  DextR
//
//  Created by Xavier De Koninck on 19/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import ObjectMapper

struct Account: AccountProtocol, Mappable {
  
  var email : String?
  var firstname : String?
  var lastname : String?
  var password : String?
  var sessionToken : String?
  var admin : Bool?
  
  init?(_ map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    
    email         <- map["email"]
    firstname     <- map["firstname"]
    lastname      <- map["lastname"]
    password      <- map["password"]
    sessionToken  <- map["sessionToken"]
    admin         <- map["admin"]
  }
}