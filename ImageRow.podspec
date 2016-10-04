Pod::Spec.new do |s|
  s.name             = "ImageRow"
  s.version          = "1.0.0"
  s.summary          = "A short description of ImageRow."
  s.homepage         = "https://github.com/EurekaCommunity/ImageRow"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "Xmartlabs SRL" => "swift@xmartlabs.com" }
  s.source           = { git: "https://github.com/EurekaCommunity/ImageRow.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/EurekaCommunity'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.ios.source_files = 'ImageRow/Sources/**/*.{swift}'
  # s.resource_bundles = {
  #   'ImageRow' => ['ImageRow/Sources/**/*.xib']
  # }
  # s.ios.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'Eureka', '~> 1.0'
end
