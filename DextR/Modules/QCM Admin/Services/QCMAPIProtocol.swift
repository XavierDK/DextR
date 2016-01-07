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

  func saveQCM(name: String, duration: String) -> Observable<Bool>
  func saveQuestionForQcm(title: String, type: String, qcm: QCMProtocol) -> Observable<Bool>
  func saveAnswerForQuestion(title: String, correct: Bool, question: QuestionProtocol) -> Observable<Bool>
  
  func allQcms() -> Observable<[QCM]?>
}