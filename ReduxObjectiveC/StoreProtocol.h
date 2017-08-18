//
//  StoreProtocol.h
//  ReduxObjectiveC
//
//  Created by SRIKANTH KYATHAM on 18/08/17.
//  Copyright © 2017 SRIKANTH KYATHAM. All rights reserved.
//

#ifndef StoreProtocol_h
#define StoreProtocol_h

#include "Action.h"
#include "Reducer.h"

@protocol StoreDelegate

-(void)call:(Action*)action
 withObject:(id<ReducerDelegate>)actionHandler
 withParams:(NSDictionary*)params;

@end

#endif /* StoreProtocol_h */
