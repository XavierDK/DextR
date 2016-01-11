//
//  QCMViewModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class QCMPresenterViewModel {
  
  var disposeBag = DisposeBag()
  
  let name: Variable<String> = Variable("")
  let duration: Variable<Int> = Variable(0)
  let questions: Variable<Array<QuestionProtocol>> = Variable([])
  
  init(
    qcm: QCMProtocol,
    dependency: (
    API: QCMAPIProtocol,
    wireframe: Wireframe
    )
    ) {
      if let qcmName = qcm.name {
        name.value = qcmName
      }
      
      duration.value = qcm.duration
      
      if let qcmQuestions = qcm.qcmQuestions {
        questions.value = qcmQuestions
      }
  }
}
