# -*- mode: ruby; coding: utf-8 -*-

clean_white_space = lambda do |entry|
  entry.gsub(/(\A\n+|\n+\z)/, '') + "\n"
end

base_dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(base_dir, 'lib'))
require "active_ldap_fabrication/version"

ENV["VERSION"] ||= ActiveLdapFabrication::VERSION::STRING
version = ENV["VERSION"].dup

entries = File.read("README.textile").split(/^h2\.\s(.*)$/)
description = clean_white_space.call(entries[entries.index("Description") + 1])
summary, description, = description.split(/\n\n+/, 3)

Gem::Specification.new do |spec|
  spec.name = "activeldap-fabrication"
  spec.version = version
  spec.rubyforge_project = "ruby-activeldap"
  spec.authors = ["Kouhei Sutou"]
  spec.email = ["kou@clear-code.com"]
  spec.license = "LGPLv2 or later"
  spec.summary = summary
  spec.description = description
  spec.homepage = "http://ruby-activeldap.rubyforge.org/"
  spec.files = Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("doc/text/**/*")
  spec.files += ["COPYING", "Gemfile", "README.textile"]
  spec.files += ["Rakefile", "activeldap-fabrication.gemspec"]
  spec.test_files = Dir.glob("test/test[_-]*.rb")

  spec.add_runtime_dependency("activeldap")
  spec.add_runtime_dependency("fabrication", ">= 2.7.2")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("net-ldap")
  spec.add_development_dependency("test-unit")
  spec.add_development_dependency("test-unit-notify")
  spec.add_development_dependency("packnga")
  spec.add_development_dependency("RedCloth")
end
