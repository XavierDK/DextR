//
//  QCMViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class QCMPresenterViewer: UIViewController {
  
  @IBOutlet weak var nameOutlet: UILabel!
  @IBOutlet weak var durationOutlet: UILabel!
  @IBOutlet weak var questionsOutlet: UITableView!
  @IBOutlet weak var newQuestionOutlet: UIButton!
  
  private let questionCell = "BasicCell"
  
  var disposeBag = DisposeBag()
  
  var API: QCMAPIProtocol?
  var wireframe: Wireframe?
  
  var qcm: QCMProtocol?
  
  var router: AppRouter?
  
  var viewModel: QCMPresenterViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let qcm = self.qcm {
      self.viewModel = QCMPresenterViewModel(
        qcm: qcm,
        dependency: (
          API: self.API!,
          wireframe: self.wireframe!
        )
      )
      
      viewModel?.name
        .asObservable()
        .bindTo(nameOutlet.rx_text)
        .addDisposableTo(disposeBag)
      
      viewModel?.duration
        .asObservable()
        .map({ (d) in
          "\(d)"
        })
        .bindTo(durationOutlet.rx_text)
        .addDisposableTo(disposeBag)
      
      questionsOutlet.registerNib(UINib(nibName: "BasicCell", bundle: nil), forCellReuseIdentifier: questionCell)
      
      viewModel?.questions.asObservable()
        .bindTo(questionsOutlet.rx_itemsWithCellIdentifier(questionCell, cellType: UITableViewCell.self)) { (row, element, cell) in
          if let c = cell as? BasicCell {
            
            c.label?.text = element.title
          }
        }
        .addDisposableTo(disposeBag)
      
      questionsOutlet
        .rx_modelSelected(QuestionProtocol)
        .subscribeNext { [weak self] value in
          
          if let _self = self {
            _self.router?.showQuestionPresenterFromVC(_self, forQuestion: value)
          }
        }
        .addDisposableTo(disposeBag)
    }
    
    if let qcm = self.qcm {
      newQuestionOutlet.rx_tap.subscribeNext { [weak self] _ in
        
        if let _self = self {
          self?.router?.showQuestionCreatorFromVC(_self, andQCM: qcm, withCompletion: { () -> () in            
            self?.navigationController?.popViewControllerAnimated(true)
          })
        }
      }
        .addDisposableTo(disposeBag)
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    
    super.viewWillAppear(animated)
    self.navigationItem.hidesBackButton = true
    
    self.viewModel?.reloadQuestions()
  }
  
  override func willMoveToParentViewController(parent: UIViewController?) {
    guard let _ = parent  else {
      return
    }
    self.disposeBag = DisposeBag()
  }
}
