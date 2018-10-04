# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

# ignore all warnings from all pods
inhibit_all_warnings!

# ignore warnings from a specific pod
#pod 'FBSDKCoreKit', :inhibit_warnings => true

target 'Chroma Habit' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Chroma Habit
  pod 'RealmSwift'
  pod 'JTAppleCalendar', '~> 7.0'
  #pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
  pod 'DynamicColor', '~> 4.0.2'
  pod 'PopupDialog', '~> 0.8'
  pod 'Onboard'

end


target 'Watch Extension' do
  use_frameworks!
  platform :watchos, '2.0'
  #pod 'RealmSwift'
  pod 'DynamicColor', '~> 4.0.2'

end

#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings['SWIFT_VERSION'] = '3.0'
#    end
#  end
#end