#
#  MLPercentageTransformer.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 9/25/11.
#  Copyright 2011 UNAM. All rights reserved.
#
class MLPercentageTransformer < NSValueTransformer

  def self.transformedValueClass
    NSString
  end

  def self.allowsReverseTransformation
    false
  end

  def transformedValue(value)
    "#{(value*100).round} %"
  end
end