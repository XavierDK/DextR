//
//  QCMAPIService.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import Parse
import RxSwift
import Alamofire
import ObjectMapper

class QCMAPIService: QCMAPIProtocol {
  
  private let qcmUrl = "https://api.parse.com/1/classes/QCM"
  
  func createQCM(name: String, duration: String) -> Observable<RequestResult<QCMProtocol>> {
    
    return Observable.create { [unowned self] observer in
      
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey,
        "X-Parse-Revocable-Session": "1",
        "Content-Type": "application/json"
      ]
      
      let parameters = [
        "name": name,
        "duration": duration
      ]
      
      let request = Alamofire.request(.POST, self.qcmUrl, parameters: parameters, encoding: .JSON, headers: headers)
        .responseJSON(completionHandler: { response -> Void in
          
          if let error = response.result.error {
            observer.onError(error)
          }
          else {
            print (response.result.value)
            
            if let value = response.result.value {
              if let code = value["code"] as? Int,
                let message = value["error"] as? String {
                  observer.on(.Next(RequestResult<QCMProtocol>(isSuccess: false, code: code, message: message, modelObject: nil)))
              }
              else {
                let qcm = Mapper<QCM>().map(value)
                observer.on(.Next(RequestResult<QCMProtocol>(isSuccess: true, code: nil, message: nil, modelObject: qcm)))
              }
            }
            observer.on(.Completed)
          }
        })
      return AnonymousDisposable({
        request.cancel()
      })
    }
  }
  
  func saveQuestionForQcm(title: String, type: String, qcm: QCMProtocol) -> Observable<Bool> {
    
    let questionType = QuestionType.valueFromString(type)
  
    let question = Question()
    question.title = title
    question.type = questionType.rawValue
    qcm.addQuestion(question)
    
    if let qcm = qcm as? QCM {
      self.saveQCM(qcm)
    }
    
    return question.rx_save()
  }
  
  func saveAnswerForQuestion(title: String, correct: Bool, question: QuestionProtocol) -> Observable<Bool> {
    
    let answer = Answer()
    answer.title = title
    answer.correct = correct
    return answer.rx_save()
  }
  
  func allQcms() -> Observable<[QCMProtocol]?> {
    
    return Observable.create { [unowned self] observer in
      
      return AnonymousDisposable({})
    }

  }
  
  func saveQCM(qcm: QCM) {
//    qcm.saveInBackground()
  }
}

//func saveQCM(name: String, duration: String) -> Observable<Bool>
//func saveQuestionForQcm(name: String, type: String, qcm: QCMProtocol) -> Observable<Bool>
//func saveAnswerForQuestion(name: String, correct: Bool, question: QuestionProtocol) -> Observable<Bool>