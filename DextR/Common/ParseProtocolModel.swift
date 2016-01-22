//
//  ParseProtocolModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 21/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

protocol ParseProtocolModel {
  
  var objectId: String? {get set}
  var createdAt: NSDate? {get set}
  var updatedAt: NSDate? {get set}
  
}