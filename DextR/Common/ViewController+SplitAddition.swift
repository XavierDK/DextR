//
//  ViewController+SplitAddition.swift
//  DextR
//
//  Created by Xavier De Koninck on 28/12/2015.
//  Copyright © 2015 LinkValue. All rights reserved.
//

import Foundation
import UIKit
  
extension UIViewController {
  
  var detailsViewController : UINavigationController? {
    
    if let del = UIApplication.sharedApplication().delegate as? AppDelegate {
      let split = del.window!.rootViewController as! UISplitViewController
      if split.viewControllers.count == 2 {
        if let details = split.viewControllers[1] as? UINavigationController {
          return details
        }
      }
    }    
    return nil
  }
  
  var masterViewController : UINavigationController? {
    
    if let del = UIApplication.sharedApplication().delegate as? AppDelegate {
      let split = del.window!.rootViewController as! UISplitViewController
      if split.viewControllers.count == 2 {
        if let master = split.viewControllers[0] as? UINavigationController {
          return master
        }
      }
    }
    return nil
  }
}