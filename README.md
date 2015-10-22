Union
==========

Context transitioning's animation manager for iOS written in Swift.
Create animation tasks for each layer's animation and deliver tasks on Union.Delegate.


Features
----------

- [x] Support CABasicAnimation.
- [x] Support CAKeyframeAnimation.
- [x] Support UIView.animateWithDuration Block.
- [x] Link to other tasks, use property `dependencies`.
- [x] Support UIViewControllerTransitioningDelegate.
- [ ] Support UITabBarControllerDelegate.

Requirements
----------

- iOS 8.0+
- Xcode 7.0+ Swift 2.0

Installation
----------

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

To integrate Union into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Union'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that automates the process of adding frameworks to your Cocoa application.

* Unsupport

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate Union into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

- Add ImageLoader as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

```bash
$ git submodule add https://github.com/TransitionKit/Union.git
```

Sample
----------

I create sample animation with Union, it is like "[User-Profile-Interface-Animation](https://dribbble.com/shots/1744157-User-Profile-Interface-Animation)" from dribbble.com.

see [project](Example).

![ ](https://raw.github.com/TransitionKit/Union/master/Gif/sample.gif)

Usage
----------

1. Create animation.
2. Implement animation tasks in Union.Delegate.
3. Call Union transition on UINavigationControllerDelegate.


#### Create animation

Unit of animation is Union.Task. There are two ways to create it:

- Init with layer and animation

  Most cases is this pattern
```
let animation = Animation(layer:layer, animation:animation)
```

- Init with delay time and completion block

  Use when there is a process not an animation
```
let animation = Animation(delay: 0.3) {
    self.view.insertSubview(self.imageView, aboveSubview: self.backgroundView)
}
```


Union.Animation class:

```swift
public class Animation {
    // public property
    public var delay: NSTimeInterval = 0.0 // animation start after delay time
    public var completion: () -> () = {} // block called when animation is finished

    public init(layer: CALayer, animation: CAPropertyAnimation) {
        self.layer = layer
        self.animation = animation
    }

    public init (delay: NSTimeInterval, completion: () -> ()) {
        self.delay = delay
        self.completion = completion
    }
}
```

#### Implement animation tasks in Union.Delegate

Call animation tasks from UIViewControllers with Union.Delegate protocol.


Union.Delegate protocol:

```swift
public protocol Delegate {
    func animationsBeforeTransitionTo(viewController: UIViewController) -> [Animation]
    func animationsDuringTransitionFrom(viewController: UIViewController) -> [Animation]
}
```

- `animationsBeforeTransitionTo(viewController: UIViewController) -> [Animation]`

  Transition begin after these tasks are completed and this method is called by `UIViewController` displayed only.

- `animationsDuringTransitionFrom(viewController: UIViewController) -> [Animation]`

  Tasks called by two `UIViewController`s start during transition. `context.completeTransition(true)` is called after all tasks are completed.

#### Animation start on UINavigationControllerDelegate

```swift
extension ViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController,
         animationControllerForOperation operation: UINavigationControllerOperation,
                         fromViewController fromVC: UIViewController,
                             toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Union.Navigator.animate()
    }
}
```

#### Animation start on UIViewControllerTransitioningDelegate

```
extension ViewController: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return Union.Presentor.animate()
    }
}
```

License
----------

Union is available under the MIT license.
