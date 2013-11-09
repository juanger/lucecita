#
#  AppDelegate.rb
#  Lucecita
#
#  Created by Juan Germán Castañeda Echevarría on 7/11/11.
#  Copyright 2011 Monsterlabs. All rights reserved.
#

class AppDelegate
  attr_accessor :lightController
  
  def applicationDidFinishLaunching(a_notification)
    if defined?(KAXTrustedCheckOptionPrompt)
        AXIsProcessTrustedWithOptions({KAXTrustedCheckOptionPrompt: true})
    else
      
      if !AXAPIEnabled()
          # Ask user to enable assistive devices
          alert = NSAlert.alertWithMessageText("Assistive devices", 
                                defaultButton:nil,
                                alternateButton:nil,
                                otherButton:nil,
                                informativeTextWithFormat:"In order to use a global key shortcut you must enable access for assistive devices in the universal access preference pane.\n\nOpen Lucecita after setting it.")
          
          script = NSAppleScript.alloc.initWithSource("tell application \"System Preferences\" to activate\n" +
                                             "tell application \"System Preferences\" to set the current pane to pane id \"com.apple.preference.universalaccess\"\n" +
                                             "tell application \"Lucecita\" to quit")
          script.compileAndReturnError nil
          if (alert.runModal)
            script.executeAndReturnError nil
          end
      end
    end
    
    userDefaultsValuesPath = NSBundle.mainBundle.pathForResource("InitialDefaults",
                                                                 ofType:"plist")
    userDefaultsValuesDict = NSDictionary.dictionaryWithContentsOfFile(userDefaultsValuesPath)
    
    NSUserDefaults.standardUserDefaults.registerDefaults(userDefaultsValuesDict)
  end
  
  def applicationWillTerminate(a_notification)
    lightController.applicationWillTerminate
  end
end

