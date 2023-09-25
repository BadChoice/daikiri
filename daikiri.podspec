Pod::Spec.new do |spec|

  spec.name             = "daikiri"
  spec.version          = "1.9.12"
  spec.summary          = "Daikiri json - model - coredata made easy, it is like Laravel Eloquent but for iOS"
  spec.description      = "Daikiri is a really easy library to work with json - model - coredata in the easiest, intuitive and fluent way. Inspired in Laravel Eloquent. There is also a clear factory method for making testing painless"
  spec.homepage         = "https://revo.works"
  spec.license          = "MIT"  
  spec.author           = { "Jordi Puigdellívol" => "jordi@gloobus.net" }
  spec.social_media_url = "https://instagram.com/badchoice2"
  spec.requires_arc     = true
  spec.ios.deployment_target = "13.0"

  spec.source = { 
    :git => "https://github.com/BadChoice/daikiri.git", 
    :tag => spec.version.to_s 
  }

  spec.source_files  = "daikiri/lib/**/*"
  spec.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }

  spec.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }

  spec.dependency "Collection", "~> 1.10.25"

end
