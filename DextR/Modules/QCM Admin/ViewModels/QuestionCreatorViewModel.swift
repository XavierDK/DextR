//
//  QuestionCreatorViewModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class QuestionCreatorViewModel {
  
  let validatedQuestionTitle: Driver<ValidationResult>
  let validatedQuestionType: Driver<ValidationResult>
  let questionEnabled: Driver<Bool>
  let questionCreating: Driver<Bool>
  let questionCreated: Driver<Bool>
  
  init(
    input: (
    questionTitle: Driver<String>,
    questionType: Driver<String>,
    questionTaps: Driver<Void>,
    qcm: QCMProtocol
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
      
      validatedQuestionTitle = input.questionTitle
        .map { title in
          return validationService.validateQuestionTitle(title)
      }
      
      validatedQuestionType = input.questionType
        .map { type in
          return validationService.validateQuestionType(type)
      }
      
      let activityIndicQuestion = ActivityIndicator()
      self.questionCreating = activityIndicQuestion.asDriver()

      questionEnabled = Driver.combineLatest(
        validatedQuestionTitle,
        validatedQuestionType,
        questionCreating
        )   { title, type, creating in
          title.isValid &&
            type.isValid &&
            !creating
        }
        .distinctUntilChanged()
    
      
      let questionDatas = Driver.combineLatest(input.questionTitle, input.questionType) { ($0, $1) }
      
      questionCreated = input.questionTaps.withLatestFrom(questionDatas)
        .flatMapLatest { (title, type) in
          return API.saveQuestionForQcm(title, type: type, qcm: input.qcm)
            .trackActivity(activityIndicQuestion)
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