//
//  Assembly.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import Swinject

extension SwinjectStoryboard {
  
  class func setup() {
    
    self.setupAccount()
  }
  
  class func setupAccount() {
  
    defaultContainer.register(AccountValidationProtocol.self) { _ in AccountValidationService() }
    defaultContainer.register(AccountAPIProtocol.self) { _ in AccountAPIService() }
    defaultContainer.register(Wireframe.self) { _ in DefaultWireframe() }
    
    defaultContainer.registerForStoryboard(AccountLogInViewer.self) { r, c in
      c.API = r.resolve(AccountAPIProtocol.self)
      c.validationService = r.resolve(AccountValidationProtocol.self)
      c.wireframe = r.resolve(Wireframe.self)
    }
    
    defaultContainer.registerForStoryboard(AccountSignUpViewer.self) { r, c in
      c.API = r.resolve(AccountAPIProtocol.self)
      c.validationService = r.resolve(AccountValidationProtocol.self)
      c.wireframe = r.resolve(Wireframe.self)
    }
  }
}