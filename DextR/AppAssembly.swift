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
    
    defaultContainer.register(AppRouter.self) { _ in AppRouter() }
    self.setupAccount()
    self.setupQCMAdmin()
    self.setupQCMPlayer()
  }
  
  class func setupAccount() {
  
    defaultContainer.register(AccountValidationProtocol.self) { _ in AccountValidationService() }
    defaultContainer.register(AccountAPIProtocol.self) { _ in AccountAPIService() }
    defaultContainer.register(Wireframe.self) { _ in DefaultWireframe() }
    
    defaultContainer.registerForStoryboard(AccountMenuViewer.self) { r, c in
      c.router = r.resolve(AppRouter.self)
      c.accountAPI = r.resolve(AccountAPIProtocol.self)
    }
    
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
  
  class func setupQCMAdmin() {
    
    defaultContainer.register(QCMValidationProtocol.self) { _ in QCMValidationService() }
    defaultContainer.register(QCMAPIProtocol.self) { _ in QCMAPIService() }
    defaultContainer.register(Wireframe.self) { _ in DefaultWireframe() }
    
    defaultContainer.registerForStoryboard(QCMMenuViewer.self) { r, c in
      c.router = r.resolve(AppRouter.self)
      c.accountAPI = r.resolve(AccountAPIProtocol.self)
      c.qcmAPI = r.resolve(QCMAPIProtocol.self)
      c.wireframe = r.resolve(Wireframe.self)
    }
    
    defaultContainer.registerForStoryboard(QCMCreatorViewer.self) { r, c in
      c.API = r.resolve(QCMAPIProtocol.self)
      c.validationService = r.resolve(QCMValidationProtocol.self)
      c.wireframe = r.resolve(Wireframe.self)
    }
    
    defaultContainer.registerForStoryboard(QuestionCreatorViewer.self) { r, c in
      c.API = r.resolve(QCMAPIProtocol.self)
      c.validationService = r.resolve(QCMValidationProtocol.self)
      c.wireframe = r.resolve(Wireframe.self)
    }
    
    defaultContainer.registerForStoryboard(AnswerCreatorViewer.self) { r, c in
      c.API = r.resolve(QCMAPIProtocol.self)
      c.validationService = r.resolve(QCMValidationProtocol.self)
      c.wireframe = r.resolve(Wireframe.self)
    }
    
    defaultContainer.registerForStoryboard(QCMPresenterViewer.self) { r, c in
      c.router = r.resolve(AppRouter.self)
      c.API = r.resolve(QCMAPIProtocol.self)
      c.wireframe = r.resolve(Wireframe.self)
    }
    
    defaultContainer.registerForStoryboard(QuestionPresenterViewer.self) { r, c in
      c.router = r.resolve(AppRouter.self)
      c.API = r.resolve(QCMAPIProtocol.self)
      c.wireframe = r.resolve(Wireframe.self)
    }
  }
  
  class func setupQCMPlayer() {
    
    defaultContainer.register(QCMResultAPIProtocol.self) { _ in QCMResultAPIService() }
    defaultContainer.register(Wireframe.self) { _ in DefaultWireframe() }
    
    defaultContainer.registerForStoryboard(QCMPlayerViewer.self) { r, c in
      c.qcmResultAPI = r.resolve(QCMResultAPIProtocol.self)
      c.qcmAPI = r.resolve(QCMAPIProtocol.self)
      c.wireframe = r.resolve(Wireframe.self)
    }
  }
}