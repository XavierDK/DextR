//
//  QCMMenuViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 30/12/2015.
//  Copyright © 2015 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class QCMMenuViewer : UITableViewController {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let qcmMenuCell = "BasicCell"
  
  var router: AppRouter?
  var accountService: AccountAPIService?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let currentUser = accountService?.currentAccount()
    
    if  currentUser?.admin?.boolValue == true {
      
      setupAdminConfig()
    }
    
    self.setupTableView()
  }
  
  override func viewWillAppear(animated: Bool) {
    
    super.viewWillAppear(animated)
    self.navigationItem.hidesBackButton = true
  }
  
  
  func setupAdminConfig() {
    
    let newButton = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: nil)
    newButton.tintColor = UIColor.whiteColor()
    self.navigationItem.rightBarButtonItem = newButton    
    newButton.rx_tap
      .subscribe({ [unowned self] (event) -> () in
        self.router?.showQCMCreatorFromVC(self)
      })
    .addDisposableTo(disposeBag)
  }
  
  func setupTableView() {
    
    self.tableView.dataSource = nil
    self.tableView.delegate = nil
    
    self.tableView.registerNib(UINib(nibName: "BasicCell", bundle: nil), forCellReuseIdentifier: qcmMenuCell)
    
    let items = Observable.just([
      "Test"
      ])
    
    items
      .bindTo(tableView.rx_itemsWithCellIdentifier(qcmMenuCell)) { (row, element, cell) in
        if let c = cell as? BasicCell {
          c.label?.text = element
        }
      }
      .addDisposableTo(disposeBag)
    
    tableView.rx_itemSelected
      .subscribeNext { [unowned self] indexPath in
        
        switch indexPath.row {
          default:
          break
        }
      }
      .addDisposableTo(disposeBag)
  }
}

