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
  NSMutableDictionary *funks = (NSMutableDictionary*)self.storeDictionary[@"funks"];
  // run/call all the funks
  for (NSString *key in funks) {
    // call the funks
    NSMutableDictionary *funk = (NSMutableDictionary*)funks[key];
    Action* action = funk[@"action"];
    NSDictionary* params = funk[@"params"];
    id<StoreDelegate> actionHandler = (id<StoreDelegate>)funk[@"actionHandler"];

    [actionHandler invokeAction:action withParams:params];
    // some protocol adhering delegate

  }
  // remove the object funks
  [funks removeAllObjects];
  [self.storeDictionary setObject:funks forKey:@"funks"];
  self.funkIndex = 0;
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
  [funk setObject:params forKey:@"params"];
  [funk setObject:action forKey:@"action"];
  [funk setObject:actionHandler forKey:@"actionHandler"];
  [funks setObject:funk forKey:[@(self.funkIndex) stringValue]];
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
}


@end
