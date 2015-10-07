//
//  ProfileViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 5/26/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Union

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"

        view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ProfileViewController: Union.Delegate {

    func animationsDuringTransitionFrom(viewController: UIViewController) -> [Animation] {
        return []
    }

    func animationsBeforeTransitionTo(viewController: UIViewController) -> [Animation] {
        return []
    }
}
