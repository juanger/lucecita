#
#  DarkWindow.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/19/08.
#  Copyright (c) 2008-2010 UNAM. All rights reserved.
#

class DarkWindow < NSWindow
  
  def initWithContentRect(contentRect, styleMask:aStyle, backing:bufferingType, defer:flag)
    result = super(NSScreen.mainScreen.frame,
                   NSBorderlessWindowMask,
                   bufferingType,
                   flag)
    if result
      result.setBackgroundColor(NSColor.clearColor)
      result.setOpaque false
      result.setIgnoresMouseEvents true
      result.setLevel(NSScreenSaverWindowLevel)
      result.setCollectionBehavior NSWindowCollectionBehaviorCanJoinAllSpaces
      result.useOptimizedDrawing true
    end
    
    result
  end
  
end