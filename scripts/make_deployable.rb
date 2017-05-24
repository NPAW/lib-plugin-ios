#!/usr/bin/env ruby
require 'fileutils'
require 'json'

""" 
Before running this script, the following the manifest.json shold be available.
There's a script for creating that manifest.
'ruby scripts/createManifest.rb'

This script does the following:
- Build the folder structure ready to be uploaded to the CDN.

The script should be invoked from the project root directory.
'ruby scripts/make_deployable.rb <project_name>'
"""

# Build
puts `carthage build --no-skip-current --platform ios`
puts `carthage build --no-skip-current --platform tvos`
puts `carthage archive`

# Create deployment folder structure
manifest_file_path = 'manifest.json'
if File.directory?('deploy')
    `rm -r deploy`
end

lib_framework = "YouboraLib"

# Load manifest to extract data from it
json = JSON.parse(File.read(manifest_file_path))

version = json["version"]

package_type = ""
deployable_name = "lib"

if (json["type"] == "adapter")
    package_type = "adapters"

    deployable_name = ARGV[0]
    if deployable_name == nil
        deployable_name = json["name"]
    end 
end

last_build_path = "deploy/last-build/" + package_type + "/" + deployable_name + "/last-build"
version_path = "deploy/version/" + package_type + "/" + deployable_name + "/" + version

# Create folder structure
cmd = "mkdir -p " + last_build_path
puts `#{cmd}`

# Copy manifest, sample and ipa
puts "Copying manifest..."
cmd = "cp " + manifest_file_path + " " + last_build_path
puts `#{cmd}`
puts "Copying binary..."
cmd = "cp " + lib_framework + ".framework.zip " + last_build_path
puts `#{cmd}`
# Copy to "version" path
cmd = "mkdir -p " + version_path
puts `#{cmd}`
cmd = "cp -r " + last_build_path + "/* " + version_path
puts `#{cmd}`

puts "Done!"
