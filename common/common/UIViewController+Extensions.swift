//
//  UIViewController+Extensions.swift
//  common
//
//  Created by Victor Amaro on 29/11/21.
//

import UIKit

public protocol Indictable: AnyObject {
    var indicatorView: UIActivityIndicatorView? {get set}
}

extension Indictable where Self: UIViewController {
    
    public func displayActivityIndicator(style: UIActivityIndicatorView.Style = .large) {
        let innerIndicatorView = UIActivityIndicatorView(style: style)
        view.addSubview(innerIndicatorView)
        
        innerIndicatorView.center = view.center
        innerIndicatorView.startAnimating()
        
        indicatorView = innerIndicatorView
    }
    
    public func hideActivityIndicator() {
        indicatorView?.stopAnimating()
        indicatorView?.removeFromSuperview()
        indicatorView = nil
    }
}
