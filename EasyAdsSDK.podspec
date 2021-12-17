#
#  Be sure to run `pod spec lint EasyAdsSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name             = 'EasyAdsSDK'
    
    s.version          = '1.0.2'
    s.ios.deployment_target = '9.0'
    s.platform     = :ios, "9.0"
    s.requires_arc = true
    
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.summary          = 'bayescom iOS EasyAdsSDK'
    s.description      = <<-DESC
    欢迎大家使用EasyAdsSDK, EasyAdsSDK旨在帮助一些中小型App开发团队快速而高效的集成市面上主流的广告SDK
    600+ 移动媒体选择的广告商业化管理工具，定制私有的移动媒体商业化解决方案。优质上游资源一网打尽，接入方式快速透明稳定。支持流量分发、渠道策略、精准投放、数据报表、排期管理、广告审核等全流程业务场景。
    DESC
    
    s.homepage         = 'http://www.bayescom.com/'
    
    s.author           = { 'bayescom' => 'http://www.bayescom.com/' }
    s.source           = { :git => 'https://github.com/bayescom/EasyAds-iOS.git', :tag => s.version.to_s }
    
    s.user_target_xcconfig = {'OTHER_LDFLAGS' => ['-ObjC']}
    
    valid_archs = ['i386', 'armv7', 'x86_64', 'arm64']
    # bitcode
#    s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO', 'VALID_ARCHS' => valid_archs.join(' '), 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
#    s.user_target_xcconfig = { 'ENABLE_BITCODE' => 'NO', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO'}
    s.user_target_xcconfig = { 'ENABLE_BITCODE' => 'NO'}

    s.default_subspec = 'Core'
    
    s.requires_arc = true
    s.static_framework = true
    
    s.subspec 'Core' do |core|
        core.source_files = 'EasyAdsSDK/Core/**/*.{h,m}'
        core.frameworks = 'UIKit', 'Foundation', 'AdSupport'
    end
    
    s.subspec 'Adspot' do |adspot|
        adspot.dependency 'EasyAdsSDK/Core'
        adspot.source_files = 'EasyAdsSDK/Adspot/**/*.{h,m}'
    end
    
    s.subspec 'CSJ' do |csj|
        csj.dependency 'EasyAdsSDK/Core'
        csj.dependency 'EasyAdsSDK/Adspot'
        csj.dependency 'Ads-CN'
        csj.source_files = 'EasyAdsSDK/Adapter/CSJ/**/*.{h,m}'
        csj.frameworks = 'UIKit', 'MapKit', 'WebKit', 'MediaPlayer', 'CoreLocation', 'AdSupport', 'CoreMedia', 'AVFoundation', 'CoreTelephony', 'StoreKit', 'SystemConfiguration', 'MobileCoreServices', 'CoreMotion', 'Accelerate','AudioToolbox','JavaScriptCore','Security','CoreImage','AudioToolbox','ImageIO','QuartzCore','CoreGraphics','CoreText'
        csj.libraries = 'c++', 'resolv', 'z', 'sqlite3', 'bz2', 'xml2', 'iconv', 'c++abi'
        #    valid_archs = ['armv7', 'i386', 'x86_64', 'arm64']
        
    end
    
    s.subspec 'GDT' do |gdt|
        gdt.dependency 'EasyAdsSDK/Core'
        gdt.dependency 'EasyAdsSDK/Adspot'
        gdt.dependency 'GDTMobSDK'
        gdt.source_files =  'EasyAdsSDK/Adapter/GDT/**/*.{h,m}'
        gdt.frameworks = 'AdSupport', 'CoreLocation', 'QuartzCore', 'SystemConfiguration', 'CoreTelephony', 'Security', 'StoreKit', 'AVFoundation', 'WebKit'
        gdt.libraries     = 'xml2', 'z'
    end
        
    s.subspec 'KS' do |ks|
        ks.dependency 'EasyAdsSDK/Core'
        ks.dependency 'EasyAdsSDK/Adspot'
        ks.dependency 'KSAdSDK'
        ks.source_files = 'EasyAdsSDK/Adapter/Kuaishou/**/*.{h,m}'
        ks.frameworks = ["Foundation", "UIKit", "MobileCoreServices", "CoreGraphics", "Security", "SystemConfiguration", "CoreTelephony", "AdSupport", "CoreData", "StoreKit", "AVFoundation", "MediaPlayer", "CoreMedia", "WebKit", "Accelerate", "CoreLocation", "AVKit", "MessageUI", "QuickLook", "AudioToolBox", "AddressBook"]
        ks.libraries =  ["z", "resolv.9", "sqlite3", "c++", "c++abi"]
    end
    
    s.subspec 'BD' do |bd|
        bd.dependency 'EasyAdsSDK/Core'
        bd.dependency 'EasyAdsSDK/Adspot'
        bd.dependency 'BaiduMobAdSDK'
        bd.source_files =  'EasyAdsSDK/Adapter/BD/**/*.{h,m}'
        bd.frameworks = 'CoreLocation', 'SystemConfiguration', 'CoreGraphics', 'CoreMotion', 'CoreTelephony', 'AdSupport', 'SystemConfiguration', 'QuartzCore', 'WebKit', 'MessageUI','SafariServices','AVFoundation','EventKit','QuartzCore','CoreMedia','StoreKit'
        bd.libraries     = 'c++'
        bd.weak_frameworks = "WebKit"
        valid_archs = ['armv7', 'armv7s', 'x86_64', 'arm64']
        
        
    end
    
    
    s.xcconfig = {
        'VALID_ARCHS' =>  valid_archs.join(' '),
    }
    
end
