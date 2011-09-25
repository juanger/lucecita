#
#  MLHotkeyTransformer.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 9/24/11.
#  Copyright 2011 UNAM. All rights reserved.
#

class MLHotkeyTransformer < NSValueTransformer
  KEYCODES = {
  0x1D => "0", 0x12 => "1", 0x13 => "2", 0x14 => "3",
  0x15 => "4", 0x17 => "5", 0x16 => "6", 0x1A => "7",
  0x1C => "8", 0x19 => "9", 0x00 => "a", 0x0B => "b",
  0x08 => "c", 0x02 => "d", 0x0E => "e", 0x03 => "f",
  0x05 => "g", 0x04 => "h", 0x22 => "o", 0x26 => "j",
  0x28 => "k", 0x25 => "l", 0x2E => "m", 0x2D => "n",
  0x1F => "o", 0x23 => "p", 0x0C => "q", 0x0F => "r",
  0x01 => "s", 0x11 => "t", 0x20 => "u", 0x09 => "v",
  0x0D => "w", 0x07 => "x", 0x10 => "y", 0x06 => "z",
  0x2a => "\\"
  }
  
  KEYCHARS = KEYCODES.invert
  
  def self.transformedValueClass
    NSString
  end

  def self.allowsReverseTransformation
    true
  end

  def transformedValue(value)
    KEYCODES[value]
  end

  def reverseTransformedValue(value)
    KEYCHARS[value]
  end
end