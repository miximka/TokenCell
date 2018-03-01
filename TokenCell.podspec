#
# Be sure to run `pod lib lint TokenCell.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TokenCell"
  s.version          = "1.2.0"
  s.summary          = "Subclass of UITableViewCell to present and edit tokens similar to the iOS mail app."
  s.description      = <<-DESC
                       Subclass of UITableViewCell to present and edit tokens similar to the iOS mail app.

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/miximka/TokenCell"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "miximka" => "miximka@gmail.com" }
  s.source           = { :git => "https://github.com/miximka/TokenCell.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/miximka'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
end
