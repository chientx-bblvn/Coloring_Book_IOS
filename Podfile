use_frameworks!

platform :ios, '13.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end

def shared_pods
  
  pod 'R.swift'
  
  # Core Dependencies
  pod 'SwiftLint', '~> 0.50.0'
  pod 'Reusable', '~> 4.1.0'
  pod 'IQKeyboardManagerSwift', '6.5.10'
  pod 'Moya/RxSwift', '~> 14.0.0'
  
  # For keychain manager
  pod 'KeychainAccess'
  
  ### pod for load image
  pod 'SDWebImage'
  pod 'lottie-ios'
  
  # For firebase
  #  # (Recommended) Pod for Google Analytics
  pod 'Firebase/Messaging'
  
  pod 'BmoViewPager', :path => "./Submodules/BmoViewPager"
  
  ### Admobs
  pod 'AdmobSDK', :git => "https://github.com/Binary-Bridge-Labs/ADMobSDK", :tag => 'v0.0.13'
#  pod 'AdmobSDK', :path => "../../SDK-Library/AdmobSDK"
  
  ### SQLite DB
  pod 'SQLite.swift'
  
end

target 'Doll-Coloring' do

  shared_pods
  
end
