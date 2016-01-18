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

class QCMAPIService: QCMAPIProtocol {
  
  func saveQCM(name: String, duration: String) -> Observable<Bool> {
    
    let qcm = QCM()
    qcm.name = name
    qcm.duration = Int(duration)!
    return qcm.rx_save()
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
  
  func allQcms() -> Observable<[QCM]?> {
    
    return QCM.query()!.rx_findObjects()
  }
  
  func saveQCM(qcm: QCM) {
    qcm.saveInBackground()
  }
}

//func saveQCM(name: String, duration: String) -> Observable<Bool>
//func saveQuestionForQcm(name: String, type: String, qcm: QCMProtocol) -> Observable<Bool>
//func saveAnswerForQuestion(name: String, correct: Bool, question: QuestionProtocol) -> Observable<Bool>