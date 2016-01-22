//
//  QuestionPresenterViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class QuestionPresenterViewer: UIViewController {
  
  @IBOutlet weak var nameOutlet: UILabel!
  @IBOutlet weak var typeOutlet: UILabel!
  @IBOutlet weak var answersOutlet: UITableView!
  @IBOutlet weak var newAnswerOutlet: UIButton!
  
  private let questionCell = "BasicCell"
  
  var disposeBag = DisposeBag()
  
  var API: QCMAPIProtocol?
  var wireframe: Wireframe?
  
  var question: QuestionProtocol?
  
  var router: AppRouter?
  
  var viewModel: QuestionPresenterViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let question = self.question {
      self.viewModel = QuestionPresenterViewModel(
        question: question,
        dependency: (
          API: self.API!,
          wireframe: self.wireframe!
        )
      )
      
      viewModel?.title
        .asObservable()
        .bindTo(nameOutlet.rx_text)
        .addDisposableTo(disposeBag)
      
      viewModel?.type
        .asObservable()
        .map({ (d) in
          "\(d)"
        })
        .bindTo(typeOutlet.rx_text)
        .addDisposableTo(disposeBag)
      
      answersOutlet.registerNib(UINib(nibName: "BasicCell", bundle: nil), forCellReuseIdentifier: questionCell)
      
      viewModel?.answers.asObservable()
        .bindTo(answersOutlet.rx_itemsWithCellIdentifier(questionCell, cellType: UITableViewCell.self)) { (row, element, cell) in
          if let c = cell as? BasicCell {
            
            c.label?.text = element.title
          }
        }
        .addDisposableTo(disposeBag)
      
      answersOutlet
        .rx_modelSelected(AnswerProtocol)
        .subscribeNext { value in
          DefaultWireframe.presentAlert("Tapped `\(value.title)`")
        }
        .addDisposableTo(disposeBag)
    }
    
    if let question = self.question {
      newAnswerOutlet.rx_tap.subscribeNext { [unowned self] _ in
        self.router?.showAnswerCreatorFromVC(self, andQuestion: question, withCompletion: { () -> () in
          
          self.navigationController?.popViewControllerAnimated(true)
        })
        }
        .addDisposableTo(disposeBag)
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    
    super.viewWillAppear(animated)
    
    self.viewModel?.reloadAnswers()
  }
  
  override func willMoveToParentViewController(parent: UIViewController?) {
    guard let _ = parent  else {
      return
    }
    self.disposeBag = DisposeBag()
  }
}
