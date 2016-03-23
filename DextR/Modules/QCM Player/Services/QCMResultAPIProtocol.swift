//
//  QCMResultAPIProtocol.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift

protocol QCMResultAPIProtocol {
  
  func sendSession(session: QCMSessionProtocol) -> Observable<RequestResult<QCMSessionProtocol>>
  func sendQuestionAnswers(var questionAnswers: QuestionAnswersProtocol, forSession session: QCMSessionProtocol) -> Observable<RequestResult<QuestionAnswersProtocol>>
  func sendAnswerResult(var answerResult: AnswerResultProtocol, forQuestionAnswers questionAnswers: QuestionAnswersProtocol) -> Observable<RequestResult<AnswerResultProtocol>>
  
  func allSessionForQcm(qcm: QCMProtocol) -> Observable<RequestResult<Array<QCMSessionProtocol>>>
  func allQuestionsAnswersForSession(inout session: QCMSessionProtocol) -> Observable<RequestResult<Array<QuestionAnswersProtocol>>>
  func allAnswersResultsForQuestionAnswers(inout questionAnswers: QuestionAnswersProtocol) -> Observable<RequestResult<Array<AnswerResultProtocol>>>
}