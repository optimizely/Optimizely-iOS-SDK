Pod::Spec.new do |s|
  s.name             = "Optimizely-iOS-SDK"
  s.version          = "1.0.88"
  s.summary          = "Optimizely is the #1 optimization platform in the world."
  s.homepage         = "http://www.optimizely.com"
  s.license          = { :type => 'Commercial', :text => 'See http://developers.optimizely.com/ios/terms' }
  s.author           = { "Optimizely" => "support@optimizely.com" }
  s.social_media_url = 'https://twitter.com/optimizely'

  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }

  s.source           = { :git => "https://github.com/optimizely/Optimizely-iOS-SDK.git", :tag => "1.0.88" }

  s.frameworks = 'AudioToolbox', 'CFNetwork', 'Foundation', 'MobileCoreServices', 'Security', 'SystemConfiguration', 'UIKit'
  s.libraries = 'icucore', 'sqlite3'

  s.preserve_paths      = "Optimizely.framework", "scripts/*"
  s.public_header_files = "Optimizely.framework/**/*.h"
  s.vendored_frameworks = "Optimizely.framework"
end
