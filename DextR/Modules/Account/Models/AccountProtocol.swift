//
//  AccountProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

protocol AccountProtocol {
  
  var email : String? {get set}
  var firstname : String? {get set}
  var lastname : String? {get set}
  var password : String? {get set}
  var admin : NSNumber? {get set}
}