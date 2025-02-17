install:
	flutter pub get

start:
	flutter run

andr:
	flutter build apk --debug
	flutter install

ios:
	flutter build ios

asset-link:
	flutter pub run flutter_assets

clean:
	flutter clean
	cd android && ./gradlew clean

local_build_android_qa:
	cd android && ./gradlew assembleQa

local_build_android_prod:
	cd android && ./gradlew assembleRelease

build:
	bundle exec fastlane android distribute_staging
	bundle exec fastlane ios distribute_staging

build-ios:
	bundle exec fastlane ios distribute_staging

build-android:
	bundle exec fastlane android distribute_staging

build-qa-ios:
	bundle exec fastlane ios distribute_qa

build-qa-android:
	bundle exec fastlane android distribute_qa

open-ios:
	@open ios/Runner.xcworkspace

open-android:
	@open -a /Applications/Android\ Studio.app ./android
