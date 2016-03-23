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

class QCMPlayerViewModel: NSObject {
  
  let activityIndicPlayer: ActivityIndicator
  let datasReceiving: Driver<Bool>
  let qcmPlayable: Variable<Bool> = Variable(false)
  let qcmStarted: Variable<Bool> = Variable(false)
  let qcmOver: Variable<Bool> = Variable(false)
  let currentQuestion: Variable<QuestionProtocol?> = Variable(nil)
  
  var currentTimer: Variable<Int> = Variable(99)
  var startDate: NSDate? = nil
  
  var questionsVariables: Variable<Array<QuestionProtocol>>
  var answersRequestsObservables: [Observable<RequestResult<Array<AnswerProtocol>>>] = [Observable<RequestResult<Array<AnswerProtocol>>>]()
  
  var disposeBag = DisposeBag()
  
  var qcmSession : QCMSession = QCMSession()
  
  private var currentQuestionIndex: Array<QuestionProtocol>?
  private var allQuestions: Array<QuestionProtocol>?
  
  private let qcmAPI: QCMAPIProtocol
  private let qcmResultAPI: QCMResultAPIProtocol
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
      
      self.qcm = input.qcm
      self.qcmAPI =  dependency.qcmAPI
      self.qcmResultAPI = dependency.qcmResultAPI
      
      self.activityIndicPlayer = ActivityIndicator()
      self.datasReceiving = activityIndicPlayer.asDriver()
      
      self.questionsVariables = Variable([QuestionProtocol]())
      
      super.init()
      
      self.qcmStarted.asObservable().subscribeNext { (started) in
        if started {
          self.launchTimer()
        }
        }.addDisposableTo(disposeBag)
      
      self.currentTimer.asObservable()
        .subscribeNext { (timer) in
          
          if timer <= 0 && !self.qcmOver.value {
            self.qcmOver.value = true
          }
        }.addDisposableTo(disposeBag)
      
      self.qcmOver.asObservable()
        .subscribeNext { (value) in
          
          if value {
            
            let totalTime = self.qcm.duration! * 60 - self.currentTimer.value
            self.qcmSession.totalTime = totalTime
            
            self.sendSession()
          }
        }
        .addDisposableTo(disposeBag)
      
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
                      self.setupSession()
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
  
  func questionAnswersForQuestion(question: QuestionProtocol) -> QuestionAnswersProtocol {
    
    for questionAnswers in qcmSession.questionsAnswers {
      
      if let quest = questionAnswers.question{
        if quest.objectId == question.objectId {
          return questionAnswers
        }
      }
      
    }
    return QuestionAnswers()
  }
  
  func launchTimer() {
    
    self.startDate = NSDate(timeIntervalSince1970: NSTimeInterval(NSDate().timeIntervalSince1970) + NSTimeInterval(self.qcm.duration ?? 0) * 60)
    self.currentTimer.value = (self.qcm.duration ?? 0) * 60
    NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "decreaseTimer", userInfo: nil, repeats: true)
  }
  
  func decreaseTimer() {
    
    self.currentTimer.value = Int((self.startDate?.timeIntervalSince1970 ?? 0) - NSDate().timeIntervalSince1970)
  }
  
  func setupSession() {
    
    self.qcmSession.qcm = self.qcm
    
    for question in self.questionsVariables.value {
      
      let questionAnswers = QuestionAnswers()
      questionAnswers.question = question
      
      for answer in question.answers {
        
        let answerResult = AnswerResult()
        answerResult.answer = answer
        answerResult.selected = false
        questionAnswers.addAnswerResult(answerResult)
      }
      
      self.qcmSession.addQuestionAnswer(questionAnswers)
    }
  }
  
  func sendSession() {
    
    self.qcmResultAPI.sendSession(self.qcmSession)
      .subscribeNext({ (result) in
        
        for questionAnswers in self.qcmSession.questionsAnswers {
          
          self.qcmResultAPI.sendQuestionAnswers(questionAnswers, forSession: self.qcmSession)
            .subscribeNext({ (result) in
              
              for answerResult in questionAnswers.answersResult {
                self.qcmResultAPI.sendAnswerResult(answerResult, forQuestionAnswers: questionAnswers)
                  .subscribeNext({ (result) in
                    
                  }).addDisposableTo(self.disposeBag)
              }
            }).addDisposableTo(self.disposeBag)
        }
      })
      .addDisposableTo(self.disposeBag)
  }
}