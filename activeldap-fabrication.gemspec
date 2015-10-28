# -*- coding: utf-8; mode: ruby -*-
#
# Copyright (C) 2013  Kouhei Sutou <kou@clear-code.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

base_dir = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(base_dir, 'lib'))
require 'active_ldap_fabrication/version'

Gem::Specification.new do |spec|
  spec.name = "activeldap-fabrication"
  spec.version = ActiveLdapFabrication::VERSION::STRING.dup
  spec.authors = ["Kouhei Sutou"]
  spec.email = ["kou@clear-code.com"]
  spec.summary = "ActiveLdap Fabrication is an ActiveLdap adapter for Fabrication."
  spec.description = "'ActiveLdap Fabrication' is an ActiveLdap adapter for Fabrication. It means that you can use Fabrication as fixture replacement for ActiveLdap."
  spec.homepage = "http://activeldap.github.io/"
  spec.licenses = ["LGPLv2 or later"]
  spec.require_paths = ["lib"]
  spec.files = [
    "COPYING",
    "Gemfile",
    "Rakefile",
    "README.textile",
    "#{spec.name}.gemspec",
    ".yardopts",
  ]
  spec.files += Dir.glob("lib/**/*.rb")
  spec.files += Dir.glob("doc/text/**/*")
  spec.test_files = Dir.glob("test/test[_-]*.rb")
  spec.test_files = ["test/test-generate.rb"]

  spec.add_dependency("activeldap")
  spec.add_dependency("fabrication")
  spec.add_development_dependency("net-ldap")
  spec.add_development_dependency("bundler")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("test-unit")
  spec.add_development_dependency("test-unit-notify")
  spec.add_development_dependency("yard")
  spec.add_development_dependency("RedCloth")
  spec.add_development_dependency("packnga")
end

