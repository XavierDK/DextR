//
//  AnswerCreatorViewModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AnswerCreatorViewModel {
  
  let validatedAnswerTitle: Driver<ValidationResult>
  let answerEnabled: Driver<Bool>
  let answerCreating: Driver<Bool>
  let answerCreated: Driver<Bool>
  
  init(
    input: (
    answerTitle: Driver<String>,
    answerCorrect: Driver<Bool>,
    answerTaps: Driver<Void>,
    question: QuestionProtocol
    ),
    dependency: (
    API: QCMAPIProtocol,
    validationService: QCMValidationProtocol,
    wireframe: Wireframe
    )
    ) {
      
      let API = dependency.API
      let validationService = dependency.validationService
      let wireframe = dependency.wireframe
            
      validatedAnswerTitle = input.answerTitle
        .map { title in
          return validationService.validateAnswerTitle(title)
      }
      let activityIndicAnswer = ActivityIndicator()
      self.answerCreating = activityIndicAnswer.asDriver()
      
      answerEnabled = Driver.combineLatest(
        validatedAnswerTitle,
        answerCreating
        )   { title, creating in
          title.isValid &&
            !creating
        }
        .distinctUntilChanged()
      
      let answerDatas = Driver.combineLatest(input.answerTitle, input.answerCorrect) { ($0, $1) }
      
      answerCreated = input.answerTaps.withLatestFrom(answerDatas)
        .flatMapLatest { (name, correct) in
          return API.saveAnswerForQuestion(name, correct: correct, question: input.question)
            .trackActivity(activityIndicAnswer)
            .asDriver(onErrorJustReturn: false)
        }
        .flatMapLatest { created -> Driver<Bool> in
          let message = created ? "Connexion réussi" : "La connexion a échouée"
          return wireframe.promptFor("Erreur", message: message, cancelAction: "OK", actions: [])
            .map { _ in
              created
            }
            .asDriver(onErrorJustReturn: false)
      }
  }
  
}