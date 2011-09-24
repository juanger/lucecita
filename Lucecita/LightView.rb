#
#  LightView.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/19/08.
#  Copyright (c) 2008-2011 MonsterLabs. All rights reserved.
#

class LightView <  NSView
  
  attr_accessor :center, :rect, :radius, :blur
  attr_accessor :transparency, :enabled
  OFFSET = 25.0
  
  def awakeFromNib
    @enabled = false
    @center = NSEvent.mouseLocation
  end
  
  def drawRect(rect)
    if @enabled
      context = NSGraphicsContext.currentContext.graphicsPort
      CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, @transparency)
      CGContextFillRect(context, rect)
      CGContextSetBlendMode(context, KCGBlendModeSourceOut)
      
      # Get the area where the light will be drawn
      rect = NSMakeRect(@center.x - @radius, @center.y - @radius, @radius*2, @radius*2) 
      if NSIntersectsRect(rect, self.frame)
        @rect = rect
        drawLight
      end
    end
  end
  
  def drawLight
    context = NSGraphicsContext.currentContext.graphicsPort
    CGContextSetGrayStrokeColor(context, 0, 1)
    CGContextSetLineWidth(context, 0)
    
    CGContextSaveGState(context)
    # For the blur effect, the trick is draw a shadow far from the circle
    # Show shadow below the circle and in the @rect
    CGContextSetShadow(context, CGSizeMake(0, - @radius*2 - OFFSET*4), @blur)
    
    # Only draw the area of the shadow plus a margin
    CGContextClipToRect(context, light_bounds)
    # Draw the ellipse in the hidden rect
    CGContextAddEllipseInRect(context, fake_rect())
    CGContextDrawPath(context, KCGPathFill)   
    CGContextRestoreGState(context)
  end
  
  # This is the rect where the ellipse is drawn, although
  # only its whadow is shown to the user
  def fake_rect
    rect = @rect.clone
    rect.origin.y += @radius*2 + OFFSET*4
    rect
  end
  
  def light_bounds
    NSInsetRect(@rect, -OFFSET*2, -OFFSET*2)
  end
  
end
