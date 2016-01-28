Pod::Spec.new do |s|

  s.name         = "PMValidation"
  s.version      = "1.3.2"
  s.summary      = "A modular, extendable text validation library for iOS and tvOS."
  s.description  = <<-DESC
PMValidation is a modular, extendable text validation library for iOS and tvOS. It comes with several common validation types for often-used tasks like validating registration forms, however it was architected to be easily extended with your own validation types.
                   DESC
  s.homepage     = "https://github.com/poetmountain/PMValidation"
  s.license = { :type => 'MIT' }
  s.social_media_url = 'https://twitter.com/petsound'
  s.author       = { "Brett Walker" => "brett@brettwalker.net" } 
  s.ios.deployment_target = '6.0'
  s.tvos.deployment_target = '9.0'
  s.source       = { :git => "https://github.com/poetmountain/PMValidation.git", :tag => "#{s.version}" }
  s.ios.source_files = 'Classes/**/*.{h,m}'
  s.tvos.source_files = 'Classes/**/*.{h,m}'
  s.exclude_files = 'PMValidationDemo'
  s.requires_arc = true
end
