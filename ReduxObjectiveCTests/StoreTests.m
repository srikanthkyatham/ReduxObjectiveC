//
//  Store.m
//  ReduxObjectiveC
//
//  Created by SRIKANTH KYATHAM on 17/08/17.
//  Copyright © 2017 SRIKANTH KYATHAM. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Store.h"
#import "Reducer.h"
#import "Action.h"

@interface TestReducer : NSObject <ReducerDelegate, StoreDelegate>
@property (nonatomic, assign) BOOL test;
@property (nonatomic, weak) Store *store;
@end

@implementation TestReducer

-(id)initWithStore:(Store*)store {
  if (self = [super init]) {
    self.store = store;
  }
  return self;
}

// timer cb
- (void)timerFireMethod:(NSTimer *)timer {
  Action* action = [[Action alloc]initWithData:@"INCREMENT" withParams:@{}];
  [self.store dispatch:action];
}

-(void)invokeAction:(Action*)action
         withParams:(NSDictionary*)params
{
  // run a timer
  if ([action.type isEqualToString:@"INCREMENT_ASYNC"]) {
    // timer with call back call dispatch
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:nil
                                    repeats:NO];
  }
  
}

-(NSDictionary*)reduce:(NSDictionary*)state
   withAction:(Action*) action {
  
  NSMutableDictionary *newState = [[NSMutableDictionary alloc] init];
  for (NSString* key in state) {
    newState[key] = state[key];
  }
  
  if ([action.type  isEqual: @"INCREMENT"]) {
    NSNumber *num = newState[@"count"];
    NSNumber *newNum = [NSNumber numberWithInt:[num intValue] + 1];
    newState[@"count"] = newNum;
  } else if ([action.type isEqual:@"INCREMENT_ASYNC"]) {
    [self.store call:action withObject:self withParams:@{}];
  }
  return newState;
}

@end



@interface StoreTests : XCTestCase
@property (nonatomic, strong) Store *store;
@property (nonatomic, strong) NSDictionary *state;
@property (nonatomic, strong) TestReducer *reducer;
@property (nonatomic, strong) NSString *reducerName;
@end



@implementation StoreTests



- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.store = [[Store alloc] init];
    self.state = @{
                    @"count" : @42,
                  };
    self.reducer = [[TestReducer alloc] initWithStore:self.store];
    self.reducerName = @"reducer";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
  self.store = nil;
}




- (NSDictionary*)reducerStateFromStore
{
  NSDictionary *storeDictionary = [self.store getStore];
  NSDictionary *stateDictionary = storeDictionary[self.reducerName];
  NSDictionary *actualState = stateDictionary[@"state"];
  return actualState;
}

- (NSDictionary*)funksStateFromStore
{
  NSDictionary *storeDictionary = [self.store getStore];
  return storeDictionary[@"funks"];
}

- (void)waitForTimer:(NSUInteger)interval
{
  XCTestExpectation *expectation = [self expectationWithDescription:@"waitForTimer"];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [expectation fulfill];
  });
  [self waitForExpectationsWithTimeout:interval handler:nil];
}


- (void) testsetReducer {
  
  [self.store setReducer:self.reducerName withState:self.state withReducer:self.reducer];
  NSDictionary *actualState = [self reducerStateFromStore];
  XCTAssertEqual(self.state, actualState);
  // assert
}

- (void)testdispatch {
  // set the reducer
  [self.store setReducer:self.reducerName withState:self.state withReducer:self.reducer];
  // dispatch action
  Action* action = [[Action alloc]initWithData:@"INCREMENT" withParams:@{}];
  [self.store dispatch:action];
  
  // check the changed state
  NSDictionary* expectedState = @{
                 @"count" : @43,
                 };
  NSDictionary *actualState = [self reducerStateFromStore];
  XCTAssertEqualObjects(expectedState, actualState);
}

- (void) testcall {
  // setReducer
   [self.store setReducer:self.reducerName withState:self.state withReducer:self.reducer];
  // dispatch
  // call in the reducer
  // updated state
  // validate funks how not possible since executed in the same thing sync
  // instead check the invokeCall things
  [self.store setReducer:self.reducerName withState:self.state withReducer:self.reducer];
  // dispatch action
  Action* action = [[Action alloc]initWithData:@"INCREMENT_ASYNC" withParams:@{}];
  [self.store dispatch:action];
  [self waitForTimer:3];
  
  // check the changed state
  NSDictionary* expectedState = @{
                                  @"count" : @43,
                                  };
  NSDictionary *actualState = [self reducerStateFromStore];
  XCTAssertEqualObjects(expectedState, actualState);
  XCTAssertEqualObjects(@{}, [self funksStateFromStore]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
