require "rake"
require "fileutils"

desc "Incrementa a versão e executa o build"
task :version_increment_and_build do
  version_file = "lib/bitrix24/version.rb"
  content = File.read(version_file)

  new_content = content.gsub(/VERSION = "(\d+)\.(\d+)\.(\d+)"/) do |_match|
    major = Regexp.last_match(1).to_i
    minor = Regexp.last_match(2).to_i
    patch = Regexp.last_match(3).to_i
    patch += 1
    "VERSION = \"#{major}.#{minor}.#{patch}\""
  end

  File.write(version_file, new_content)
  puts "Versão incrementada: #{new_content.match(/VERSION = "(.*)"/)[1]}"

  sh "rake build"
end
