require 'rubygems'

# the whole reason this file exists:   to return an error if openssl
# isn't installed.
require 'openssl'

# create dummy rakefile to indicate success
f = File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w")
f.write("task :default\n")
f.close

# based on
# https://github.com/tablatom/hobo/commit/0085d4d3c5fdf2f71ca8f4412927c5147fa3d96f
# Thanks tablatom! ;)
