Pod::Spec.new do |spec|

  spec.name         = "AdmobSDK"
  spec.version      = "0.0.20"
  spec.summary      = "A small framework extending from Google-Mobile-Ads-SDK"

  spec.description  = <<-DESC
  AdmobSDK is a Swift framework that supports the base display ad types from google making it convenient to configure
                   DESC

  spec.homepage     = "https://github.com/songoku20"
  spec.license      = { :type => "GNU GPLv2", :file => "./LICENSE" }

  spec.author             = { "songoku20" => "takahashi.senko@gmail.com" }
  
  # spec.platform     = :ios
  spec.platform     = :ios, "12.0"

  spec.source       = { :path => '.'}
  spec.frameworks   = "Foundation", "UIKit", "Photos", "AVFoundation", "AdSupport"
  spec.swift_version = '4.2'
  
  spec.source_files  = "AdmobSDK", "AdmobSDK/**/*.{h,swift,modulemap}", "CostCenterSDK", "CostCenterSDK/**/*.{h,swift,modulemap}"
  spec.exclude_files = "AdmobSDK/Exclude"
  spec.resource_bundles = {'AdmobSDK': 'AdmobSDK/Assets/PrivacyInfo.xcprivacy'}
  spec.resources     = 'AdmobSDK/**/*.{xcassets,pdf,png,jpeg,jpg,storyboard,xib}'

  spec.static_framework = true
  spec.requires_arc = true

  spec.dependency 'FirebaseCrashlytics'
  spec.dependency 'FirebaseAnalytics'
  spec.dependency 'Firebase/RemoteConfig'
  spec.dependency "SnapKit"
  spec.dependency "Adjust"
  spec.dependency "SkeletonView"
  spec.dependency 'RxSwift', '~> 5.1.0'
  spec.dependency 'SVProgressHUD'

  ### Google Admob
  spec.dependency 'Google-Mobile-Ads-SDK'
  spec.dependency 'GoogleUserMessagingPlatform'
  
  ####### MEDIATION ######
#  ### Meta Audience
#  spec.dependency 'GoogleMobileAdsMediationFacebook'

  ### AppLovin
  spec.dependency 'GoogleMobileAdsMediationAppLovin'
  
  ### Mintegral
  spec.dependency 'GoogleMobileAdsMediationMintegral'
  
  ### Liffoff
  spec.dependency 'GoogleMobileAdsMediationVungle'
  
  ### Pangle
#  spec.dependency 'GoogleMobileAdsMediationPangle'
  #### END ####
  
  ### Swift storekit
  spec.dependency 'SwiftyStoreKit'
  
  ### Lottie Animation
  spec.dependency 'lottie-ios'
  
  ### Cost Center SDK
  spec.dependency 'CostCenterSDK', '~> 1.0.1'
  
end
