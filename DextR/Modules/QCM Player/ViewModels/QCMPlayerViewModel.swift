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
  
  let activityIndicPlayer: ActivityIndicator
  let datasReceiving: Driver<Bool>
  let qcmPlayable: Variable<Bool> = Variable(false)
  let qcmStarted: Variable<Bool> = Variable(false)
  let currentQuestion: Variable<QuestionProtocol?> = Variable(nil)

  var questionsVariables: Variable<Array<QuestionProtocol>>
  var answersRequestsObservables: [Observable<RequestResult<Array<AnswerProtocol>>>] = [Observable<RequestResult<Array<AnswerProtocol>>>]()
  
  var disposeBag = DisposeBag()
  
  var qcmSession : QCMSession = QCMSession()
  
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
      
      self.activityIndicPlayer = ActivityIndicator()
      self.datasReceiving = activityIndicPlayer.asDriver()
      
      self.questionsVariables = Variable([QuestionProtocol]())
      
      self.loadQuestionsAndAnswers()
  }
  
  func loadQuestionsAndAnswers() {
    
    self.qcmAPI.allQuestionsForQcm(&qcm)
      .map { (res) in
        res.modelObject
      }
      .subscribeNext { (array) in
        
        if let array = array {
          
          array.toObservable()
            .subscribe(onNext: { (question) -> Void in
              
              var questionTmp = question
              self.answersRequestsObservables.append(self.qcmAPI.allAnswersForQuestion(&questionTmp))
              
              }, onError: { (error)  in
                
              }, onCompleted: { () -> Void in
                
                self.answersRequestsObservables.concat()
                  .trackActivity(self.activityIndicPlayer)
                  .subscribe(onNext: { (res) -> Void in
                    }, onError: { (error) -> Void in
                    }, onCompleted: { () -> Void in
                      self.questionsVariables.value.appendContentsOf(array)                    
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
  
  func questionAnswersForQuestion(question: QuestionProtocol) -> QuestionAnswers {
    
    qcmSession.questionsAnswers.map { (questionAnswers) in
      
    }
    return QuestionAnswers()
  }
}