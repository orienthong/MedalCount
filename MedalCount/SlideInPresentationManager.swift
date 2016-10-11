//
//  SlideInPresentationManager.swift
//  MedalCount
//
//  Created by Hao Dong on 11/10/2016.
//  Copyright © 2016 Ron Kliffer. All rights reserved.
//

import UIKit


enum PresentationDirection {
  case left
  case top
  case right
  case bottom
  
}

class SlideInPresentationManager: NSObject {
  var direction = PresentationDirection.left
}

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let presentationController = SlideInPresentationController(presentedViewController: presented, presenting: presenting, direction: direction)
    return presentationController
  }
}
