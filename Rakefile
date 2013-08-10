# -*- coding: utf-8; mode: ruby -*-
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

require 'rake/testtask'
require "rake/clean"
require "packnga"
require "bundler/gem_helper"

$KCODE = "u" if RUBY_VERSION < "1.9"

base_dir = File.dirname(__FILE__)
helper = Bundler::GemHelper.new(base_dir)
def helper.version_tag
  version
end
helper.install
spec = helper.gemspec

Rake::Task["release"].prerequisites.clear

Packnga::DocumentTask.new(spec) do |task|
  task.original_language = "en"
  task.translate_language = "ja"
end

Packnga::ReleaseTask.new(spec) do |task|
end

def rsync_to_rubyforge(spec, source, destination, options={})
  config = YAML.load(File.read(File.expand_path("~/.rubyforge/user-config.yml")))
  host = "#{config["username"]}@rubyforge.org"

  rsync_args = "-av --exclude '*.erb' --chmod=ug+w"
  rsync_args << " --delete" if options[:delete]
  remote_dir = "/var/www/gforge-projects/#{spec.rubyforge_project}/"
  sh("rsync #{rsync_args} #{source} #{host}:#{remote_dir}#{destination}")
end

namespace :reference do
  desc "Upload document to rubyforge."
  task :publish => [:generate, "reference:publication:prepare"] do
    reference_base_dir = Pathname.new("doc/reference")
    html_base_dir = Pathname.new("doc/html")
    html_reference_dir = html_base_dir + spec.name

    rsync_to_rubyforge(spec, "#{html_reference_dir}/", spec.name)
  end
end

desc "Upload document and HTML to rubyforge."
task :publish => ["reference:publish"]
