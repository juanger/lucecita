#
#  LightController.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/21/08.
#  Copyright (c) 2008-2011 MonsterLabs. All rights reserved.
#

class LightController
  
  attr_writer :light_view, :window
  attr_writer :menu, :enabled
  attr_accessor :alpha, :alpha_lbl 
  attr_accessor :size, :size_lbl
  attr_accessor :blur, :blur_lbl
  attr_accessor :hotkeyControl
  
  def awakeFromNib
    @on_icon = NSImage.alloc.initWithContentsOfFile("#{NSBundle.mainBundle.resourcePath}/Lucecita.png")
    @off_icon = NSImage.alloc.initWithContentsOfFile("#{NSBundle.mainBundle.resourcePath}/Lucecita-Off.png")
    
    getUserDefaults()
    activateStatusMenu()
    updateHotkeys()
    @callback = lambda do |p,t,e,r|
      # Activate it with hotkey
      if (t == KCGEventKeyDown && eventIsHotKey?(e))
        toggle(self)
        location = @window.mouseLocationOutsideOfEventStream
        @light_view.center = location
        return nil
      else
        if (t == KCGEventTapDisabledByTimeout)
          CGEventTapEnable(@eventTap, true)
          return e
        end
        if @light_view.enabled
          # Only redraw the light with a little margin, not all the screen
          # because it is very slow
          location = @window.mouseLocationOutsideOfEventStream
          @light_view.center = location
          @light_view.setNeedsDisplayInRect @light_view.light_bounds
          # all the screen would be done with:
          # @light_view.setNeedsDisplay true
        end
      end
      return e
    end
    start_tapping()
  end
  
  def change_alpha(sender)
    @light_view.transparency = @alpha.floatValue
    @alpha_lbl.setStringValue "#{(@alpha.floatValue*100).to_i}%"
    @light_view.setNeedsDisplay true
  end
  
  def change_size(sender)
    @light_view.radius = @size.floatValue
    @size_lbl.setStringValue "#{(@size.intValue)} px"
    @light_view.setNeedsDisplay true
  end
  
  def change_blur(sender)
    if @size.floatValue < 50
      @light_view.blur = @blur.floatValue
      else
      @light_view.blur = @blur.floatValue/2
    end
    @blur_lbl.setStringValue "#{(@blur.intValue)} %"
    @light_view.setNeedsDisplay true
  end
  
  def toggle(sender)
    @light_view.enabled = !@light_view.enabled
    @enabled.setTitle(@light_view.enabled ? NSLocalizedString("DISABLE") : NSLocalizedString("ENABLE"))
    @light_view.setNeedsDisplay true
    icon = nil
    if @light_view.enabled
      @statusItem.setImage @on_icon
    else
      @statusItem.setImage @off_icon
    end
  end
  
  def activateStatusMenu()
    @statusItem = NSStatusBar.systemStatusBar.statusItemWithLength(NSVariableStatusItemLength)
    @statusItem.setImage @off_icon
    @statusItem.setHighlightMode true
    @statusItem.setMenu @menu
  end
  
  def getUserDefaults()
    userDefaults = NSUserDefaults.standardUserDefaults
    
    @size.setFloatValue(userDefaults.objectForKey("Size") || 70)
    @alpha.setFloatValue(userDefaults.objectForKey("Alpha") || 0.5)
    @blur.setFloatValue(userDefaults.objectForKey("Blur") || 20)
    
    @light_view.radius = @size.floatValue();
    @light_view.transparency = @alpha.floatValue();
    @light_view.blur = @blur.floatValue();
  end
  
  def updateHotkeys
    userDefaults = NSUserDefaults.standardUserDefaults;
    
	  @code = userDefaults.objectForKey("hotkey-code");
    @flags = userDefaults.integerForKey("hotkey-flags");
    hotkeyControl.setValueWithCode(@code, flags:@flags)
  end
  
  def eventIsHotKey?(event)
    e = NSEvent.eventWithCGEvent(event)
    return false unless @code && @code == e.keyCode
    return e.modifierFlags == @flags
  end
  
  def hotkeyControlDidChangeWithCode(theCode, flags:theFlags)
    @code = theCode
    @flags = theFlags
  end
  
  def start_tapping
    eventMask = (1 << KCGEventMouseMoved) +
                (1 << KCGEventLeftMouseDragged) +
                (1 << KCGEventRightMouseDragged) +
                (1 << KCGEventOtherMouseDragged) +
                (1 << KCGEventKeyDown)

    @eventTap = CGEventTapCreate(KCGSessionEventTap, KCGHeadInsertEventTap,
                                0, eventMask, @callback, nil)
    @eventSrc = CFMachPortCreateRunLoopSource(nil, @eventTap, 0)
    CGEventTapEnable(@eventTap, true);
    CFRunLoopAddSource(CFRunLoopGetCurrent(),  @eventSrc, KCFRunLoopCommonModes)
  end
  
  def applicationWillTerminate
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), @eventSrc, KCFRunLoopCommonModes)
    userDefaults = NSUserDefaults.standardUserDefaults
    userDefaults.setFloat(@alpha.floatValue, forKey:"Alpha")
    userDefaults.setFloat(@size.floatValue, forKey:"Size")
    userDefaults.setFloat(@blur.floatValue, forKey:"Blur")
  end
  
end
