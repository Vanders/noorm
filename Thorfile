require 'thor'
require 'thor-scmversion'

class Noorm < Thor
  desc 'build', 'Build the gem'
  def build
    invoke 'version:current'
    system("gem build -V 'noorm.gemspec'")
  end
end
