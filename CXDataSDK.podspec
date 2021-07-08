#
# Be sure to run `pod lib lint CXDataSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do | s |
    s.name             = 'CXDataSDK'
    s.version          = '1.0'
    s.summary          = '数据埋点SDK'
    
    # This description is used to generate tags and improve search results.
    # * Think: What does it do? Why did you write it? What is the focus?
    # * Try to keep it short, snappy and to the point.
    # * Write the description between the DESC delimiters below.
    # * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = '数据埋点SDK'
    
    s.homepage         = 'https://github.com/ishaolin/CXDataSDK'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'wshaolin' => 'ishaolin@163..com' }
    s.source           = { :git => 'https://github.com/ishaolin/CXDataSDK.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    
    s.frameworks = [
      'CoreGraphics',
      'QuartzCore',
      'CoreTelephony',
      'SystemConfiguration',
      'CFNetwork',
      'Security'
    ]
    
    s.public_header_files = 'CXDataSDK/Classes/**/*.h'
    s.source_files = 'CXDataSDK/Classes/**/*'
    
    s.dependency 'CXNetSDK'
    s.dependency 'CXUIKit'
    s.dependency 'CXDatabaseSDK'
end
