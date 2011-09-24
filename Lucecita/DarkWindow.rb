#
#  DarkWindow.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/19/08.
#  Copyright (c) 2008-2010 MonsterLabs. All rights reserved.
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

  def constrainFrameRect(frameRect, toScreen:screen)
    #return the unaltered frame, or do some other interesting things
    return frameRect
  end

  private

  def allScreensRect
    NSScreen.screens.inject(NSMakeRect(0,0,0,0)) do  |r,s|
      r = NSUnionRect(r, s.frame)
    end
  end
end