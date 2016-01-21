//
//  QCMMenuViewModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 07/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class QCMMenuViewModel {
  
  var disposeBag = DisposeBag()
  
  let qcms: Variable<Array<QCMProtocol>> = Variable(Array<QCMProtocol>())
  
  let API: QCMAPIProtocol
  
  init(
    dependency: (
    API: QCMAPIProtocol,
    wireframe: Wireframe
    )
    ) {
      self.API = dependency.API
      
      self.reloadQcms()
  }
  
  func reloadQcms() {
    
    API.allQcms().map({ (res) in
      res.modelObject
    })
      .subscribeNext {[weak self] (qcms) -> Void in
        
        if let qcms = qcms {
          self?.qcms.value = qcms
        }
        else {
          self?.qcms.value = []
        }
      }
      .addDisposableTo(disposeBag)
  }
}
