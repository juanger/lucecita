#
#  Kernel+Localization.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/13/11.
#  Copyright 2011 MonsterLabs. All rights reserved.
#
module Kernel
  private
  
  def NSLocalizedString(key, value="")
    NSBundle.mainBundle.localizedStringForKey(key, value:value, table:nil)
  end
end

