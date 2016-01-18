//
//  QuestionCreatorViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class QuestionCreatorViewer: UITableViewController {
  
  @IBOutlet weak var titleOutlet: UITextField!
  @IBOutlet weak var titleValidationOutlet: UILabel!
  
  @IBOutlet weak var typeOutlet: UITextField!
  @IBOutlet weak var typeValidationOutlet: UILabel!
  
  @IBOutlet weak var createOutlet: UIButton!
  @IBOutlet weak var creatingOulet: UIActivityIndicatorView!
  
  var disposeBag = DisposeBag()
  
  var completionSuccess: (() -> ())?
  
  var qcm: QCMProtocol?
  
  var API: QCMAPIProtocol?
  var validationService: QCMValidationProtocol?
  var wireframe: Wireframe?
  
  var questionType: Variable<String> = Variable("")
  
  var viewModel: QuestionCreatorViewModel?
  
  private let questionTypeIdentifier = "SegueQuestionType"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let qcm = self.qcm {
      
      self.viewModel = QuestionCreatorViewModel(
        input: (
          questionTitle: titleOutlet.rx_text.asDriver(),
          questionType: questionType.asDriver(),
          questionTaps: createOutlet.rx_tap.asDriver(),
          qcm: qcm
        ),
        dependency: (
          API: self.API!,
          validationService: self.validationService!,
          wireframe: self.wireframe!
        )
      )
      
      viewModel?.questionEnabled
        .driveNext { [weak self] valid  in
          self?.createOutlet.enabled = valid
          self?.createOutlet.alpha = valid ? 1.0 : 0.5
        }
        .addDisposableTo(disposeBag)
      
      viewModel?.validatedQuestionTitle
        .drive(titleValidationOutlet.ex_validationResult)
        .addDisposableTo(disposeBag)
      
      viewModel?.validatedQuestionType
        .drive(typeValidationOutlet.ex_validationResult)
        .addDisposableTo(disposeBag)
      
      viewModel?.questionCreating
        .drive(creatingOulet.rx_animating)
        .addDisposableTo(disposeBag)
      
      viewModel?.questionCreated
        .driveNext { created in
          print("Question created in \(created)")
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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == questionTypeIdentifier {
      
      if let ctrl = segue.destinationViewController as? QuestionTypeViewer {
        
        ctrl.selectionSuccess = { str in
          
          self.typeOutlet.text = str
          self.questionType.value = str
        }
      }
    }
  }
  
}

