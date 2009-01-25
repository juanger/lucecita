#
#  rb_main.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/19/08.
#  Copyright (c) 2008 UNAM. All rights reserved.
#

require 'osx/cocoa'
require 'hotkey'

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
    require( File.basename(path) )
  end
end

if $0 == __FILE__ then
  rb_main_init
  OSX::NSApplicationWithHotKey.sharedApplication
  OSX.NSApplicationMain(0, nil)
end
