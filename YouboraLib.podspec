Pod::Spec.new do |s|

  s.name         = "YouboraLib"
  s.version      = "6.0.0-rc"

  # Metadata
  s.summary      = "Library required by Youbora plugins"

  s.description  = "<<-DESC
                    YouboraLib is a library created by Nice People at Work. It serves
                    as the shared logic for all Youbora plugins and it also allows you
                    to create your own plugins.
                     DESC"

  s.homepage     = "http://developer.nicepeopleatwork.com/"

  s.license      = { :type => "MIT", :file => "LICENSE.md" }

  s.author             = { "Nice People at Work" => "support@nicepeopleatwork.com" }

  # Platforms
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"

  # Source Location
  s.source       = { :git => 'https://github.com/NPAW/lib-plugin-ios.git', :tag => s.version}

  # Source files
  s.source_files  = 'YouboraLib/**/*.{h,m}'
  s.public_header_files = "YouboraLib/**/*.h"

  # Project settings
  s.requires_arc = true
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) YOUBORALIB_VERSION=' + s.version.to_s }

end
