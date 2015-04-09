Union
==========

Context transitioning's animation manager for iOS written in Swift.
Create animation tasks for each layer's animation and deliver tasks on Union.Delegate.

Requirements
----------

- iOS 7.0+
- Xcode 6.3 Swift 1.2

Installation
----------

It is the way to use this in your project:

- Add Union as a submodule by opening the Terminal, trying to enter the command
```
git submodule add https://github.com/hirohisa/Union.git
```

- Install with CocoaPods to write Podfile

```ruby
pod 'Union', '~> 0.0.1'
```

Sample
----------

I create sample animation with Union, it is like "[User-Profile-Interface-Animation](https://dribbble.com/shots/1744157-User-Profile-Interface-Animation)" from dribbble.com.

see [project](Example).


![ ](https://raw.github.com/hirohisa/Union/master/Gif/sample.gif)

Features
----------

- [x] Support CABasicAnimation.
- [x] Support CAKeyframeAnimation.
- [ ] Support UIView.animateWithDuration Block.


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
let task = Task(layer:layer, animation:animation)
```

- Init with delay time and completion block

  Use when there is a process not an animation
```
let task = Task(delay: 0.3) {
    self.view.insertSubview(self.imageView, aboveSubview: self.backgroundView)
}
```


Union.Task class:

```swift
public class Task {
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
    optional func tasksBeforeTransition(operation: UINavigationControllerOperation) -> [Task]
    optional func tasksDuringTransition(operation: UINavigationControllerOperation) -> [Task]
}
```

- `func tasksBeforeTransition(operation: UINavigationControllerOperation) -> [Task]`

  Transition begin after these tasks are completed and this method is called by `UIViewController` displayed only.

- `func tasksDuringTransition(operation: UINavigationControllerOperation) -> [Task]`

  Tasks called by two `UIViewController`s start during transition. `context.completeTransition(true)` is called after all tasks are completed.

#### Call Union transition on UINavigationControllerDelegate

```swift
extension ViewController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController,
         animationControllerForOperation operation: UINavigationControllerOperation,
                         fromViewController fromVC: UIViewController,
                             toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return Union.transition(operation)
    }
}
```

License
----------

Union is available under the MIT license.
