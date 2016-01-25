//
//  QCMPlayerViewer.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class QCMPlayerViewer : UIViewController {
  
  @IBOutlet var collectionView : UICollectionView!
  @IBOutlet var timerLabel : UILabel!
  
  @IBOutlet var previousButton : UIButton!
  @IBOutlet var nextButton : UIButton!
  
  var starterViewer: QCMStarterViewer!
  
  var disposeBag = DisposeBag()
  
  var completionSuccess: (() -> ())?
  
  var qcm: QCMProtocol?
  
  var qcmAPI: QCMAPIProtocol?
  var qcmResultAPI: QCMResultAPIProtocol?
  var wireframe: Wireframe?
  
  var viewModel: QCMPlayerViewModel?
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    if let qcm = self.qcm {
    
    self.viewModel = QCMPlayerViewModel(
      input: (
        previousTap: self.previousButton.rx_tap.asDriver(),
        nextTap: self.nextButton.rx_tap.asDriver(),
        qcm: qcm
      ),
      dependency: (
        qcmAPI: self.qcmAPI!,
        qcmResultAPI: self.qcmResultAPI!,
        wireframe: self.wireframe!
      )
    )
    }
    
    self.viewModel?.qcmPlayable.asObservable().subscribe({ (event) -> Void in
      
      if event.element?.boolValue == true {
        print("MUHAHAHAHAH")
      }
    })
    
//    self.starterViewer
    
  }
}