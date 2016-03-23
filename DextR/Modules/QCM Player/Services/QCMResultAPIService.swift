//
//  QCMResultAPIService.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import ObjectMapper

class QCMResultAPIService: QCMResultAPIProtocol {
  
  private let currentUserObjectId = "__Current_User_Object_ID__"
  
  private let sessionUrl = "https://api.parse.com/1/classes/QCMSession"
  private let questionAnswersUrl = "https://api.parse.com/1/classes/QuestionAnswers"
  private let answerResultUrl = "https://api.parse.com/1/classes/AnswerResult"
  
  func sendSession(var session: QCMSessionProtocol) -> Observable<RequestResult<QCMSessionProtocol>> {
    
    return Observable.create { [unowned self] observer in
      
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey,
        "X-Parse-Revocable-Session": "1",
        "Content-Type": "application/json"
      ]
      
      var parameters = session.toJSON()
      if let qcmId = session.qcm?.objectId {
        parameters["qcm"] = ParseHelper.createJsonPointer("QCM", objectId: qcmId)
      }
      
      if let userId = NSUserDefaults.standardUserDefaults().objectForKey(self.currentUserObjectId) as? String {
        parameters["player"] = ParseHelper.createJsonPointer("_User", objectId: userId)
      }
      
      let request = Alamofire.request(.POST, self.sessionUrl, parameters: parameters, encoding: .JSON, headers: headers)
        .responseJSON(completionHandler: { response in
          
          if let error = response.result.error {
            observer.onError(error)
          }
          else {
            print (response.result.value)
            
            if let value = response.result.value {
              if let code = value["code"] as? Int,
                let message = value["error"] as? String {
                  observer.on(.Next(RequestResult<QCMSessionProtocol>(isSuccess: false, code: code, message: message, modelObject: nil)))
              }
              session.objectId = value["objectId"] as? String
              observer.on(.Next(RequestResult<QCMSessionProtocol>(isSuccess: true, code: nil, message: nil, modelObject: session)))
            }
            observer.on(.Completed)
          }
        })
      return AnonymousDisposable({
        request.cancel()
      })
    }
  }
  
  func sendQuestionAnswers(var questionAnswers: QuestionAnswersProtocol, forSession session: QCMSessionProtocol) -> Observable<RequestResult<QuestionAnswersProtocol>> {
    
    return Observable.create { [unowned self] observer in
      
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey,
        "X-Parse-Revocable-Session": "1",
        "Content-Type": "application/json"
      ]
      
      var parameters = questionAnswers.toJSON()
      if let sessionId = session.objectId {
        parameters["session"] = ParseHelper.createJsonPointer("QCMSession", objectId: sessionId)
      }
      
      if let questionId = questionAnswers.question?.objectId {
        parameters["question"] = ParseHelper.createJsonPointer("Question", objectId: questionId)
      }
      
      let request = Alamofire.request(.POST, self.questionAnswersUrl, parameters: parameters, encoding: .JSON, headers: headers)
        .responseJSON(completionHandler: { response in
          
          if let error = response.result.error {
            observer.onError(error)
          }
          else {
            print (response.result.value)
            
            if let value = response.result.value {
              if let code = value["code"] as? Int,
                let message = value["error"] as? String {
                  observer.on(.Next(RequestResult<QuestionAnswersProtocol>(isSuccess: false, code: code, message: message, modelObject: nil)))
              }
              questionAnswers.objectId = value["objectId"] as? String
              observer.on(.Next(RequestResult<QuestionAnswersProtocol>(isSuccess: true, code: nil, message: nil, modelObject: questionAnswers)))
            }
            observer.on(.Completed)
          }
        })
      return AnonymousDisposable({
        request.cancel()
      })
    }
  }
  
  func sendAnswerResult(var answerResult: AnswerResultProtocol, forQuestionAnswers questionAnswers: QuestionAnswersProtocol) -> Observable<RequestResult<AnswerResultProtocol>> {
    
    return Observable.create { [unowned self] observer in
      
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey,
        "X-Parse-Revocable-Session": "1",
        "Content-Type": "application/json"
      ]
      
      var parameters = answerResult.toJSON()
      if let questionAnswersId = questionAnswers.objectId {
        parameters["questionAnswers"] = ParseHelper.createJsonPointer("QuestionAnswers", objectId: questionAnswersId)
      }
      
      if let answerId = answerResult.answer?.objectId {
        parameters["answer"] = ParseHelper.createJsonPointer("Answer", objectId: answerId)
      }
      
      let request = Alamofire.request(.POST, self.answerResultUrl, parameters: parameters, encoding: .JSON, headers: headers)
        .responseJSON(completionHandler: { response in
          
          if let error = response.result.error {
            observer.onError(error)
          }
          else {
            print (response.result.value)
            
            if let value = response.result.value {
              if let code = value["code"] as? Int,
                let message = value["error"] as? String {
                  observer.on(.Next(RequestResult<AnswerResultProtocol>(isSuccess: false, code: code, message: message, modelObject: nil)))
              }
              answerResult.objectId = value["objectId"] as? String
              observer.on(.Next(RequestResult<AnswerResultProtocol>(isSuccess: true, code: nil, message: nil, modelObject: answerResult)))
            }
            observer.on(.Completed)
          }
        })
      return AnonymousDisposable({
        request.cancel()
      })
    }
  }
  
  func allSessionForQcm(qcm: QCMProtocol) -> Observable<RequestResult<Array<QCMSessionProtocol>>> {
    
    return Observable.create { [unowned self] observer in
      
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey
      ]
      
      let request = Alamofire.request(.GET, self.sessionUrl, parameters: nil, encoding: .JSON, headers: headers)
        .responseJSON(completionHandler: { response -> Void in
          
          if let error = response.result.error {
            observer.onError(error)
          }
          else {
            print (response.result.value)
            
            if let value = response.result.value {
              if let code = value["code"] as? Int,
                let message = value["error"] as? String {
                  observer.on(.Next(RequestResult<Array<QCMSessionProtocol>>(isSuccess: false, code: code, message: message, modelObject: nil)))
              }
              else {
                var arraySessions = Array<QCMSessionProtocol>()
                if let results = value["results"] {
                  if let results = results as? Array<[String:AnyObject]> {
                    for sessionJson in results {
                      let session = Mapper<QCMSession>().map(sessionJson)
                      if let session = session {
                        arraySessions.append(session)
                      }
                    }
                  }
                }
                observer.on(.Next(RequestResult<Array<QCMSessionProtocol>>(isSuccess: true, code: nil, message: nil, modelObject: arraySessions)))
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
  
  func allQuestionsAnswersForSession(inout session: QCMSessionProtocol) -> Observable<RequestResult<Array<QuestionAnswersProtocol>>> {
    
    return Observable.create { [unowned self] observer in
      
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey
      ]
      
      let request = Alamofire.request(.GET, self.questionAnswersUrl, parameters: ["where": ["session": ParseHelper.createJsonPointer("QCMSession", objectId: session.objectId!)]], encoding: .URLEncodedInURL, headers: headers)
        .responseJSON(completionHandler: { response -> Void in
          
          if let error = response.result.error {
            observer.onError(error)
          }
          else {
            print (response.result.value)
            
            if let value = response.result.value {
              if let code = value["code"] as? Int,
                let message = value["error"] as? String {
                  observer.on(.Next(RequestResult<Array<QuestionAnswersProtocol>>(isSuccess: false, code: code, message: message, modelObject: nil)))
              }
              else {
                var arrayQuestionsAnswers = Array<QuestionAnswersProtocol>()
                if let results = value["results"] {
                  if let results = results as? Array<[String:AnyObject]> {
                    for questionAnswersJson in results {
                      let questionAnswers = Mapper<QuestionAnswers>().map(questionAnswersJson)
                      if let questionAnswers = questionAnswers {
                        arrayQuestionsAnswers.append(questionAnswers)
                      }
                    }
                  }
                  
                  session.questionsAnswers = arrayQuestionsAnswers                }
                observer.on(.Next(RequestResult<Array<QuestionAnswersProtocol>>(isSuccess: true, code: nil, message: nil, modelObject: arrayQuestionsAnswers)))
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

  func allAnswersResultsForQuestionAnswers(inout questionAnswers: QuestionAnswersProtocol) -> Observable<RequestResult<Array<AnswerResultProtocol>>> {
    return Observable.create { [unowned self] observer in
      
      let headers = [
        "X-Parse-Application-Id": AppConstant.ApplicationKey,
        "X-Parse-REST-API-Key": AppConstant.RestAPIKey
      ]
      
      let request = Alamofire.request(.GET, self.answerResultUrl, parameters: ["where": ["questionAnswers": ParseHelper.createJsonPointer("QuestionAnswers", objectId: questionAnswers.objectId!)]], encoding: .URLEncodedInURL, headers: headers)
        .responseJSON(completionHandler: { response -> Void in
          
          if let error = response.result.error {
            observer.onError(error)
          }
          else {
            print (response.result.value)
            
            if let value = response.result.value {
              if let code = value["code"] as? Int,
                let message = value["error"] as? String {
                  observer.on(.Next(RequestResult<Array<AnswerResultProtocol>>(isSuccess: false, code: code, message: message, modelObject: nil)))
              }
              else {
                var arrayAnswersResults = Array<AnswerResultProtocol>()
                if let results = value["results"] {
                  if let results = results as? Array<[String:AnyObject]> {
                    for questionAnswersJson in results {
                      let questionAnswers = Mapper<AnswerResult>().map(questionAnswersJson)
                      if let questionAnswers = questionAnswers {
                        arrayAnswersResults.append(questionAnswers)
                      }
                    }
                  }
                  questionAnswers.answersResult = arrayAnswersResults                }
                observer.on(.Next(RequestResult<Array<AnswerResultProtocol>>(isSuccess: true, code: nil, message: nil, modelObject: arrayAnswersResults)))
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
}