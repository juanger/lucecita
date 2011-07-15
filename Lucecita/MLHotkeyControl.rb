#
#  MLHotkeyTextView.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/12/11.
#  Copyright 2011 UNAM. All rights reserved.
#

class MLHotkeyControl < NSControl
  
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
  
  def awakeFromNib
    userDefaults = NSUserDefaults.standardUserDefaults;
    
	  code = userDefaults.integerForKey("hotkey-code");
    flags = userDefaults.integerForKey("hotkey-flags");
    setValueWithCode(code, flags:flags)
  end
  
  def keyDown(event)
    code = event.keyCode;
	  flags = event.modifierFlags;
    
    userDefaults = NSUserDefaults.standardUserDefaults;
    
	  userDefaults.setInteger(code, forKey:"hotkey-code");
    userDefaults.setInteger(flags, forKey:"hotkey-flags");
    
    setValueWithCode(code, flags:flags)
  end
  
  def acceptsFirstResponder
    return true;
  end
  
  def acceptsFirstMouse(theEvent)
    return true;
  end
  
  def setValueWithCode(theCode, flags:theFlags)
    if theCode
      @label.setStringValue(modifierCharacters(theFlags) + KEYCODES[theCode])
    else
      @label.setStringValue("")
    end
    
    @delegate.hotkeyControlDidChangeWithCode(theCode, flags:theFlags) if @delegate
  end
  
  private
  
  def modifierCharacters(flags)
    chars = ""
    if flags & NSControlKeyMask == NSControlKeyMask
      chars += "^ "
    end
    if flags & NSAlternateKeyMask == NSAlternateKeyMask
      chars += "⌥ "
    end
    if flags & NSShiftKeyMask == NSShiftKeyMask
      chars += "⇧ "
    end
    if flags & NSCommandKeyMask == NSCommandKeyMask
      chars += "⌘ "
    end
    return chars
  end
end
