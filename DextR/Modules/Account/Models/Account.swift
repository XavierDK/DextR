//
//  Account.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

import Foundation
import Parse

class Account : PFUser, AccountProtocol {
  
  override class func initialize() {
    struct Static {
      static var onceToken : dispatch_once_t = 0;
    }
    dispatch_once(&Static.onceToken) {
      self.registerSubclass()
    }
  }
  
  @NSManaged var firstname : String?
  @NSManaged var lastname : String?
  @NSManaged var admin : NSNumber?
}