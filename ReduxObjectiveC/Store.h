//
//  Store.h
//  ReduxObjectiveC
//
//  Created by SRIKANTH KYATHAM on 17/08/17.
//  Copyright © 2017 SRIKANTH KYATHAM. All rights reserved.
//

#ifndef Store_h
#define Store_h


#include "Action.h"
#include "Reducer.h"

@protocol StoreDelegate

-(NSDictionary*)getInitialState;
-(void)invokeAction:(Action*)action
 withParams:(NSDictionary*)params;

@end

@interface Store : NSObject
-(void)dispatch:(Action*)action;
-(void)call:(Action*)action
  withObject:(id<StoreDelegate>)actionHandler
  withParams:(NSDictionary*)params;

-(void)setReducer:(NSString*)name withState:(NSDictionary*)state
      withReducer:(id<ReducerDelegate>)reducer;

-(NSDictionary*)getStore;

@end

#endif /* Store_h */
