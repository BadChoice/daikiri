Pod::Spec.new do |spec|

  spec.name         = "Daikiri"
  spec.version      = "1.9.6"
  spec.summary      = "Daikiri json - model - coredata made easy, it is like Laravel Eloquent but for iOS"
  spec.description  = "Daikiri is a really easy library to work with json - model - coredata in the easiest, intuitive and fluent way. Inspired in Laravel Eloquent. There is also a clear factory method for making testing painless"
  spec.homepage     = "https://revo.works"
  spec.license      = "MIT"  
  spec.author             = { "Jordi Puigdellívol" => "jordi@gloobus.net" }
  spec.social_media_url   = "https://instagram.com/badchoice2"

  spec.source = { 
    :git => "https://github.com/BadChoice/daikiri.git", 
    :tag => "1.9.6" 
  }

  spec.source_files  = ""daikiri/lib/**/*""

  spec.dependency "Collection", "~> 1.10.24"
  spec.dependency "MBFaker",    "~> 0.1.2"

end
