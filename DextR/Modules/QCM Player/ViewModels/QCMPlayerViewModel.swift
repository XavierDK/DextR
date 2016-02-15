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
  
  var answersObservables: [Observable<RequestResult<Array<AnswerProtocol>>>] = [Observable<RequestResult<Array<AnswerProtocol>>>]()
  
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
      
//      self.qcmAPI.allQuestionsForQcm(&qcm)
//        .map { (res) in
//          res.modelObject
//        }
//        .bindTo { (array) in
      
//          if let array = array {
          
//            array
//              .subscribe(onNext: { (question) -> Void in
//                
//                var questionTmp = question
//                self.answersObservables.append(self.qcmAPI.allAnswersForQuestion(&questionTmp))
//                
//                }, onError: { (error)  in
//                  
//                }, onCompleted: { () -> Void in
//                  
//                  self.answersObservables.concat()
//                    .subscribe(onNext: { (res) -> Void in
//                      }, onError: { (error) -> Void in
//                      }, onCompleted: { () -> Void in
//                        self.qcmPlayable.value = true
//                      }, onDisposed: { () -> Void in
//                    }).addDisposableTo(self.disposeBag)
//                }, onDisposed: { ()  in
//                  
//              })
//              .addDisposableTo(self.disposeBag)
//          }
//        }
//        .addDisposableTo(self.disposeBag)
      
      self.qcmAPI.allQuestionsForQcm(&qcm)
        .map { (res) in
          res.modelObject
        }
        .subscribeNext { (array) in
          
          if let array = array {
            
            array.toObservable()
              .subscribe(onNext: { (question) -> Void in
                
                var questionTmp = question
                self.answersObservables.append(self.qcmAPI.allAnswersForQuestion(&questionTmp))
                
                }, onError: { (error)  in
                  
                }, onCompleted: { () -> Void in
                  
                  self.answersObservables.concat()
                    .subscribe(onNext: { (res) -> Void in
                      }, onError: { (error) -> Void in
                      }, onCompleted: { () -> Void in
                        self.qcmPlayable.value = true
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