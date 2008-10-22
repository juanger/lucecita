#
#  DarkWindow.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/19/08.
#  Copyright (c) 2008 UNAM. All rights reserved.
#

require 'osx/cocoa'

class DarkWindow < OSX::NSWindow
  
  def initWithContentRect_styleMask_backing_defer(contentRect, aStyle, bufferingType, flag)
    result = super_initWithContentRect_styleMask_backing_defer(OSX::NSScreen.mainScreen.frame,
                  OSX::NSBorderlessWindowMask,
                  bufferingType,
                  flag)
    if result
      result.setBackgroundColor(OSX::NSColor.clearColor)
      result.setOpaque false
      result.setIgnoresMouseEvents true
      result.setLevel(OSX::NSScreenSaverWindowLevel)
      result.setCollectionBehavior OSX::NSWindowCollectionBehaviorCanJoinAllSpaces
      result.useOptimizedDrawing true
    end
    
    result
  end

end