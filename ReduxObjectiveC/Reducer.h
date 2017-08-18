//
//  Reducer.h
//  ReduxObjectiveC
//
//  Created by SRIKANTH KYATHAM on 17/08/17.
//  Copyright © 2017 SRIKANTH KYATHAM. All rights reserved.
//

#ifndef Reducer_h
#define Reducer_h

#include "Action.h"

@protocol ReducerDelegate
// (state, action)
-(NSDictionary*)reduce:(NSDictionary*)state
   withAction:(Action*) action;
@end

#endif /* Reducer_h */
