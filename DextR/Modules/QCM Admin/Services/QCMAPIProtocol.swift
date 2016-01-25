//
//  QCMAPIProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift

protocol QCMAPIProtocol {

  func createQCM(name: String, duration: NSNumber) -> Observable<RequestResult<QCMProtocol>>
  func createQuestionForQcm(title: String, type: QuestionType, qcm: QCMProtocol) -> Observable<RequestResult<QuestionProtocol>>
  func createAnswerForQuestion(title: String, correct: Bool, question: QuestionProtocol) -> Observable<RequestResult<AnswerProtocol>>
  
  func allQcms() -> Observable<RequestResult<Array<QCMProtocol>>>
  func allQuestionsForQcm(inout qcm: QCMProtocol) -> Observable<RequestResult<Array<QuestionProtocol>>>
  func allAnswersForQuestion(inout question: QuestionProtocol) -> Observable<RequestResult<Array<AnswerProtocol>>>  
}