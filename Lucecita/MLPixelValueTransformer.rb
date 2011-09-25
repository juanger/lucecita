#
#  MLPixelValueTransformer.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 9/25/11.
#  Copyright 2011 UNAM. All rights reserved.
#
class MLPixelValueTransformer < NSValueTransformer
  
  def self.transformedValueClass
    NSString
  end

  def self.allowsReverseTransformation
    false
  end

  def transformedValue(value)
    "#{value.round} px"
  end
end