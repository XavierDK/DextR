//
//  AccountSignUpViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AccountSignUpViewer: UITableViewController {
  
  @IBOutlet weak var emailOutlet: UITextField!
  @IBOutlet weak var emailValidationOutlet: UILabel!
  
  @IBOutlet weak var passwordOutlet: UITextField!
  @IBOutlet weak var passwordValidationOutlet: UILabel!
  
  @IBOutlet weak var passwordRepeatedOutlet: UITextField!
  @IBOutlet weak var passwordRepeatedValidationOutlet: UILabel!
  
  @IBOutlet weak var lastnameOutlet: UITextField!
  @IBOutlet weak var lastnameValidationOutlet: UILabel!
  
  @IBOutlet weak var firstnameOutlet: UITextField!
  @IBOutlet weak var firstnameValidationOutlet: UILabel!
  
  @IBOutlet weak var signupOutlet: UIButton!
  @IBOutlet weak var signingupOulet: UIActivityIndicatorView!
  
  var disposeBag = DisposeBag()
  
  var completionSuccess: (() -> ())?
  
  var API: AccountAPIProtocol?
  var validationService: AccountValidationProtocol?
  var wireframe: Wireframe?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let viewModel = AccountSignUpViewModel(
      input: (
        email: emailOutlet.rx_text.asDriver(),
        password: passwordOutlet.rx_text.asDriver(),
        repeatedPassword: passwordRepeatedOutlet.rx_text.asDriver(),
        lastname: lastnameOutlet.rx_text.asDriver(),
        firstname: firstnameOutlet.rx_text.asDriver(),
        signupTaps: signupOutlet.rx_tap.asDriver()
      ),
      dependency: (
        API: self.API!,
        validationService: self.validationService!,
        wireframe: self.wireframe!
      )
    )
    
    viewModel.signupEnabled
      .driveNext { [weak self] valid  in
        self?.signupOutlet.enabled = valid
        self?.signupOutlet.alpha = valid ? 1.0 : 0.5
      }
      .addDisposableTo(disposeBag)
    
    viewModel.validatedEmail
      .drive(emailValidationOutlet.ex_validationResult)
      .addDisposableTo(disposeBag)
    
    viewModel.validatedPassword
      .drive(passwordValidationOutlet.ex_validationResult)
      .addDisposableTo(disposeBag)
    
    viewModel.validatedPasswordRepeated
      .drive(passwordRepeatedValidationOutlet.ex_validationResult)
      .addDisposableTo(disposeBag)
    
    viewModel.validatedLastname
      .drive(lastnameValidationOutlet.ex_validationResult)
      .addDisposableTo(disposeBag)
    
    viewModel.validatedFirstname
      .drive(firstnameValidationOutlet.ex_validationResult)
      .addDisposableTo(disposeBag)
    
    viewModel.signingUp
      .drive(signingupOulet.rx_animating)
      .addDisposableTo(disposeBag)
    
    viewModel.signupIn
      .driveNext { signedIn in
        if signedIn == true {
          self.navigationController?.popToRootViewControllerAnimated(false)
          self.completionSuccess?()
        }
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