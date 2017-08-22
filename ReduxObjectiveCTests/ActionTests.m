//
//  ActionTests.m
//  ReduxObjectiveC
//
//  Created by SRIKANTH KYATHAM on 21/08/17.
//  Copyright © 2017 SRIKANTH KYATHAM. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Action.h"

@interface ParamObject : NSObject
@property (nonatomic, strong) NSString* param;
@end

@implementation ParamObject

-(id)init {
  if (self = [super init]){
    self.param = @"hello";
  }
  return self;
}
@end

@interface ActionTests : XCTestCase

@end

@implementation ActionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAction {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  ParamObject *param = [ParamObject new];
  NSDictionary *params = @{@"key": @"value", @"paramObject": param};
  NSString *type = @"test";
  Action* action = [[Action alloc]initWithData:type withParams:params];
  XCTAssertEqualObjects(type, action.type);
  XCTAssertEqualObjects(params, action.params);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
