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
  
  let qcms: Variable<Array<QCMProtocol>> = Variable([])
  
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
    
    API.allQcms().subscribeNext {[unowned self] (qcms) -> Void in
      if let qcms = qcms {
        self.qcms.value = qcms
      }
      }.addDisposableTo(disposeBag)
  }
}
