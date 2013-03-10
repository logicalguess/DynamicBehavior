#import "EnumDictionaryTests.h"
#import "ActivityEnum.h"
#import "ActivityRecord.h"
#import "NSObject+LGEnumDictionary.h"

NSString  * kACTIVITY_CYCLING;

@implementation EnumDictionaryTests {

}

+ (void) load {
    static bool done = FALSE;
    if(!done){
        kACTIVITY_CYCLING = [ActivityEnum CYCLING].name;
        done = TRUE;
    }
}

- (void)setUp
{
    [super setUp];

    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (void)testEnumDictionaryCategory
{
    NSObject *obj = [NSObject new];
    [obj setEnumClass:[ActivityEnum class]];

    [obj setObject:@"abc" forEnum:[ActivityEnum WALKING]];
    STAssertEquals([obj objectForEnum:ActivityEnum.WALKING], @"abc", @"incorrect value");

    [obj clearObjects];
    STAssertEqualObjects([obj objectForEnum:ActivityEnum.CYCLING], [NSNull null], @"incorrect value");
}

- (void)testActivityRecord
{
    ActivityRecord *rec = [ActivityRecord new];


    STAssertTrue([[ActivityRecord class] conformsToProtocol:@protocol(LGEnumDictionary)], @"should conform to protocol");

    [rec setObject:@"abc" forEnum:[ActivityEnum WALKING]];
    STAssertEquals([rec valueForKey:@"WALKING"], @"abc", @"incorrect value");

    [rec setValue:@"def" forKey:@"CYCLING"];
    STAssertEquals([rec valueForKey:kACTIVITY_CYCLING], @"def", @"incorrect value");
    STAssertEquals([rec objectForEnum:ActivityEnum.CYCLING], @"def", @"incorrect value");

    [rec clearObjects];
    STAssertEqualObjects([rec objectForEnum:ActivityEnum.CYCLING], [NSNull null], @"incorrect value");
}

- (void)testEnumDictionary
{
    LGEnumDictionary *rec = [LGEnumDictionary dictionaryWithEnumClass:[ActivityEnum class]];


    STAssertTrue([[ActivityRecord class] conformsToProtocol:@protocol(LGEnumDictionary)], @"should conform to protocol");

    [rec setObject:@"abc" forEnum:[ActivityEnum WALKING]];
    STAssertEquals([rec valueForKey:@"WALKING"], @"abc", @"incorrect value");

    [rec setValue:@"def" forKey:@"CYCLING"];
    STAssertEquals([rec valueForKey:kACTIVITY_CYCLING], @"def", @"incorrect value");
    STAssertEquals([rec objectForEnum:ActivityEnum.CYCLING], @"def", @"incorrect value");

    [rec clearObjects];
    STAssertEqualObjects([rec objectForEnum:ActivityEnum.CYCLING], [NSNull null], @"incorrect value");
}

@end