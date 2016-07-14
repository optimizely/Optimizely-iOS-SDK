Pod::Spec.new do |s|
  s.name             = "Optimizely-iOS-SDK"
  s.version          = "1.6.0"
  s.summary          = "Optimizely is the #1 optimization platform in the world."
  s.homepage         = "http://www.optimizely.com"
  s.license          = { :type => 'Commercial', :text => 'See http://developers.optimizely.com/ios/terms' }
  s.author           = { "Optimizely" => "support@optimizely.com" }
  s.social_media_url = 'https://twitter.com/optimizely'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source           = { 
    :git => "https://github.com/optimizely/Optimizely-iOS-SDK.git", 
    :tag => s.version.to_s
  }

  s.frameworks = 'AudioToolbox', 'CFNetwork', 'Foundation', 'MobileCoreServices', 'Security', 'SystemConfiguration', 'UIKit'
  s.libraries = 'icucore', 'sqlite3'
  s.ios.vendored_frameworks = "Optimizely.framework"
end
