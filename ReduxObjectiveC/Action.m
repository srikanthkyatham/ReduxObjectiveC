//
//  Action.m
//  ReduxObjectiveC
//
//  Created by SRIKANTH KYATHAM on 17/08/17.
//  Copyright © 2017 SRIKANTH KYATHAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Action.h"

@interface Action ()
@end

@implementation Action

-(id)initWithData:(NSString*)type
         withParams:(NSDictionary*)params {
  if(self = [super init]) {
    self.type = [[NSString alloc] initWithString:type];
    if (params != nil)
      self.params = [NSDictionary dictionaryWithDictionary:params];
  }
  return self;
}

@end
