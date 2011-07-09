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

require "erb"
require "yaml"
require "socket"
require "rbconfig"
require "tempfile"

require "active_ldap_fabrication"

LDAP_ENV = "test" unless defined?(LDAP_ENV)

module ActiveLdapFabricationTestUtils
  class << self
    def included(base)
      base.class_eval do
        include Utilities
        include Config
        include Connection
        include Populate
      end
    end
  end

  module Utilities
    def dn(string)
      ActiveLdap::DN.parse(string)
    end
  end

  module Config
    def setup
      super
      @base_dir = File.expand_path(File.dirname(__FILE__))
      @top_dir = File.expand_path(File.join(@base_dir, ".."))
      @config_file = File.join(@base_dir, "config.yaml")
      ActiveLdap::Base.configurations = read_config
    end

    def teardown
      super
    end

    def current_configuration
      ActiveLdap::Base.configurations[LDAP_ENV]
    end

    def read_config
      unless File.exist?(@config_file)
        raise "config file for testing doesn't exist: #{@config_file}"
      end
      erb = ERB.new(File.read(@config_file))
      erb.filename = @config_file
      config = YAML.load(erb.result)
      _adapter = adapter
      config.each do |key, value|
        value["adapter"] = _adapter if _adapter
      end
      config
    end

    def adapter
      ENV["ACTIVE_LDAP_TEST_ADAPTER"]
    end

    def fixture(*components)
      File.join(@fixtures_dir, *components)
    end
  end

  module Connection
    def setup
      super
      ActiveLdap::Base.setup_connection
    end

    def teardown
      ActiveLdap::Base.remove_active_connections!
      super
    end
  end

  module Populate
    def setup
      @dumped_data = nil
      super
      begin
        @dumped_data = ActiveLdap::Base.dump(:scope => :sub)
      rescue ActiveLdap::ConnectionError
      end
      ActiveLdap::Base.delete_all(nil, :scope => :sub)
      populate
    end

    def teardown
      if @dumped_data
        ActiveLdap::Base.setup_connection
        ActiveLdap::Base.delete_all(nil, :scope => :sub)
        ActiveLdap::Base.load(@dumped_data)
      end
      super
    end

    def populate
      populate_base
      populate_ou
      populate_user_class
    end

    def populate_base
      ActiveLdap::Populate.ensure_base
    end

    def ou_class(prefix="")
      ou_class = Class.new(ActiveLdap::Base)
      ou_class.ldap_mapping(:dn_attribute => "ou",
                            :prefix => prefix,
                            :classes => ["top", "organizationalUnit"])
      ou_class
    end

    def dc_class(prefix="")
      dc_class = Class.new(ActiveLdap::Base)
      dc_class.ldap_mapping(:dn_attribute => "dc",
                            :prefix => prefix,
                            :classes => ["top", "dcObject", "organization"])
      dc_class
    end

    def entry_class(prefix="")
      entry_class = Class.new(ActiveLdap::Base)
      entry_class.ldap_mapping(:prefix => prefix,
                               :scope => :sub,
                               :classes => ["top"])
      entry_class.dn_attribute = nil
      entry_class
    end

    def populate_ou
      %w(Users Groups).each do |name|
        make_ou(name)
      end
    end

    def make_ou(name)
      ActiveLdap::Populate.ensure_ou(name)
    end

    def make_dc(name)
      ActiveLdap::Populate.ensure_dc(name)
    end

    def populate_user_class
      @user_class = Class.new(ActiveLdap::Base)
      @user_class_classes = ["posixAccount", "person"]
      @user_class.ldap_mapping :dn_attribute => "uid",
                               :prefix => "ou=Users",
                               :scope => :sub,
                               :classes => @user_class_classes
      def @user_class.name
        "User"
      end
    end
  end
end

require 'models/user'
