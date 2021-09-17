Pod::Spec.new do |s|
  s.name             = "ImageRow"
  s.version          = "4.0.0"
  s.summary          = "Eureka row that allows us to take or select a picture."
  s.homepage         = "https://github.com/EurekaCommunity/ImageRow"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "Xmartlabs SRL" => "swift@xmartlabs.com" }
  s.source           = { git: "https://github.com/EurekaCommunity/ImageRow.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/EurekaCommunity'
  s.ios.deployment_target = '9.3'
  s.requires_arc = true
  s.ios.source_files = 'Sources/**/*.{swift}'
  s.dependency 'Eureka', '~> 5.3.3'
  s.swift_version = "5.0"
end
