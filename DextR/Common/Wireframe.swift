//
//  Wireframe.swift
//  DextR
//
//  Created by Xavier De Koninck on 02/01/2016.
//  Copyright © 2016 LinkValue. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

protocol Wireframe {
  func openURL(URL: NSURL)
  func promptFor<Action: CustomStringConvertible>(title: String, message: String, cancelAction: Action, actions: [Action]) -> Observable<Action>
}

class DefaultWireframe: Wireframe {
  static let sharedInstance = DefaultWireframe()
  
  func openURL(URL: NSURL) {
    UIApplication.sharedApplication().openURL(URL)
  }
  
  private static func rootViewController() -> UIViewController {
    return UIApplication.sharedApplication().keyWindow!.rootViewController!
  }
  
  static func presentAlert(message: String) {
    
    let alertView = UIAlertController(title: "Alerte", message: message, preferredStyle: .Alert)
    alertView.addAction(UIAlertAction(title: "OK", style: .Cancel) { _ in
      })
    rootViewController().presentViewController(alertView, animated: true, completion: nil)
  }
  
  func promptFor<Action : CustomStringConvertible>(title: String, message: String, cancelAction: Action, actions: [Action]) -> Observable<Action> {
    
    return Observable.create { observer in
      let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
      alertView.addAction(UIAlertAction(title: cancelAction.description, style: .Cancel) { _ in
        observer.on(.Next(cancelAction))
        })
      
      for action in actions {
        alertView.addAction(UIAlertAction(title: action.description, style: .Default) { _ in
          observer.on(.Next(action))
          })
      }
      
      DefaultWireframe.rootViewController().presentViewController(alertView, animated: true, completion: nil)
      
      return AnonymousDisposable {
        alertView.dismissViewControllerAnimated(false, completion: nil)
      }
    }
  }
}
