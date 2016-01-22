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
  
  let API: QCMAPIProtocol
  
  let qcm: QCMProtocol
  
  init(
    qcm: QCMProtocol,
    dependency: (
    API: QCMAPIProtocol,
    wireframe: Wireframe
    )
    ) {
      
      self.qcm = qcm
      
      if let qcmName = qcm.name {
        name.value = qcmName
      }
      
      if let dur = qcm.duration {
        duration.value = dur
      }
      
      self.API = dependency.API
      
      self.reloadQuestions()
  }
  
  func reloadQuestions() {
    
    API.allQuestionsForQcm(qcm).map({ (res) in
      res.modelObject
    })
      .subscribeNext {[weak self] (questions) -> Void in
        
        if let questions = questions {
          self?.questions.value = questions
        }
        else {
          self?.questions.value = []
        }
      }
      .addDisposableTo(disposeBag)
  }
}
