#
#  LuzView.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/19/08.
#  Copyright (c) 2008 UNAM. All rights reserved.
#

require 'osx/cocoa'
include OSX
#require_framework 'CoreGraphics'

class LuzView <  OSX::NSView

  attr_accessor :center, :rect, :radius, :blur
  attr_accessor :transparency, :enabled
  OFFSET = 35

  def initialize
    @radius = 70
    @transparency = 0.5
    @blur = 20
    @enabled = true
  end

  def drawRect(rect)
    if @enabled

    NSGraphicsContext.currentContext.setCompositingOperation NSCompositeSourceOut
    context = NSGraphicsContext.currentContext.graphicsPort
    #CGContextSetBlendMode(context, KCGBlendModeColorDodge)
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, @transparency)
    CGContextFillRect(context, rect)
    
    @center = NSEvent.mouseLocation    
    @rect = NSRect.new(@center.x - @radius, @center.y - @radius, @radius*2, @radius*2) 
    drawLight
    end
  end
  
  def drawLight
    context = NSGraphicsContext.currentContext.graphicsPort
    CGContextSetGrayStrokeColor(context, 0, 1)
    CGContextSetLineWidth(context, 0)
    
    CGContextSaveGState(context)
    
    CGContextSetShadow(context, CGSizeMake(0, -@radius*2 - OFFSET), @blur)
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1)
    CGContextClipToRect(context, light_bounds)     
    CGContextAddEllipseInRect(context, fake_rect())
    CGContextDrawPath(context, KCGPathFill)   
    
    CGContextRestoreGState(context)
  end

  def fake_rect
    rect = @rect.clone
    rect.y += @radius*2 + OFFSET
    rect
  end

  def light_bounds
    NSInsetRect(@rect, -OFFSET, -OFFSET)
  end

end
