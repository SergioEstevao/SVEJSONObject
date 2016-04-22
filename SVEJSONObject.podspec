Pod::Spec.new do |s|
  s.name             = "SVEJSONObject"
  s.version          = "0.1.0"
  s.summary          = "A simple JSON data deserializer using Swift."
  s.description      = <<-DESC
JSONObject is a simple JSON deserializer using Swift.

The implementation is minimal but very expressive easily extendable.
One of the main features is the handling and trackdown of errors in the json objects.

                       DESC

  s.homepage         = "https://github.com/sergioestevao/SVEJSONObject"
  s.license          = 'MIT'
  s.author           = { "Sérgio Estêvão" => "sergio.estevao@gmail.com" }
  s.source           = { :git => "https://github.com/sergioestevao/SVEJSONObject.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/SergioEstevao'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
