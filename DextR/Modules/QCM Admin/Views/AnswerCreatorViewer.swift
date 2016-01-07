//
//  AnswerCreatorViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AnswerCreatorViewer: UITableViewController {
  
  @IBOutlet weak var titleOutlet: UITextField!
  @IBOutlet weak var titleValidationOutlet: UILabel!
  
  @IBOutlet weak var correctOutlet: UISwitch!
  
  @IBOutlet weak var createOutlet: UIButton!
  @IBOutlet weak var creatingOulet: UIActivityIndicatorView!
  
  var disposeBag = DisposeBag()
  
  var question: QuestionProtocol?
  
  var API: QCMAPIProtocol?
  var validationService: QCMValidationProtocol?
  var wireframe: Wireframe?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let question = self.question {
      let viewModel = AnswerCreatorViewModel(
        input: (
          answerTitle: titleOutlet.rx_text.asDriver(),
          answerCorrect: correctOutlet.rx_value.asDriver(),
          answerTaps: createOutlet.rx_tap.asDriver(),
          question: question
        ),
        dependency: (
          API: self.API!,
          validationService: self.validationService!,
          wireframe: self.wireframe!
        )
      )
      
      viewModel.answerEnabled
        .driveNext { [weak self] valid  in
          self?.createOutlet.enabled = valid
          self?.createOutlet.alpha = valid ? 1.0 : 0.5
        }
        .addDisposableTo(disposeBag)
      
      viewModel.validatedAnswerTitle
        .drive(titleValidationOutlet.ex_validationResult)
        .addDisposableTo(disposeBag)
      
      viewModel.answerCreating
        .drive(creatingOulet.rx_animating)
        .addDisposableTo(disposeBag)
      
      viewModel.answerCreated
        .driveNext { created in
          print("Answer created in \(created)")
        }
        .addDisposableTo(disposeBag)
      
      let tapBackground = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
      view.addGestureRecognizer(tapBackground)
    }
  }
  
  override func willMoveToParentViewController(parent: UIViewController?) {
    guard let _ = parent  else {
      return
    }
    self.disposeBag = DisposeBag()
  }
  
  func dismissKeyboard(gr: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
}

