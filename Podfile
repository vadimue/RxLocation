platform :ios, '9.0'

target 'RxLocation' do
  use_frameworks!

  # Architecture
  pod 'ReactorKit'
  pod 'Swinject'
  pod 'SwinjectStoryboard'
  pod 'SwinjectAutoregistration'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxOptional'

  # Testing
  target 'RxLocationTests' do
    inherit! :complete
    pod 'RxTest'
  end

end

post_install do |installer|
  pods_dir = File.dirname(installer.pods_project.path)
end
