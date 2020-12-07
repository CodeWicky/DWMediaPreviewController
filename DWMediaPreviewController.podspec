Pod::Spec.new do |s|
s.name = 'DWMediaPreviewController'
s.version = '0.0.0.46'
s.license = { :type => 'MIT', :file => 'LICENSE' }
s.summary = '一个媒体预览库，高仿系统相册风格。Media preview frameworks.'
s.homepage = 'https://github.com/CodeWicky/DWMediaPreviewController'
s.authors = { 'codeWicky' => 'codewicky@163.com' }
s.source = { :git => 'https://github.com/CodeWicky/DWMediaPreviewController.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '9.0'
s.source_files = 'DWMediaPreviewController/**/*.{h,m}'
s.resource = 'DWMediaPreviewController/DWMediaPreviewController.bundle'
s.frameworks = 'UIKit'
s.dependency 'YYImage', '~> 1.0.4'
s.dependency 'DWPlayer', '~> 0.0.0.5'
s.dependency 'DWKit/DWUtils/DWOperationCancelFlag', '~> 0.0.0.8'
s.dependency 'DWKit/DWComponent/DWFixAdjustCollectionView','~> 0.0.0.12'
end
