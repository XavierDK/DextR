//
//  QCMResultatsViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 18/03/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class QCMResultatsViewer: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  
  var disposeBag = DisposeBag()
  var viewModel: QCMResultatsViewModel?
  
  var qcmAPI: QCMAPIProtocol?
  var qcmSessionAPI: QCMResultAPIProtocol?
  var accountAPI: AccountAPIProtocol?
  
  var wireframe: Wireframe?
  
  var qcm: QCMProtocol?
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    if let qcm = self.qcm {
//      self.viewModel = QCMResultatsViewModel(
//        qcm: qcm,
//        dependency: (
//          API: self.API!,
//          wireframe: self.wireframe!
//        )
//      )
    }
  }
}