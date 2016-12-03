Pod::Spec.new do |s|
  s.name         = "OTPKit"
  s.version      = "0.1.4"
  s.summary      = "Pure Swift implementations of one-time password algorithms."
  s.description  = <<-DESC
                     OTPKit is a Swift framework containing implementations of one-time password algorithms.
                   DESC
  s.homepage     = "https://github.com/chrisamanse/OTPKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.author            = { "Chris Amanse" => "chris@chrisamanse.xyz" }
  s.social_media_url  = "http://twitter.com/ChrisAmanse"
  
  s.ios.deployment_target      = "9.0"
  s.osx.deployment_target      = "10.10"
  s.watchos.deployment_target  = "2.0"
  s.tvos.deployment_target     = "10"
  
  s.source        = { :git => "https://github.com/chrisamanse/OTPKit.git", :tag => "#{s.version}" }
  s.source_files  = "Sources", "Sources/**/*.{h,swift}"
  
  s.requires_arc         = true
  s.pod_target_xcconfig  = { 'SWIFT_VERSION' => '3.0' }
  
  s.dependency "CryptoKit", "~> 0"
end
