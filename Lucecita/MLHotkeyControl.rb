#
#  MLHotkeyTextView.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/12/11.
#  Copyright 2011 MonsterLabs. All rights reserved.
#

class MLHotkeyControl < NSView
  
  attr_writer :label
  attr_writer :delegate
  
  KEYCODES = {
    0x1D => "0", 0x12 => "1", 0x13 => "2", 0x14 => "3",
    0x15 => "4", 0x17 => "5", 0x16 => "6", 0x1A => "7",
    0x1C => "8", 0x19 => "9", 0x00 => "A", 0x0B => "B",
    0x08 => "C", 0x02 => "D", 0x0E => "E", 0x03 => "F",
    0x05 => "G", 0x04 => "H", 0x22 => "I", 0x26 => "J",
    0x28 => "K", 0x25 => "L", 0x2E => "M", 0x2D => "N",
    0x1F => "O", 0x23 => "P", 0x0C => "Q", 0x0F => "R",
    0x01 => "S", 0x11 => "T", 0x20 => "U", 0x09 => "V",
    0x0D => "W", 0x07 => "X", 0x10 => "Y", 0x06 => "Z",
    0x2a => "\\"
  }
  
  def initWithFrame(frame)
    result = super(frame)
    @label = NSTextField.alloc.initWithFrame(NSMakeRect(2, 2, CGRectGetWidth(frame)-4, CGRectGetHeight(frame)-4))
    @label.alignment =  NSCenterTextAlignment
    @label.editable = false
    @label.selectable = false
    self.addSubview(@label)
    button = NSButton.alloc.initWithFrame(NSMakeRect(CGRectGetWidth(frame)-18, CGRectGetHeight(frame)-18, 12, 15));
    button.setTitle("")
    image = NSImage.imageNamed(NSImageNameStopProgressFreestandingTemplate)
    image.setTemplate(true)
    button.setImage(image)
    button.setImageScaling(NSImageScaleProportionallyDown)
    button.setTarget(self)
    button.setAction(:deleteShortcut)
    button.setBezelStyle(NSSmallSquareBezelStyle)
    button.setBordered(false)
    self.addSubview(button)
    @recording = false
    return result
  end

  def awakeFromNib
    userDefaults = NSUserDefaults.standardUserDefaults;

    code = userDefaults.objectForKey("hotkey-code")
    flags = userDefaults.integerForKey("hotkey-flags")
    setValueWithCode(code, flags:flags)
  end
  
  def keyDown(event)
    if @recording
      code = event.keyCode;
      flags = event.modifierFlags;

      userDefaults = NSUserDefaults.standardUserDefaults
    
      userDefaults.setInteger(code, forKey:"hotkey-code")
      userDefaults.setInteger(flags, forKey:"hotkey-flags")
      setValueWithCode(code, flags:flags)
      self.window.makeFirstResponder(self.window)
      @recording = false
    end
  end
  
  def mouseDown(event)
    @recording = true
    self.window.makeFirstResponder(self)
  end
  
  def acceptsFirstResponder
    return @recording;
  end
  
  def acceptsFirstMouse(theEvent)
    return true;
  end
  
  def becomeFirstResponder
    @label.setStringValue(NSLocalizedString("TYPE_SHORTCUT"))
    @delegate.hotkeyControlDidChangeWithCode(nil, flags:nil) if @delegate
    return true;
  end
  
  def resignFirstResponder
    userDefaults = NSUserDefaults.standardUserDefaults;
    
	  code = userDefaults.objectForKey("hotkey-code")
    flags = userDefaults.integerForKey("hotkey-flags")
    setValueWithCode(code, flags:flags)
    return true;
  end
  
  def deleteShortcut
    @label.setStringValue(NSLocalizedString("TYPE_SHORTCUT"))
    @delegate.hotkeyControlDidChangeWithCode(nil, flags:nil) if @delegate
    @recording = true
    self.window.makeFirstResponder(self)
  end
  
private
  
  def modifierCharacters(flags)
    chars = ""
    if flags & NSControlKeyMask == NSControlKeyMask
      chars += "^"
    end
    if flags & NSAlternateKeyMask == NSAlternateKeyMask
      chars += "⌥"
    end
    if flags & NSShiftKeyMask == NSShiftKeyMask
      chars += "⇧"
    end
    if flags & NSCommandKeyMask == NSCommandKeyMask
      chars += "⌘"
    end
    return chars
  end
  
  def setValueWithCode(theCode, flags:theFlags)
    if theCode
      @label.setStringValue(modifierCharacters(theFlags) + KEYCODES[theCode])
      else
      @label.setStringValue(NSLocalizedString("CLICK_TO_CHANGE"))
    end
    
    @delegate.hotkeyControlDidChangeWithCode(theCode, flags:theFlags) if @delegate
  end
end
