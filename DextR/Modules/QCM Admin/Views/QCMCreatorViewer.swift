//
//  QCMCreatorViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class QCMCreatorViewer: UITableViewController {
  
  @IBOutlet weak var nameOutlet: UITextField!
  @IBOutlet weak var nameValidationOutlet: UILabel!
  
  @IBOutlet weak var durationOutlet: UITextField!
  @IBOutlet weak var durationValidationOutlet: UILabel!
  
  @IBOutlet weak var createOutlet: UIButton!
  @IBOutlet weak var creatingOulet: UIActivityIndicatorView!
  
  var disposeBag = DisposeBag()
  
  var API: QCMAPIProtocol?
  var validationService: QCMValidationProtocol?
  var wireframe: Wireframe?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let viewModel = QCMCreatorViewModel(
      input: (
        qcmName: nameOutlet.rx_text.asDriver(),
        qcmDuration: durationOutlet.rx_text.asDriver(),
        qcmTaps: createOutlet.rx_tap.asDriver()
      ),
      dependency: (
        API: self.API!,
        validationService: self.validationService!,
        wireframe: self.wireframe!
      )
    )
    
    viewModel.qcmEnabled
      .driveNext { [weak self] valid  in
        self?.createOutlet.enabled = valid
        self?.createOutlet.alpha = valid ? 1.0 : 0.5
      }
      .addDisposableTo(disposeBag)
    
    viewModel.validatedQCMName
      .drive(nameValidationOutlet.ex_validationResult)
      .addDisposableTo(disposeBag)
    
    viewModel.validatedQCMDuration
      .drive(durationValidationOutlet.ex_validationResult)
      .addDisposableTo(disposeBag)
    
    viewModel.qcmCreating
      .drive(creatingOulet.rx_animating)
      .addDisposableTo(disposeBag)
    
    viewModel.qcmCreated
      .driveNext { created in
        print("QCM created in \(created)")
      }
      .addDisposableTo(disposeBag)
    
    let tapBackground = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
    view.addGestureRecognizer(tapBackground)
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
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    self.navigationItem.hidesBackButton = true
  }
}
