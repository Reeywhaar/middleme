abort "Usage: #{$0} <cask_path> <version> <sha256>" unless ARGV.length == 3

file, version, sha = ARGV

abort "Invalid SHA-256: #{sha}" unless sha.match?(/\A[a-f0-9]{64}\z/)

content = <<~RUBY
  cask "middleme" do
    version "#{version}"
    sha256 "#{sha}"

    url "https://github.com/Reeywhaar/middleme/releases/download/\#{version}/MiddleMe.zip"
    name "MiddleMe"
    desc "Simple app to make trackpad treat triple tap as middle click"
    homepage "https://github.com/Reeywhaar/MiddleMe"

    app "MiddleMe.app"

    uninstall quit: "com.vyrtsev.mac.MiddleMe"
    uninstall login_item: "MiddleMe"
  end
RUBY

File.write(file, content)
puts "Written #{file} (middleme #{version})"