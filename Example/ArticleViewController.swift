//
//  ArticleViewController.swift
//  Example
//
//  Created by Hirohisa Kawasaki on 2015/02/13.
//  Copyright (c) 2015年 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import Union

class TableViewCell: UITableViewCell {

    var labels = [UILabel]()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        labels = [UILabel(), UILabel(), UILabel()]
        for l: UILabel in labels {
            l.backgroundColor = UIColor.lightGrayColor()
            addSubview(l)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        var x: CGFloat = {
            if let imageView = self.imageView {
                return CGFloat(CGRectGetMaxX(imageView.frame) + 15)
            }

            return 0.0
        }()
        var y: CGFloat = 5.0
        labels[0].frame = CGRect(x: x, y: y, width: 40.0, height: 5.0)

        y = CGRectGetMaxY(labels[0].frame) + 5
        labels[1].frame = CGRect(x: x, y: y, width: 200.0, height: 10.0)

        y = CGRectGetMaxY(labels[1].frame) + 5
        labels[2].frame = CGRect(x: x, y: y, width: 160.0, height: 8.0)
    }
}

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

    let tableView = UITableView()

    required init(imageView: UIImageView, center: CGPoint) {
        self.imageView.image = imageView.image
        self.imageView.bounds = imageView.bounds
        self.imageView.center = center
        self.backgroundView.center = center
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .None
        backgroundView.frame = self.view.frame
        self.view.addSubview(backgroundView)
        backgroundView.addSubview(imageView)

        configure_view()
        let length = CGRectGetWidth(self.view.frame)

        tableView.frame = CGRect(
            x: 0,
            y: CGRectGetHeight(self.view.frame),
            width: length,
            height: CGRectGetHeight(self.view.frame) - 200
        )
        tableView.showsVerticalScrollIndicator = false
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.view.addSubview(tableView)
    }

    func configure_view() {
        let mask = CAShapeLayer()
        let center = imageView.center
        let path = UIBezierPath(arcCenter: center, radius: CGRectGetHeight(imageView.frame)/2, startAngle: 0, endAngle: 360, clockwise: true)
        mask.path = path.CGPath
        backgroundView.layer.mask = mask
    }

}

extension ArticleViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as TableViewCell

        cell.imageView?.image = UIImage(named: "icon")

        var index = indexPath.row

        return cell
    }
}

extension ArticleViewController: Union.Delegate {

    func tasksDuringTransition(operation: UINavigationControllerOperation) -> [Task] {
        return [revealAnimationTask(), switchLayerTask(), slideImageViewAnimationTask(), slideTableViewAnimationTask()]
    }

    func revealAnimationTask() -> Task {

        let mask = backgroundView.layer.mask as CAShapeLayer
        let startPath = mask.path
        let endPath = UIBezierPath(arcCenter: imageView.center, radius: CGRectGetHeight(view.frame)/2, startAngle: 0, endAngle: 360, clockwise: true).CGPath

        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = startPath
        animation.toValue = endPath
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.duration = 0.7

        let task = Task(layer:mask, animation:animation)
        return task
    }

    func switchLayerTask() -> Task {
        let task = Task(delay: 0.3) {
            self.view.insertSubview(self.imageView, aboveSubview: self.backgroundView)
        }

        return task
    }

    func slideImageViewAnimationTask() -> Task {
        let length = CGRectGetWidth(view.frame)
        let point = CGPoint(x: imageView.layer.position.x, y: 100)

        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(CGPoint: imageView.layer.position)
        animation.toValue = NSValue(CGPoint: point)
        animation.duration = 0.3

        let task = Task(layer:imageView.layer, animation:animation)
        task.delay = 0.3

        return task
    }

    func slideTableViewAnimationTask() -> Task {
        let length = CGRectGetWidth(view.frame)

        let position = CGPoint(x: tableView.layer.position.x, y: CGRectGetHeight(imageView.frame) + CGRectGetHeight(tableView.frame)/2)

        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(CGPoint: tableView.layer.position)
        animation.toValue = NSValue(CGPoint: position)
        animation.duration = 0.3

        let task = Task(layer:tableView.layer, animation:animation)
        task.delay = 0.3
        return task
    }
}

