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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let qcm = self.qcm {
      let viewModel = QCMPresenterViewModel(
        qcm: qcm,
        dependency: (
          API: self.API!,
          wireframe: self.wireframe!
        )
      )
      
      viewModel.name
        .asObservable()
        .bindTo(nameOutlet.rx_text)
        .addDisposableTo(disposeBag)
      
      viewModel.duration
        .asObservable()
        .map({ (d) in
          "\(d)"
        })
        .bindTo(durationOutlet.rx_text)
        .addDisposableTo(disposeBag)
      
      
      questionsOutlet.registerNib(UINib(nibName: "BasicCell", bundle: nil), forCellReuseIdentifier: questionCell)
      
      viewModel.questions.asObservable()
        .bindTo(questionsOutlet.rx_itemsWithCellIdentifier(questionCell, cellType: UITableViewCell.self)) { (row, element, cell) in
          if let c = cell as? BasicCell {
            
            c.label?.text = element.title
          }
        }
        .addDisposableTo(disposeBag)
      
      questionsOutlet
        .rx_modelSelected(QuestionProtocol)
        .subscribeNext { value in
          DefaultWireframe.presentAlert("Tapped `\(value.title)`")
        }
        .addDisposableTo(disposeBag)
    }
    
    if let qcm = self.qcm {
      newQuestionOutlet.rx_tap.subscribeNext { [unowned self] _ in
        self.router?.showQuestionCreatorFromVC(self, andQCM: qcm, withCompletion: { () -> () in
          
        })
        }
        .addDisposableTo(disposeBag)
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    
    super.viewWillAppear(animated)
    self.navigationItem.hidesBackButton = true
  }
  
  override func willMoveToParentViewController(parent: UIViewController?) {
    guard let _ = parent  else {
      return
    }
    self.disposeBag = DisposeBag()
  }
}
