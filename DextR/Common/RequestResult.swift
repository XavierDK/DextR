//
//  RequestResult.swift
//  DextR
//
//  Created by Xavier De Koninck on 19/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

struct RequestResult<ModelObject> {
  
  let isSuccess: Bool
  let code: Int?
  let message: String?
  let modelObject: ModelObject?
}