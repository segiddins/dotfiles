#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org/'
  gem 'xcodeproj'
  gem 'activesupport', require: 'active_support'
end

ActiveSupport.eager_load!
require 'active_support/encrypted_configuration'

require 'yaml'

encs = Dir["config/credentials/*.yml.enc"]

creds = encs.to_h do |f|
  n = File.basename f, ".yml.enc"
  c = ActiveSupport::EncryptedConfiguration.new(config_path: f, key_path: File.join(File.dirname(f), "#{n}.key"), env_key: n, raise_if_missing_key: true)
  [n, c]
end
creds.transform_values!(&:config)

class HasDiff
  def to_s
    "<DIFF>"
  end
end

DIFF = HasDiff.new.freeze

def common(a, b)
  return HasDiff.new unless a.class == b.class
  
  case a.class
  when Hash.singleton_class
    a.map do |k, v|
      next unless b.key?(k)
      bv = b[k]
      
      nv = common(v, bv)
#     next if HasDiff.new.equal?(nv)
      [k, nv]
    end.compact.to_h
  else
    a == b ? a : HasDiff.new
  end
end

common_hash = creds.each_value.reduce do |acc, elem|
  common(acc, elem)
end

def diff(a, b, al, bl)

require 'tempfile'
  
  
  Tempfile.create("#{al}.yaml") do |cf|
    cf.write YAML.dump a
    cf.close

      Tempfile.create("#{bl}.yaml") do |ef|  
        ef.write YAML.dump b
        ef.close
        system(
          "delta", "--paging=never", "--side-by-side", cf.path, ef.path, {out: :out, err: :err, in: :in}
        )
      end
  end
end

if ARGV.size == 2
  diff(
    creds.fetch(ARGV[0]),
    creds.fetch(ARGV[1]),
    ARGV[0],
    ARGV[1],
  )
end
