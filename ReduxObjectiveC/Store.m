//
//  Store.m
//  ReduxObjectiveC
//
//  Created by SRIKANTH KYATHAM on 17/08/17.
//  Copyright © 2017 SRIKANTH KYATHAM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSObject.h>

#import "Store.h"
#import "Action.h"
#import "Reducer.h"

@interface Store ()
@property (nonatomic, strong) NSMutableDictionary *storeDictionary;
@property (nonatomic, assign) int funkIndex;
@property (nonatomic, strong) NSTimer *funksTimer;

// variables

@end

@implementation Store
// dictionay

-(id)init {
  if (self = [super init]) {
    self.funkIndex = 0;
    self.storeDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *funks = [[NSMutableDictionary alloc] init];
    [self.storeDictionary setObject:funks forKey:@"funks"];
  }
  return self;
}

-(void)runFunks:(NSTimer*)timer {
  NSMutableDictionary *funks = (NSMutableDictionary*)self.storeDictionary[@"funks"];
  // run/call all the funks
  NSArray<NSString*> *keys = [funks allKeys];
  for (NSString *key in keys) {
    // call the funks
    NSMutableDictionary *funk = (NSMutableDictionary*)funks[key];
    Action* action = funk[@"action"];
    NSDictionary* params = funk[@"params"];
    id<StoreDelegate> actionHandler = (id<StoreDelegate>)funk[@"actionHandler"];

    [funks removeObjectForKey:key];
    [actionHandler invokeAction:action withParams:params];
  }
  // remove the object funks
  [funks removeAllObjects];
  [self.storeDictionary setObject:funks forKey:@"funks"];
  self.funkIndex = 0;
  [self.funksTimer invalidate];
  self.funksTimer = nil;
}

// dispatch
-(void)dispatch:(Action*)action {
  // run through all the reducers
  // run through all the funks
  for (NSString *key in self.storeDictionary) {
    NSMutableDictionary *stateDictionary = (NSMutableDictionary*)self.storeDictionary[key];
    NSDictionary* state = (NSDictionary*)stateDictionary[@"state"];
    id<ReducerDelegate> reducer = (id<ReducerDelegate>)stateDictionary[@"reducer"];
    NSDictionary* newState = [reducer reduce:state withAction:action];
    stateDictionary[@"state"] = newState;
  }

  // run funks in next tick
  if (![self.funksTimer isValid]) {
    self.funksTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(runFunks:)
                                                userInfo:nil
                                                 repeats:NO];
  }
}

// call
// store the actions in the funks
// delegate function as parameter
-(void)call:(Action*)action
  withDelegate:(id<StoreDelegate>)actionHandler
  withParams:(NSDictionary*)params  {
  // store in the dictionary
  NSMutableDictionary *funks = (NSMutableDictionary*)self.storeDictionary[@"funks"];
  NSMutableDictionary *funk = [[NSMutableDictionary alloc] init];
  funk[@"params"] = params;
  //[funk setObject:params forKey:@"params"];
  [funk setObject:action forKey:@"action"];
  [funk setObject:actionHandler forKey:@"actionHandler"];
  [funks setObject:funk forKey:[@(self.funkIndex) stringValue]];
  self.funkIndex++;
}

// set reducer
-(void)setReducer:(NSString*)name withState:(NSDictionary*)state
      withReducer:(id<ReducerDelegate>)reducer{
  NSMutableDictionary *stateDictionary = [[NSMutableDictionary alloc] init];
  [stateDictionary setObject:state forKey:@"state"];
  [stateDictionary setObject:reducer forKey:@"reducer"];
  [self.storeDictionary setObject:stateDictionary forKey:name];
}

-(NSDictionary*)getStore {
  return self.storeDictionary;
}

-(void)dealloc {
  // remove all the elements from dictionary and delete
  [self.storeDictionary removeAllObjects];
  [self.funksTimer invalidate];
  self.funksTimer = nil;
}


@end
