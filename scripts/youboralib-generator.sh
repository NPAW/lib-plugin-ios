#!/bin/sh

xcodebuild archive \
-scheme "YouboraLib iOS" \
-configuration Debug \
-destination 'generic/platform=iOS' \
-archivePath './build/YouboraLib.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
ONLY_ACTIVE_ARCH=NO

xcodebuild archive \
-scheme "YouboraLib iOS" \
-configuration Debug \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/YouboraLib.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
ONLY_ACTIVE_ARCH=NO # \
#EXCLUDED_ARCHS='arm64'

xcodebuild archive \
-scheme "YouboraLib tvOS" \
-configuration Debug \
-destination 'generic/platform=tvOS' \
-archivePath './build/YouboraLib.framework-appletvos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
ONLY_ACTIVE_ARCH=NO

xcodebuild archive \
-scheme "YouboraLib tvOS" \
-configuration Debug \
-destination 'generic/platform=tvOS Simulator' \
-archivePath './build/YouboraLib.framework-appletvsimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
ONLY_ACTIVE_ARCH=NO # \
#EXCLUDED_ARCHS='arm64'

xcodebuild archive \
-scheme "YouboraLib OSX" \
-configuration Debug \
-destination 'generic/platform=macOS' \
-archivePath './build/YouboraLib.framework-macos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
ONLY_ACTIVE_ARCH=NO

xcodebuild -create-xcframework \
-framework './build/YouboraLib.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/YouboraLib.framework' \
-framework './build/YouboraLib.framework-iphoneos.xcarchive/Products/Library/Frameworks/YouboraLib.framework' \
-framework './build/YouboraLib.framework-appletvsimulator.xcarchive/Products/Library/Frameworks/YouboraLib.framework' \
-framework './build/YouboraLib.framework-appletvos.xcarchive/Products/Library/Frameworks/YouboraLib.framework' \
-framework './build/YouboraLib.framework-macos.xcarchive/Products/Library/Frameworks/YouboraLib.framework' \
-output './build/YouboraLib.xcframework'