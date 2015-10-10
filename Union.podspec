Pod::Spec.new do |s|

  s.name         = "Union"
  s.version      = "0.4.0"
  s.summary      = "Context transitioning's animation manager for iOS written in Swift."
  s.description  = <<-DESC
  Context transitioning's animation manager for iOS written in Swift.
Create animation tasks for each layer's animation and deliver tasks on Union.Delegate.
                   DESC

  s.homepage     = "https://github.com/TransitionKit/Union"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Hirohisa Kawasaki" => "hirohisa.kawasaki@gmail.com" }

  s.source       = { :git => "https://github.com/TransitionKit/Union.git", :tag => s.version }

  s.source_files = "Union/*.swift"
  s.requires_arc = true
  s.ios.deployment_target = '8.0'

end
