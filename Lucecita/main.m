//
//  main.m
//  Lucecita
//
//  Created by Juan Germán Castañeda Echevarría on 7/11/11.
//  Copyright 2011 Monsterlabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
  return macruby_main("rb_main.rb", argc, argv);
}
