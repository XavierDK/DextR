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
  var accountAPI: AccountAPIProtocol?
  var qcmAPI: QCMAPIProtocol?
  var wireframe: Wireframe?
  
  var currentAccount : AccountProtocol?
  
  var viewModel: QCMMenuViewModel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.viewModel = QCMMenuViewModel(
      
      dependency: (
        API: self.qcmAPI!,
        wireframe: self.wireframe!
      )
    )
    
    self.setupConfig()
    
    accountAPI?.currentAccount()?.subscribe(onNext: { [weak self] (account) -> Void in
      
      if  account.modelObject?.admin?.boolValue == true {
        
        self?.currentAccount = account.modelObject
        self?.setupAdminConfig()
      }
      }, onError: { (error) -> Void in
        
      }, onCompleted: { () -> Void in
        
      }, onDisposed: { () -> Void in
        
    })
      .addDisposableTo(disposeBag)
    
    self.setupTableView()
  }
  
  override func viewWillAppear(animated: Bool) {
    
    super.viewWillAppear(animated)
    self.navigationItem.hidesBackButton = true
  }
  
  func setupConfig() {
    
    let logoutButton = UIBarButtonItem(title: "Déconnexion", style: .Plain, target: nil, action: nil)
    logoutButton.tintColor = UIColor.whiteColor()
    self.navigationItem.leftBarButtonItem = logoutButton
    logoutButton.rx_tap
      .subscribe({ [weak self] (event) -> () in
        
        if let _self = self {
        _self.accountAPI?.logOut()?.subscribe(onNext: { [weak self] (account) -> Void in
          
          if let _self = self {
          if account.isSuccess == true {
            
            _self.wireframe?.promptFor("Déconnexion", message: "Vous avez été déconnecté", cancelAction: "OK", actions: [])
              .subscribeNext({ (action) -> Void in
                
                _self.router?.showRootViewsFromVC(_self, animated: false)
              })
              .addDisposableTo(_self.disposeBag)
            }
          }
          }, onError: { (error) -> Void in
            
          }, onCompleted: { () -> Void in
            
          }, onDisposed: { () -> Void in
            
        })
          .addDisposableTo(_self.disposeBag)
        }
        })
      .addDisposableTo(disposeBag)
  }
  
  func setupAdminConfig() {
    
    let newButton = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: nil)
    newButton.tintColor = UIColor.whiteColor()
    self.navigationItem.rightBarButtonItem = newButton
    newButton.rx_tap
      .subscribe({ [weak self] (event) -> () in
        
        if let _self = self {
          _self.router?.showQCMCreatorFromVC(_self, withCompletion: { () -> () in
            
            _self.router?.showDetailsRootViewFromVC(_self, animated: false)
            _self.viewModel?.reloadQcms()
          })
        }
        })
      .addDisposableTo(disposeBag)
  }
  
  func setupTableView() {
    
    self.tableView.dataSource = nil
    self.tableView.delegate = nil
    
    self.tableView.registerNib(UINib(nibName: "BasicCell", bundle: nil), forCellReuseIdentifier: qcmMenuCell)
    
    viewModel?.qcms.asObservable()
      .bindTo(tableView.rx_itemsWithCellIdentifier("BasicCell", cellType: BasicCell.self)) { (row, element, cell) in
        cell.label.text = element.name
      }
      .addDisposableTo(disposeBag)
    
    tableView
      .rx_modelSelected(QCMProtocol)
      .subscribeNext { [weak self] value in
        
        if let _self = self {
          if _self.currentAccount?.admin == true {
            _self.router?.showQCMPresenterFromVC(_self, forQCM: value)
          }
          else if _self.currentAccount?.admin == false {
            
          }
        }
      }
      .addDisposableTo(disposeBag)
  }
}

