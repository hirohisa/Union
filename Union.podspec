Pod::Spec.new do |s|

  s.name         = "Union"
  s.version      = "0.3.0"
  s.summary      = "Context transitioning's animation manager for iOS written in Swift."
  s.description  = <<-DESC
  Context transitioning's animation manager for iOS written in Swift.
  Call Union transition on UINavigationControllerDelegate and create animation tasks for each layer's animation and deliver tasks on Union.Delegate.
                   DESC

  s.homepage     = "https://github.com/TransitionKit/Union"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Hirohisa Kawasaki" => "hirohisa.kawasaki@gmail.com" }

  s.source       = { :git => "https://github.com/TransitionKit/Union.git", :tag => s.version }

  s.source_files = "Union/*.swift"
  s.requires_arc = true
  s.ios.deployment_target = '8.0'

end
