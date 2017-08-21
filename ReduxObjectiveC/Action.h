//
//  Action.h
//  ReduxObjectiveC
//
//  Created by SRIKANTH KYATHAM on 17/08/17.
//  Copyright © 2017 SRIKANTH KYATHAM. All rights reserved.
//

#ifndef Action_h
#define Action_h

#import <Foundation/NSObject.h>

// type of
// type: string, NSObject* data
// ownership of data ??
@interface Action : NSObject

@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *type;


- (id)initWithData:(NSString*)type
          withParams:(NSDictionary*)params;

@end

#endif /* Action_h */
