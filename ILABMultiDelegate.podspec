Pod::Spec.new do |s|
  s.name         = "ILABMultiDelegate"
  s.version      = "0.0.2"
  s.summary      = "Objective-C delegate multiplexing."
  s.homepage     = "https://github.com/jawngee/ILABMultiDelegate"
  s.license      = 'MIT'
  s.author       = { "Jon Gilkison" => "jon@interfacelab.com" }
  s.source       = { :git => "https://github.com/jawngee/ILABMultiDelegate.git", :tag => "0.0.2" }
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.source_files = 'Source'
  s.requires_arc = true
end
