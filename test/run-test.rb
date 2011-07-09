#!/usr/bin/env ruby
#
# Copyright (C) 2011  Kouhei Sutou <kou@clear-code.com>
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

$VERBOSE = true

require 'pathname'
require 'shellwords'

base_dir = Pathname(__FILE__).dirname.parent.expand_path
lib_dir = base_dir + "lib"
test_dir = base_dir + "test"

active_ldap_dir = base_dir.parent + "activeldap"
if active_ldap_dir.exist?
  $LOAD_PATH.unshift(active_ldap_dir + "lib")
end

ENV["TEST_UNIT_MAX_DIFF_TARGET_STRING_SIZE"] = "10000"

require 'test/unit'
require 'test/unit/notify'
Test::Unit::Priority.enable

$LOAD_PATH.unshift(lib_dir)

$LOAD_PATH.unshift(test_dir)
require 'active-ldap-fabrication-test-utils'

Dir.glob("test/**/test[_-]*.rb") do |file|
  require file.sub(/\.rb$/, '')
end

exit Test::Unit::AutoRunner.run(false)
