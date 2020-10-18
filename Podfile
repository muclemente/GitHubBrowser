platform :ios, '12.0'
use_frameworks!

def commonPods
  use_frameworks!
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftLint', '~> 0.40.3'
end

target 'App' do
  commonPods
end

target 'Core' do
  commonPods
end

target 'Provider' do
    commonPods
end

target 'Features' do
  commonPods
  pod 'RxDataSources', '~> 4.0'
end

target 'UnitTests' do
  commonPods
  pod 'RxTest'
end
