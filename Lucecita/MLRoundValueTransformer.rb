#
#  MLRoundValueTransformer.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 9/25/11.
#  Copyright 2013. All rights reserved.
#
class MLRoundValueTransformer < NSValueTransformer
  
  def self.transformedValueClass
    NSString
  end

  def self.allowsReverseTransformation
    false
  end

  def transformedValue(value)
    value.round.to_s
  end
end