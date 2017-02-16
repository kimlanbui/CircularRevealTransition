#
# Be sure to run `pod lib lint CircularRevealTransition.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CircularRevealTransition'
  s.version          = '2.0.0'
  s.summary          = 'Provides a circular reveal transition between view controllers.'
  s.description      = <<-DESC
A Swift library to provide a circular reveal transition between view controllers.
                       DESC

  s.homepage         = 'https://github.com/kimlanbui/CircularRevealTransition'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'kim.l4n.bui@googlemail.com'
  s.source           = { :git => 'https://github.com/kimlanbui/CircularRevealTransition.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'CircularRevealTransition/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CircularRevealTransition' => ['CircularRevealTransition/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
