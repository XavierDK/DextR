//
//  QCMResultatsViewModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 18/03/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class QCMResultatsViewModel {
  
  var disposeBag = DisposeBag()
  
  let qcmAPI: QCMAPIProtocol
  let qcmSessionAPI: QCMResultAPIProtocol
  let accountAPI: AccountAPIProtocol
  let qcm: QCMProtocol
  
  var questionAnswersRequestsObservables: [Observable<RequestResult<Array<QuestionAnswersProtocol>>>] = [Observable<RequestResult<Array<QuestionAnswersProtocol>>>]()
  var answersResultsRequestsObservables: [Observable<RequestResult<Array<AnswerResultProtocol>>>] = [Observable<RequestResult<Array<AnswerResultProtocol>>>]()
  
  init(
    qcm: QCMProtocol,
    dependency: (
    qcmAPI: QCMAPIProtocol,
    qcmSessionAPI: QCMResultAPIProtocol,
    accountAPI: AccountAPIProtocol,
    wireframe: Wireframe
    )
    ) {
      self.qcm = qcm
      self.qcmAPI = dependency.qcmAPI
      self.qcmSessionAPI = dependency.qcmSessionAPI
      self.accountAPI = dependency.accountAPI
      
      self.reloadSessions()
  }
  
  func reloadSessions() {
    
    self.qcmSessionAPI.allSessionForQcm(self.qcm)
      .map { (res) in
        res.modelObject
      }
      .subscribeNext { (array) in
        
        if let array = array {
          
          array.toObservable()
            .subscribe(onNext: { (sess) in
              
              var sessionTmp = sess
              self.questionAnswersRequestsObservables.append(self.qcmSessionAPI.allQuestionsAnswersForSession(&sessionTmp))
              
              }, onError: { (error)  in
                
              }, onCompleted: { () -> Void in
                
                self.questionAnswersRequestsObservables.concat()
                  //                  .trackActivity(self.activityIndicPlayer)
                  .subscribe(onNext: { (res) -> Void in
                    }, onError: { (error) -> Void in
                    }, onCompleted: { () -> Void in
//                      self.questionsVariables.value.appendContentsOf(array)
//                      self.qcmPlayable.value = true
                    }, onDisposed: { () -> Void in
                  }).addDisposableTo(self.disposeBag)
              }, onDisposed: { ()  in
                
            })
            .addDisposableTo(self.disposeBag)
        }
      }
      .addDisposableTo(self.disposeBag)
  }
}