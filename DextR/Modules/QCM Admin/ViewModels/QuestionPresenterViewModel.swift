//
//  QuestionPresenterViewModel.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class QuestionPresenterViewModel {
  
  var disposeBag = DisposeBag()
  
  let title: Variable<String> = Variable("")
  let type: Variable<QuestionType> = Variable(.Unknown)
  let answers: Variable<Array<AnswerProtocol>> = Variable([])
  
  let API: QCMAPIProtocol
  var question: QuestionProtocol
  
  init(
    question: QuestionProtocol,
    dependency: (
    API: QCMAPIProtocol,
    wireframe: Wireframe
    )
    ) {
      self.question = question
      
      if let questionTitle = question.title {
        title.value = questionTitle
      }
      
      if let questionType = question.type {
        type.value = questionType
      }
      
      self.API = dependency.API
      
      self.reloadAnswers()
  }
  
  func reloadAnswers() {
    
    API.allAnswersForQuestion(&question).map({ (res) in
      res.modelObject
    })
      .subscribeNext {[weak self] (answers) -> Void in
        
        if let answers = answers {
          self?.answers.value = answers
        }
        else {
          self?.answers.value = []
        }
      }
      .addDisposableTo(disposeBag)
  }
}