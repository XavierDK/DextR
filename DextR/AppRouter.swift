//
//  AppRouter.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import Swinject

class AppRouter: NSObject {
  
  // MARK: Account
  
  let accountStoryboardName = "Account"
  
  let signUpIdentifier = "AccountSignUpViewer"
  let logInIdentifier = "AccountLogInViewer"
  
  func showRootViewsFromVC(vc: UIViewController, animated: Bool) {
    vc.masterViewController?.popToRootViewControllerAnimated(animated)
    vc.detailsViewController?.popToRootViewControllerAnimated(animated)
  }
  
  func showDetailsRootViewFromVC(vc: UIViewController, animated: Bool) {
    vc.detailsViewController?.popToRootViewControllerAnimated(animated)
  }
  
  func showMasterRootViewFromVC(vc: UIViewController, animated: Bool) {
    vc.masterViewController?.popToRootViewControllerAnimated(animated)
  }

  
  func showSignUpFromVC(vc: UIViewController, withCompletion completion: () -> ()) {
    
    vc.detailsViewController?.popToRootViewControllerAnimated(false)
    let signUpVc = viewControllerForIdentifier(signUpIdentifier, storyBoardName: accountStoryboardName)
    if let signUpVc = signUpVc as? AccountSignUpViewer {
      
      signUpVc.completionSuccess = completion
      vc.detailsViewController?.pushViewController(signUpVc, animated: false)
    }
  }
  
  func showLogInFromVC(vc: UIViewController, withCompletion completion: () -> ()) {
    
    vc.detailsViewController?.popToRootViewControllerAnimated(false)
    let logInVc = viewControllerForIdentifier(logInIdentifier, storyBoardName: accountStoryboardName)
    if let logInVc = logInVc as? AccountLogInViewer {
      
      logInVc.completionSuccess = completion
      vc.detailsViewController?.pushViewController(logInVc, animated: false)
    }
  }
  
  
  // MARK: QCM Admin
  
  let qcmAdminStoryboardName = "QCMAdmin"
  
  let qcmMenuIdentifier = "QCMMenuViewer"
  let qcmCreatorIdentifier = "QCMCreatorViewer"
  let qcmPresenterIdentifier = "QCMPresenterViewer"
  let questionCreatorIdentifier = "QuestionCreatorViewer"
  let questionPresenterIdentifier = "QuestionPresenterViewer"
  let answerCreatorIdentifier = "AnswerCreatorViewer"
  
  func showQCMMenuFromVC(vc: UIViewController) {
    
    vc.masterViewController?.popToRootViewControllerAnimated(false)
    let qcmMenu = viewControllerForIdentifier(qcmMenuIdentifier, storyBoardName: qcmAdminStoryboardName)
    if let qcmMenu = qcmMenu as? QCMMenuViewer {
      vc.masterViewController?.pushViewController(qcmMenu, animated: false)
    }
  }
  
  func showQCMCreatorFromVC(vc: UIViewController, withCompletion completion: () -> ()) {
    
    vc.detailsViewController?.popToRootViewControllerAnimated(false)
    let qcmCreator = viewControllerForIdentifier(qcmCreatorIdentifier, storyBoardName: qcmAdminStoryboardName)
    if let qcmCreator = qcmCreator as? QCMCreatorViewer {
      
      qcmCreator.completionSuccess = completion
      vc.detailsViewController?.pushViewController(qcmCreator, animated: false)
    }
  }
  
  func showQCMPresenterFromVC(vc: UIViewController, forQCM qcm: QCMProtocol) {
    
    vc.detailsViewController?.popToRootViewControllerAnimated(false)
    let qcmPresenter = viewControllerForIdentifier(qcmPresenterIdentifier, storyBoardName: qcmAdminStoryboardName)
    if let qcmPresenter = qcmPresenter as? QCMPresenterViewer {
      qcmPresenter.qcm = qcm
      vc.detailsViewController?.pushViewController(qcmPresenter, animated: false)
    }
  }
  
  func showQuestionCreatorFromVC(vc: UIViewController, andQCM qcm: QCMProtocol, withCompletion completion: () -> ()) {
    
    let questionCreator = viewControllerForIdentifier(questionCreatorIdentifier, storyBoardName: qcmAdminStoryboardName)
    if let questionCreator = questionCreator as? QuestionCreatorViewer {
      
      questionCreator.qcm = qcm
      questionCreator.completionSuccess = completion
      vc.detailsViewController?.pushViewController(questionCreator, animated: true)
    }
  }
  
  func showQuestionPresenterFromVC(vc: UIViewController, forQuestion question: QuestionProtocol) {
    
    let questionPresenter = viewControllerForIdentifier(questionPresenterIdentifier, storyBoardName: qcmAdminStoryboardName)
    if let questionPresenter = questionPresenter as? QuestionPresenterViewer {
      questionPresenter.question = question
      vc.detailsViewController?.pushViewController(questionPresenter, animated: true)
    }
  }
  
  func showAnswerCreatorFromVC(vc: UIViewController, andQuestion question: QuestionProtocol, withCompletion completion: () -> ()) {
    
    let answerCreator = viewControllerForIdentifier(answerCreatorIdentifier, storyBoardName: qcmAdminStoryboardName)
    if let answerCreator = answerCreator as? AnswerCreatorViewer {
      
      answerCreator.question = question
      answerCreator.completionSuccess = completion
      vc.detailsViewController?.pushViewController(answerCreator, animated: true)
    }
  }

  // MARK: QCM Player
  
  let qcmPlayerStoryboardName = "QCMPlayer"
  
  let qcmPlayerIdentifier = "QCMPlayerViewer"
  let qcmStarterIdentifier = "QCMStarterViewer"
  
  func showQCMPlayerFromVC(vc: UIViewController, forQCM qcm: QCMProtocol) {
    
    vc.detailsViewController?.popToRootViewControllerAnimated(false)
    let qcmPlayer = viewControllerForIdentifier(qcmPlayerIdentifier, storyBoardName: qcmPlayerStoryboardName)
    if let qcmPlayer = qcmPlayer as? QCMPlayerViewer {
      
      qcmPlayer.qcm = qcm
      vc.detailsViewController?.pushViewController(qcmPlayer, animated: false)
    }
  }
  
  // MARK: Default
  
  private func viewControllerForIdentifier(identifier: String, storyBoardName: String) -> UIViewController? {
    
    let sb = SwinjectStoryboard.create(
      name: storyBoardName, bundle: nil, container: SwinjectStoryboard.defaultContainer)
    let vc = sb.instantiateViewControllerWithIdentifier(identifier)
    return vc
  }
}