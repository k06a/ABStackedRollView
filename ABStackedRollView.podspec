Pod::Spec.new do |s|
  s.name         = "ABStackedRollView"
  s.version      = "1.0.0"
  s.summary      = "Simple UICollectionView son, which looks like two piles exchanging their sheets."
  s.homepage     = "https://github.com/k06a/ABStackedRollView"
  s.license      = 'MIT'
  s.author       = { "Anton Bukov" => "k06aaa@gmail.com" }
  s.source       = { :git => "https://github.com/k06a/ABStackedRollView.git", :tag => '1.0.0' }
  s.platform     = :ios, '6.0'
  s.source_files = '*.{h,m}'
  s.requires_arc = true
end
