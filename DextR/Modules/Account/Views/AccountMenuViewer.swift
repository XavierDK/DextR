//
//  AccountMenuViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 28/12/2015.
//  Copyright © 2015 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class AccountMenuViewer : UITableViewController {
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private let accountMenuCell = "BasicCell"
  
  var router: AppRouter?
  var accountAPI: AccountAPIProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupTableView()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    self.checkConnected()
  }
  
  func checkConnected() {
    
    if let currentAccountObs = accountAPI?.currentAccount() {
      
      SVProgressHUD.showWithMaskType(.Gradient)
      
      currentAccountObs.subscribe(onNext: { [weak self] (account) -> Void in
        
        SVProgressHUD.dismiss()
        if let _self = self {
          if account.isSuccess == true {
            _self.router?.showQCMMenuFromVC(_self)
          }
        }
        }, onError: { (error) -> Void in
          
          SVProgressHUD.dismiss()
          
        }, onCompleted: { () -> Void in

        }, onDisposed: { () -> Void in
          
      })
        .addDisposableTo(disposeBag)
    }
    
  }
  
  func setupTableView() {
    
    self.tableView.dataSource = nil
    self.tableView.delegate = nil
    
    self.tableView.registerNib(UINib(nibName: "BasicCell", bundle: nil), forCellReuseIdentifier: accountMenuCell)
    
    let items = Observable.just([
      "Connexion",
      "Inscription"
      ])
    
    items
      .bindTo(tableView.rx_itemsWithCellIdentifier(accountMenuCell)) { (row, element, cell) in
        if let c = cell as? BasicCell {
          c.label?.text = element
        }
      }
      .addDisposableTo(disposeBag)
    
    tableView.rx_itemSelected
      .subscribeNext { [unowned self] indexPath in
        
        switch indexPath.row {
        case 0:
          if let router = self.router {
            router.showLogInFromVC(self, withCompletion: { [unowned self] () -> () in
              router.showQCMMenuFromVC(self)
              })
          }
        case 1:
          if let router = self.router {
            router.showSignUpFromVC(self, withCompletion: { [unowned self] () -> () in
              router.showQCMMenuFromVC(self)
              })
          }
        default:
          break
        }
      }
      .addDisposableTo(disposeBag)
  }
}