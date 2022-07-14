# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'SNS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Appirater'
  # Pods for SNS

  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Storage'
  pod 'Firebase/Functions'
  pod 'KRProgressHUD'
  pod 'SkeletonView'
  pod 'MessageKit'
  pod 'MessageInputBar'
  pod 'Cosmos'
  pod 'InstantSearchClient'
  pod 'AlgoliaSearchClient'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
      end
    end
  end
  

end
