//
//  SlideInPresentationController.swift
//  MedalCount
//
//  Created by Hao Dong on 11/10/2016.
//  Copyright © 2016 Ron Kliffer. All rights reserved.
//

import UIKit

class SlideInPresentationController: UIPresentationController {
  
  private var direction: PresentationDirection
  fileprivate var dimmingView: UIView!
  
  init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection) {
    self.direction = direction
    
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    setupDimmingView()
  }
  //重写方法，这里不需要调用super
  override func presentationTransitionWillBegin() {
    containerView?.insertSubview(dimmingView, at: 0)
    NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
    NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
    
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 1.0
      return
    }
    
    coordinator.animate(alongsideTransition: { (_) in
      self.dimmingView.alpha = 1.0
      })
  }
  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0.0
    }
    coordinator.animate(alongsideTransition: { (_) in
      self.dimmingView.alpha = 0.0
      })
  }
  //Here you reset the presented view’s frame to fit any changes to the containerView frame.
  override func containerViewWillLayoutSubviews() {
    presentedView?.frame = frameOfPresentedViewInContainerView
  }
  //Container view controllers use this method to return the sizes for their child view controllers.
  override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
    switch direction {
    case .left, .right:
      return CGSize(width: parentSize.width * (2.0/3.0), height: parentSize.height)
    default:
      return CGSize(width: parentSize.width, height: parentSize.height*(2.0/3.0))
    }
  }
  
  /// The rectangle of the presented view controller’s view, specified in the container view’s coordinate system.
  override var frameOfPresentedViewInContainerView: CGRect {
    var frame: CGRect = .zero
    frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
    switch direction {
    case .right:
      frame.origin.x = containerView!.frame.width*(1.0/3.0)
    case .left:
      frame.origin = .zero
    case .bottom:
      frame.origin.y = containerView!.frame.height*(1.0/3.0)
    case .top:
      frame.origin = .zero
    }
  }
  
}

private extension SlideInPresentationController {
  func setupDimmingView() {
    dimmingView = UIView()
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    dimmingView.alpha = 0.0
    let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
    dimmingView.addGestureRecognizer(recognizer)
  }
  dynamic func handleTap(recognizer: UITapGestureRecognizer) {
    presentingViewController.dismiss(animated: true)
  }
}
