//
//  QCMPlayerViewModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class QCMPlayerViewModel {
  
  let qcmPlayable: Variable<Bool> = Variable(false)
  let currentQuestion: Variable<QuestionProtocol?> = Variable(nil)
  
  var disposeBag = DisposeBag()
  
  private var currentQuestionIndex: Array<QuestionProtocol>?
  private var allQuestions: Array<QuestionProtocol>?
  
  private let qcmAPI: QCMAPIProtocol
  private var qcm: QCMProtocol
  
  init(
    input: (
    previousTap: Driver<Void>,
    nextTap: Driver<Void>,
    qcm: QCMProtocol
    ),
    dependency: (
    qcmAPI: QCMAPIProtocol,
    qcmResultAPI: QCMResultAPIProtocol,
    wireframe: Wireframe
    )
    ) {
      
      self.qcmAPI =  dependency.qcmAPI
      self.qcm = input.qcm
      
      self.qcmAPI.allQuestionsForQcm(&qcm)
        .map { (res) in
          res.modelObject
        }
        .subscribe({ (event) -> Void in
          
          switch event {
          case .Next(let array):
            if let array = array {
              
              array.toObservable()                
                .subscribe(onNext: { (question) -> Void in
                  
                  var questionTmp = question
                  self.qcmAPI.allAnswersForQuestion(&questionTmp).subscribe()
                    .addDisposableTo(self.disposeBag)
                  
                  }, onError: { (error)  in
                  
                  }, onCompleted: { () -> Void in
                      self.qcmPlayable.value = true
                  }, onDisposed: { ()  in
                    
                })
                .addDisposableTo(self.disposeBag)
              
            }
          case .Error(let error):
            break
          case .Completed:
            break
          }
        }).addDisposableTo(self.disposeBag)
  }
}