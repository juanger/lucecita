#
#  LuzController.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/21/08.
#  Copyright (c) 2008 UNAM. All rights reserved.
#

require 'osx/cocoa'

class LuzController < OSX::NSObject
  
  ib_outlets :light_view
  ib_outlets :menu, :enabled
  ib_outlets :alpha, :alpha_lbl, :size, :size_lbl, :blur, :blur_lbl
  
  def awakeFromNib
    activateStatusMenu()
    @callback = lambda { |p,t,e,r|
      # Activate it on Control-MouseButon3
      if (t == KCGEventOtherMouseDown &&
        CGEventGetFlags(e) & KCGEventFlagMaskControl == KCGEventFlagMaskControl)
        toggle(self)
        return
      end
      if @light_view.enabled
        # Only redraw the light with a little margin, not all the screen
        # because it is very slow
        @light_view.setNeedsDisplayInRect @light_view.light_bounds
        # all the screen would be done with:
        # @light_view.setNeedsDisplay true
      end
      e 
    }
    start_tapping()
  end
  
  ib_action :change_alpha do |sender|
    @light_view.transparency = @alpha.floatValue
    @alpha_lbl.setStringValue "#{(@alpha.floatValue*100).to_i}%"
    @light_view.setNeedsDisplay true
  end
  
  ib_action :change_size do |sender|
    @light_view.radius = @size.floatValue
    @size_lbl.setStringValue "#{(@size.intValue)} px"
    @light_view.setNeedsDisplay true
  end
  
  ib_action :change_blur do |sender|
    if @size.floatValue < 50
      @light_view.blur = @blur.floatValue
    else
      @light_view.blur = @blur.floatValue/2
    end
    @blur_lbl.setStringValue "#{(@blur.intValue)} %"
    @light_view.setNeedsDisplay true
  end
  
  ib_action :toggle do |sender|
    @light_view.enabled = !@light_view.enabled
    @enabled.setState(@light_view.enabled ? 1 : 0)
    @light_view.setNeedsDisplay true
  end
  
  def activateStatusMenu()
      statusItem = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength)
      statusItem.retain
      icon = NSImage.alloc.initWithContentsOfFile("#{NSBundle.mainBundle.resourcePath}/Lucecita.png")
      statusItem.setImage icon
      statusItem.setHighlightMode true
      statusItem.setMenu @menu
  end
  
  def start_tapping
    eventMask = 167772384 # Magic Number: LeftMouseDragged MouseMoved RightMouseDragged OtherMouseDragged OtherMouseDown
    eventTap = CGEventTapCreate(KCGSessionEventTap, KCGHeadInsertEventTap,
                                0, eventMask, @callback, nil)
    eventSrc = CFMachPortCreateRunLoopSource(nil, eventTap, 0)
    CFRelease(eventTap)
    CFRunLoopAddSource(CFRunLoopGetCurrent(),  eventSrc, KCFRunLoopCommonModes)
    CFRelease(eventSrc)
  end

  def applicationShouldTerminate
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), mEventSrc, KCFRunLoopCommonModes)
  end
  
end
