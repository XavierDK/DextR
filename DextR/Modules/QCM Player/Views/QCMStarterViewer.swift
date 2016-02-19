//
//  QCMStarterView.swift
//  DextR
//
//  Created by Xavier De Koninck on 22/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class QCMStarterViewer : UIViewController {
 
  @IBOutlet var startButton : UIButton!
  @IBOutlet var activityIndicator : UIActivityIndicatorView!
  
  var disposeBag = DisposeBag()
  
  var viewModel: QCMPlayerViewModel?
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    self.viewModel?.qcmPlayable.asObservable()
      .subscribe({ event in
        
        if let valid = event.element?.boolValue {
          self.startButton.enabled = valid
          self.startButton.alpha = valid ? 1.0 : 0.5
          if valid {
            self.startButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
          }
          else {
            self.startButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
          }
          self.activityIndicator.hidden = valid
        }
      })
      .addDisposableTo(disposeBag)
    
    viewModel?.datasReceiving
      .drive(activityIndicator.rx_animating)
      .addDisposableTo(disposeBag)
    
    self.startButton.rx_tap
      .subscribeNext({ _ in
        self.dismissViewControllerAnimated(false, completion: {
          self.viewModel?.qcmStarted.value = true
        })
        
      })
      .addDisposableTo(disposeBag)
  }
}