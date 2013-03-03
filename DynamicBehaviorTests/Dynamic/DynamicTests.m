#import "DynamicTests.h"
#import "SomeDynamic.h"


@implementation DynamicTests {

}


- (void)testDynamic
{
    SomeDynamic *obj = [SomeDynamic new];

    [obj setValue:@"abc" forKey:@"key1"];

    STAssertEquals([obj valueForKey:@"key1"], @"abc", @"incorrect value");
    STAssertNil([obj valueForKey:@"key2"], @"value of inexistent should be nil");
}

@end