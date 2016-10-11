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
  var disableCompactHeight = false
}

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    let presentationController = SlideInPresentationController(presentedViewController: presented, presenting: presenting, direction: direction)
    presentationController.delegate = self
    return presentationController
  }
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(direction: direction, isPresentation: true)
  }
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(direction: direction, isPresentation: false)
  }
}

//The iPhone has a Regular height size class in Portrait, and a Compact height size class in Landscape
extension SlideInPresentationManager: UIAdaptivePresentationControllerDelegate {
  
  func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    if traitCollection.verticalSizeClass == .compact && disableCompactHeight {
      return .overFullScreen
    } else {
      return .none
    }
  }
  //When the presentation style changes, the presentation controller also gives you the opportunity to specify a new presented view controller. Before initiating the transition, the presentation controller calls the presentationController(_:viewControllerForAdaptivePresentationStyle:) method of its delegate object.
  func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    guard style == .overFullScreen else { return nil }
    
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RotateViewController")
  }
}
