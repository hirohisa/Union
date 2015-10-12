//
//  NavigationBar.swift
//
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

extension UINavigationBar {

    public var backgroundView: UIView? {
        if let n = self as? NavigationBar {
            return n._backgroundView
        }
        return nil
    }
}

public class NavigationBar: UINavigationBar {

    override public var translucent: Bool {
        didSet {
            if translucent {
                addBackgroundView()
            } else {
                removeBackgroundView()
            }
        }
    }
    private let _backgroundView = UIView()

    func addBackgroundView() {
        setBackgroundImage(UIImage(), forBarMetrics: .Default)
        _backgroundView.userInteractionEnabled = false
        _backgroundView.backgroundColor = barTintColor
        insertSubview(_backgroundView, atIndex: 0)
    }

    func removeBackgroundView() {
        _backgroundView.removeFromSuperview()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        if translucent {
            _backgroundView.frame = CGRect(x: 0, y: -20, width: bounds.width, height: bounds.height + 20)
        }

        if needsChangeBackBarButtonItem() {
            changeBackBarButtonItem()
        }
    }

    func needsChangeBackBarButtonItem() -> Bool {
        return topItem?.backBarButtonItem == nil
    }

    func changeBackBarButtonItem() {
        let backButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        topItem?.backBarButtonItem = backButtonItem
    }
}