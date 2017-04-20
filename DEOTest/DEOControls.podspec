Pod::Spec.new do |s|
  s.name         = "DEOControls"
  s.version      = "0.0.4"
  s.summary      = "DEOControls"
  s.homepage     = "https://github.com/deo24/DEOControls"
  s.license      = "MIT"
  s.author       = { "deo24" => "email@address.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/deo24/DEOControls.git", :tag => "#{s.version}" }
  s.source_files  = "DEOControls", "DEOTest/DEOTest/DEOTestControl/*.{h,m}"
  s.requires_arc = true
end
