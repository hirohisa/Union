//
//  ViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 2015/02/12.
//  Copyright (c) 2015年 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Union
import QuartzCore

class CollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        imageView.clipsToBounds = true
        return imageView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds

        let mask = CAShapeLayer()
        mask.path = circlePathWithRect(imageView.bounds).CGPath
        imageView.layer.mask = mask
        addSubview(imageView)
    }

    func circlePathWithRect(frame: CGRect) -> UIBezierPath {
        let center = CGPoint(x: CGRectGetWidth(frame)/2, y: CGRectGetHeight(frame)/2)

        let path = UIBezierPath(arcCenter: center, radius: CGRectGetHeight(frame)/2, startAngle: 0, endAngle: 360, clockwise: true)
        return path
    }
}


class ViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: CGRectGetWidth(collectionView!.frame), height: 200)
        collectionView?.collectionViewLayout = layout
        collectionView?.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

}

extension ViewController: UICollectionViewDelegate {

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CollectionViewCell {
            let center = collectionView.convertPoint(cell.center, toView: view)

            let image = UIImage(named: "image")

            let viewController = ArticleViewController(imageView: cell.imageView, center: center)

            navigationController?.delegate = self
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDataSource {

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as CollectionViewCell

        cell.imageView.image = UIImage(named: "image")

        return cell
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        switch operation {
        case .Push:
            return Union.transition(operation)
        default:
            break
        }

        return nil
    }

    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return nil
    }
}