//
//  AccountLogInViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AccountLogInViewer: UITableViewController {
  
  @IBOutlet weak var emailOutlet: UITextField!
  @IBOutlet weak var emailValidationOutlet: UILabel!
  
  @IBOutlet weak var passwordOutlet: UITextField!
  @IBOutlet weak var passwordValidationOutlet: UILabel!
  
  @IBOutlet weak var loginOutlet: UIButton!
  @IBOutlet weak var loginingOulet: UIActivityIndicatorView!
  
  var disposeBag = DisposeBag()
  
  var API: AccountAPIProtocol?
  var validationService: AccountValidationProtocol?
  var wireframe: Wireframe?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let viewModel = AccountLogInViewModel(
      input: (
        email: emailOutlet.rx_text.asDriver(),
        password: passwordOutlet.rx_text.asDriver(),
        loginTaps: loginOutlet.rx_tap.asDriver()
      ),
      dependency: (
        API: self.API!,
        validationService: self.validationService!,
        wireframe: self.wireframe!
      )
    )
    
    viewModel.loginEnabled
      .driveNext { [weak self] valid  in
        self?.loginOutlet.enabled = valid
        self?.loginOutlet.alpha = valid ? 1.0 : 0.5
      }
      .addDisposableTo(disposeBag)
    
    viewModel.validatedEmail
      .drive(emailValidationOutlet.ex_validationResult)
      .addDisposableTo(disposeBag)
    
    viewModel.validatedPassword
      .drive(passwordValidationOutlet.ex_validationResult)
      .addDisposableTo(disposeBag)
    
    viewModel.logingIn
      .drive(loginingOulet.rx_animating)
      .addDisposableTo(disposeBag)
    
    viewModel.logIn
      .driveNext { signedIn in
        print("User signed in \(signedIn)")
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
  
}