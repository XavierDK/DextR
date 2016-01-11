//
//  QCMViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 06/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import RxSwift
import RxCocoa

class QCMPresenterViewer: UIViewController {
  
  @IBOutlet weak var nameOutlet: UILabel!
  @IBOutlet weak var durationOutlet: UILabel!
  @IBOutlet weak var questionsOutlet: UITableView!
  @IBOutlet weak var newQuestionOutlet: UIButton!
  
  var disposeBag = DisposeBag()
  
  var API: QCMAPIProtocol?
  var wireframe: Wireframe?
  
  var qcm: QCMProtocol?
  
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
      
      viewModel.questions.asObservable()
        .bindTo(questionsOutlet.rx_itemsWithCellIdentifier("Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
          cell.textLabel?.text = element.title
        }
        .addDisposableTo(disposeBag)
      
      questionsOutlet
        .rx_modelSelected(QuestionProtocol)
        .subscribeNext { value in
          DefaultWireframe.presentAlert("Tapped `\(value.title)`")
        }
        .addDisposableTo(disposeBag)
    }
    
    newQuestionOutlet.rx_tap.subscribeNext { _ in
      
      }
      .addDisposableTo(disposeBag)
    
    let tapBackground = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
    view.addGestureRecognizer(tapBackground)
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
  
  func dismissKeyboard(gr: UITapGestureRecognizer) {
    view.endEditing(true)
  }
}
