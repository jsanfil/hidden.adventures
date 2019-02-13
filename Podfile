# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Hidden.Adventures' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for Hidden.Adventures
    pod 'StepSlider'
    pod 'Alamofire', '~> 4.7'
    pod 'ScalingCarousel'
    pod 'Cosmos'
    pod 'AWSCore', '~> 2.6.0'
    pod 'AWSCognitoIdentityProvider', '~> 2.6.0'
    pod 'ObjectMapper', '~> 3.1'
    pod 'AlamofireObjectMapper', '~> 5.0'
    pod 'AlamofireImage', '~> 3.3'
    pod 'Kingfisher', '~> 4.0'
    pod 'AsyncSwift'
    pod 'IQKeyboardManagerSwift'

    target 'Hidden.AdventuresTests' do
        inherit! :search_paths
        # Pods for testing
    end
    
    target 'Hidden.AdventuresUITests' do
        inherit! :search_paths
        # Pods for testing
    end
    
end

# Workaround for Cocoapods issue #7606
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
