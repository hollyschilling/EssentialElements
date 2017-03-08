Pod::Spec.new do |s|
  s.name        = "EssentialElements"
  s.version     = "0.4.0"
  s.summary     = "UI Elements that every iOS App needs and every iOS developer is tired of building themselves."
  s.homepage    = "https://github.com/hollyschilling/EssentialElements"
  s.license     = { :type => "MIT" }
  s.authors     = { "hollyschilling" => "holly.a.schilling@outlook.com" }

  s.requires_arc = true
  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "9.0"
  s.source   = { :git => "https://github.com/hollyschilling/EssentialElements.git", :tag => s.version }
  s.source_files = "EssentialElements/EssentialElements/**/*.swift"
end
