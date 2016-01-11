//
//  AppRouter.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit

class AppRouter: NSObject {
  
  // MARK: Account
  
  let signUpIdentifier = "AccountSignUpViewer"
  let logInIdentifier = "AccountLogInViewer"
  
  func showSignUpFromVC(vc: UIViewController, withCompletion completion: () -> ()) {
    
    vc.detailsViewController?.popToRootViewControllerAnimated(false)
    let signUpVc = viewControllerForIdentifier(signUpIdentifier)
    if let signUpVc = signUpVc as? AccountSignUpViewer {
      
      signUpVc.completionSuccess = completion
      vc.detailsViewController?.pushViewController(signUpVc, animated: false)
    }
  }
  
  func showLogInFromVC(vc: UIViewController, withCompletion completion: () -> ()) {
    
    vc.detailsViewController?.popToRootViewControllerAnimated(false)
    let logInVc = viewControllerForIdentifier(logInIdentifier)
    if let logInVc = logInVc as? AccountLogInViewer {
      
      logInVc.completionSuccess = completion
      vc.detailsViewController?.pushViewController(logInVc, animated: false)
    }
  }
  
  
  // MARK: QCM
  
  let qcmMenuIdentifier = "QCMMenuViewer"
  let qcmCreatorIdentifier = "QCMCreatorViewer"
  let qcmPresenterIdentifier = "QCMPresenterViewer"
  
  func showQCMMenuFromVC(vc: UIViewController) {
    
    vc.masterViewController?.popToRootViewControllerAnimated(false)
    let qcmMenu = viewControllerForIdentifier(qcmMenuIdentifier)
    if let qcmMenu = qcmMenu as? QCMMenuViewer {
      
      vc.masterViewController?.pushViewController(qcmMenu, animated: false)
    }
  }
  
  func showQCMCreatorFromVC(vc: UIViewController, withCompletion completion: () -> ()) {
    
    vc.detailsViewController?.popToRootViewControllerAnimated(false)
    let qcmCreator = viewControllerForIdentifier(qcmCreatorIdentifier)
    if let qcmCreator = qcmCreator as? QCMCreatorViewer {
      
      qcmCreator.completionSuccess = completion
      vc.detailsViewController?.pushViewController(qcmCreator, animated: false)
    }
  }
  
  func showQCMPresenterFromVC(vc: UIViewController, forQCM qcm: QCMProtocol) {
    
    vc.detailsViewController?.popToRootViewControllerAnimated(false)
    let qcmPresenter = viewControllerForIdentifier(qcmPresenterIdentifier)
    if let qcmPresenter = qcmPresenter as? QCMPresenterViewer {
      qcmPresenter.qcm = qcm
      vc.detailsViewController?.pushViewController(qcmPresenter, animated: false)
    }
  }

  
  
  
  // MARK: Default
  
  private func viewControllerForIdentifier(identifier: String) -> UIViewController? {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewControllerWithIdentifier(identifier)
    return vc
  }
}