//
//  ArticleViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 2/13/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Union

class ArticleViewController: UIViewController {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
        }()
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor()
        return view
    }()

    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15.0)
        textView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)

        return textView
    }()

    let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "dribbble")
        imageView.sizeToFit()
        return imageView
    }()

    let texts: NSArray = [
        "Orange (voiced by Dane Boedigheimer) is the lead protagonist and main character,appearing in every episode since the series began on October 9, 2009.",
        "He has yellow teeth, grey eyes, and a braying laugh.",
        "He is known for his annoying puns which he uses in every episode,although hardly any of the fruits seem to find his puns amusing.",
        "His standard reply, uttered after being taken to task for being annoying, is, 'I'm not annoying,', 'I'm an orange!', Unlike many fruits think, Orange doesn't have control over his tendency to be annoying.",
        "It was suggested by Mango in 'It takes two to Mango' that Orange is annoying because of the carnage he has seen during his life.",
    ]

    required init(imageView: UIImageView, center: CGPoint) {
        self.imageView.image = imageView.image
        self.imageView.bounds = imageView.bounds
        self.imageView.center = center
        backgroundView.center = center
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "The Annoying Orange?"
        edgesForExtendedLayout = .None

        configureBackgroundView()
        configureTextView()
        configureIconView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = nil
    }

    func configureBackgroundView() {
        backgroundView.frame = view.frame

        // background View
        let mask = CAShapeLayer()
        let center = imageView.center
        let path = UIBezierPath(arcCenter: center, radius: CGRectGetHeight(imageView.frame)/2, startAngle: 0, endAngle: 360, clockwise: true)
        mask.path = path.CGPath
        backgroundView.layer.mask = mask

        view.addSubview(backgroundView)
        backgroundView.addSubview(imageView)
    }

    func configureTextView() {
        let length = CGRectGetWidth(view.frame)

        textView.frame = CGRect(
            x: 0,
            y: CGRectGetHeight(view.frame),
            width: length,
            height: CGRectGetHeight(view.frame) - 200
        )
        textView.text = texts.componentsJoinedByString("\n")
        textView.showsVerticalScrollIndicator = false
        view.addSubview(textView)
    }

    func configureIconView() {
        iconView.center = CGPoint(x: CGRectGetWidth(view.frame) - 50, y: CGRectGetHeight(imageView.frame))
        iconView.transform = CGAffineTransformMakeScale(0.0, 0.0)
        view.addSubview(iconView)
    }

}

extension ArticleViewController: Union.Delegate {

    func animationsBeforeTransitionTo(viewController: UIViewController) -> [Animation] {
        return []
    }

    func animationsDuringTransitionFrom(viewController: UIViewController) -> [Animation] {

        let animation = switchLayerAnimation()
        let slideImageAnimation = slideImageViewAnimationAnimation()
        let slideTextAnimation = slideTextViewAnimationAnimation()

        animation.dependencies = [slideImageAnimation, slideTextAnimation]

        return [revealAnimationAnimation(), animation, scaleIconVIewAnimationAnimation()]
    }

    func revealAnimationAnimation() -> Animation {

        let mask = backgroundView.layer.mask as! CAShapeLayer
        let startPath = mask.path
        let endPath = UIBezierPath(arcCenter: imageView.center, radius: CGRectGetHeight(view.frame)/2, startAngle: 0, endAngle: 360, clockwise: true).CGPath

        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = 0.7

        return Animation(layer:mask, animation:animation)
    }

    func switchLayerAnimation() -> Animation {
        let animation = Animation(delay: 0.3) {
            self.view.insertSubview(self.imageView, aboveSubview: self.backgroundView)
        }

        return animation
    }

    func slideImageViewAnimationAnimation() -> Animation {
        let point = CGPoint(x: imageView.layer.position.x, y: 100)

        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(CGPoint: imageView.layer.position)
        animation.toValue = NSValue(CGPoint: point)
        animation.duration = 0.3

        return Animation(layer:imageView.layer, animation:animation)
    }

    func slideTextViewAnimationAnimation() -> Animation {
        let position = CGPoint(x: textView.layer.position.x, y: CGRectGetHeight(imageView.frame) + CGRectGetHeight(textView.frame)/2)

        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(CGPoint: textView.layer.position)
        animation.toValue = NSValue(CGPoint: position)
        animation.duration = 0.3

        return Animation(layer:textView.layer, animation:animation)
    }

    func scaleIconVIewAnimationAnimation() -> Animation {

        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.0, 0.1, 0.2, 0.3, 0.5]
        animation.duration = 0.1

        let a = Animation(layer:iconView.layer, animation:animation)
        a.delay = 0.6
        return a
    }
}