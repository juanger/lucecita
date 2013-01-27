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
  
  attr_accessor :char, :flags
  
  def awakeFromNib
    @on_icon = NSImage.alloc.initWithContentsOfFile("#{NSBundle.mainBundle.resourcePath}/Lucecita.png")
    @off_icon = NSImage.alloc.initWithContentsOfFile("#{NSBundle.mainBundle.resourcePath}/Lucecita-Off.png")
    
    activateStatusMenu()
    bindDefaults()
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
  
  def applicationWillTerminate
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), @eventSrc, KCFRunLoopCommonModes)
  end
  
  def showPreferences(sender)
    @prefsController ||= NSWindowController.alloc.initWithWindowNibName "Preferences"
    @prefsController.window.makeKeyAndOrderFront nil
    NSApplication.sharedApplication.arrangeInFront nil
  end
  
private

  def bindDefaults
    userDefaults = NSUserDefaultsController.sharedUserDefaultsController
    self.bind("char", toObject: userDefaults,
                   withKeyPath: "values.hotkey-char",
                       options: { NSContinuouslyUpdatesValue: 1 })
    self.bind("flags", toObject: userDefaults,
              withKeyPath: "values.hotkey-flags",
              options: { 
                  NSContinuouslyUpdatesValue: 1
              })
    @enabled.bind("keyEquivalent", toObject: userDefaults,
                  withKeyPath: "values.hotkey-char",
                  options: {
                  NSContinuouslyUpdatesValue: 1
              })
    @enabled.bind("keyEquivalentModifierMask", toObject: userDefaults,
              withKeyPath: "values.hotkey-flags",
              options: { NSContinuouslyUpdatesValue: 1 })
    puts "Char: #{char.to_s}"
  end
    
  def eventIsHotKey?(event)
    e = NSEvent.eventWithCGEvent(event)
    return false unless @char && @char == e.charactersIgnoringModifiers
    return e.modifierFlags == @flags
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
  
  
end
