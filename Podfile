# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
inhibit_all_warnings!

target 'JellyGarden' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for JellyGarden
	pod 'Alamofire', '~> 4.6.0’#类似于afnetworking
	pod 'HandyJSON', '~> 4.1.1'#json转model
    pod 'PKHUD', '~> 5.0.0’#遮罩
	pod 'Kingfisher', '~> 4.6.1’#图片缓存
	pod 'IQKeyboardManagerSwift', '~> 5.0.7'
    pod 'HTHorizontalSelectionList', '~> 0.7.4'
    pod 'TZImagePickerController'
	pod 'SnapKit', '~> 4.0.0'	
    #友盟
    pod 'UMCShare/UI'
    pod 'UMCShare/Social/ReducedWeChat'
    pod 'UMCShare/Social/QQ'
    pod 'JPush', '~> 3.0.7'
    pod 'YYModel', '~> 1.0.4'
    pod 'AliyunOSSiOS'#阿里云存储
    pod 'MJRefresh'
    pod 'RongCloudRTC/RongCallLib', '~> 2.9.0'
     pod 'RongCloudRTC/RongCallKit', '~> 2.9.0'

    post_install do |installer_representation|
        installer_representation.pods_project.build_configurations.each do |config|
            config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
            config.build_settings['SDKROOT'] = 'iphoneos'
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end

