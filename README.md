# ReduxObjectiveC
Redux implementation in Objective C

## Usage
1. Create store
2. Add reducers
3. Dispatch actions
~~~~

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


@interface ReduxTest
@property (nonatomic, strong) Store *store;
@end

@implementation ReduxTest

-(id)init {
  if (self = [super init]) {
    self.store = [Store new];
    self.reducer = [[TestReducer alloc] initWithStore:self.store];
  }
}

-(void)test {
  Action* action = [[Action alloc]initWithData:@"INCREMENT" withParams:@{}];
  [self.store dispatch:action];
}

@end

~~~~

## Test


