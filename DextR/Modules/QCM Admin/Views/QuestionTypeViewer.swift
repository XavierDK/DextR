//
//  QuestionTypeViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 17/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class QuestionTypeViewer: UIViewController {

  @IBOutlet var closeButton: UIBarButtonItem!
  @IBOutlet var tableView: UITableView!
  
  private let questionTypeCell = "BasicCell"
  
  var disposeBag = DisposeBag()
  
  var selectionSuccess: ((String) -> ())?
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    self.closeButton.rx_tap.subscribe { (event) -> Void in
      
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    .addDisposableTo(disposeBag)
    
    self.tableView.registerNib(UINib(nibName: "BasicCell", bundle: nil), forCellReuseIdentifier: questionTypeCell)
    
    let items = Observable.just([
      "Séléction",
      "Vrai/Faux"
      ])
    
    items
      .bindTo(tableView.rx_itemsWithCellIdentifier(questionTypeCell)) { (row, element, cell) in
        if let c = cell as? BasicCell {
          c.label?.text = element
        }
      }
      .addDisposableTo(disposeBag)
    
    tableView.rx_modelSelected(String).subscribe { [unowned self] (event) -> Void in
      
      if let elem = event.element {
        self.selectionSuccess?(elem)
      }
      
      self.dismissViewControllerAnimated(true, completion: nil)
    }
      .addDisposableTo(disposeBag)
  }
  
  override func willMoveToParentViewController(parent: UIViewController?) {
    guard let _ = parent  else {
      return
    }
    self.disposeBag = DisposeBag()
  }
}