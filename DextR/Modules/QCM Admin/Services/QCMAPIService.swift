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
  private let questionUrl = "https://api.parse.com/1/classes/Question"
  
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
  
  func createQuestionForQcm(title: String, type: QuestionType, qcm: QCMProtocol) -> Observable<RequestResult<QuestionProtocol>> {
    
    return Observable.create { [unowned self] observer in
      
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey,
        "X-Parse-Revocable-Session": "1",
        "Content-Type": "application/json"
      ]
      
      let parameters = [
        "title": title,
        "type": type.rawValue
      ]
      
      let request = Alamofire.request(.POST, self.questionUrl, parameters: parameters as? [String:AnyObject], encoding: .JSON, headers: headers)
        .responseJSON(completionHandler: { response -> Void in
          
          if let error = response.result.error {
            observer.onError(error)
          }
          else {
            print (response.result.value)
            
            if let value = response.result.value {
              if let code = value["code"] as? Int,
                let message = value["error"] as? String {
                  observer.on(.Next(RequestResult<QuestionProtocol>(isSuccess: false, code: code, message: message, modelObject: nil)))
              }
              else {
                let question = Mapper<Question>().map(value)
                observer.on(.Next(RequestResult<QuestionProtocol>(isSuccess: true, code: nil, message: nil, modelObject: question)))
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
  
  func saveAnswerForQuestion(title: String, correct: Bool, question: QuestionProtocol) -> Observable<Bool> {
    
    return Observable.create { [unowned self] observer in
 
      return AnonymousDisposable({
 
      })
    }

  }
  
  func allQcms() -> Observable<RequestResult<Array<QCMProtocol>>> {
    
    return Observable.create { [unowned self] observer in
      
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey
      ]
      
      let request = Alamofire.request(.GET, self.qcmUrl, parameters: nil, encoding: .JSON, headers: headers)
        .responseJSON(completionHandler: { response -> Void in
          
          if let error = response.result.error {
            observer.onError(error)
          }
          else {
            print (response.result.value)
            
            if let value = response.result.value {
              if let code = value["code"] as? Int,
                let message = value["error"] as? String {
                  observer.on(.Next(RequestResult<Array<QCMProtocol>>(isSuccess: false, code: code, message: message, modelObject: nil)))
              }
              else {
                var arrayQcms = Array<QCMProtocol>()
                if let results = value["results"] {
                  if let results = results as? Array<[String:AnyObject]> {
                    for qcmJson in results {
                      let qcm = Mapper<QCM>().map(qcmJson)
                      if let qcm = qcm {
                        arrayQcms.append(qcm)
                      }
                    }
                  }
                }
                observer.on(.Next(RequestResult<Array<QCMProtocol>>(isSuccess: true, code: nil, message: nil, modelObject: arrayQcms)))
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
  
  func saveQCM(qcm: QCM) {
    //    qcm.saveInBackground()
  }
}

//func saveQCM(name: String, duration: String) -> Observable<Bool>
//func saveQuestionForQcm(name: String, type: String, qcm: QCMProtocol) -> Observable<Bool>
//func saveAnswerForQuestion(name: String, correct: Bool, question: QuestionProtocol) -> Observable<Bool>