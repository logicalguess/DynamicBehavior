#import "DCITests.h"
#import "ActivityEnum.h"
#import "SomeBlockExtensible.h"
#import "ActivityRecord.h"
#import "ActivityContextWithBlockRoles.h"
#import "SelectorExtensiblePerson.h"
#import "ActivityContextWithClassRoles.h"


@implementation DCITests {

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


- (void)testDCIWithClassRoles {
    ActivityContextWithClassRoles * ctx = [ActivityContextWithClassRoles new];

    ActivityRecord *namedObjects = [ActivityRecord new];
    [namedObjects setObject:[SelectorExtensiblePerson new] forEnum:[ActivityEnum CYCLING]];

    [ctx fillRolesWithObjects:namedObjects];

    id result = [ctx run];
    STAssertTrue([result isEqualToString:@"EXTENSION-FROM-CLASS-CONTEXT"], @"not right result");
}

- (void)testDCIWithBlockRoles {
    ActivityContextWithBlockRoles * ctx = [ActivityContextWithBlockRoles new];

    ActivityRecord *namedObjects = [ActivityRecord new];
    [namedObjects setObject:[SomeBlockExtensible new] forEnum:[ActivityEnum CYCLING]];

    [ctx fillRolesWithObjects:namedObjects];

    id result = [ctx run];
    STAssertTrue([result isEqualToString:@"EXTENSION-FROM-BLOCK-CONTEXT"], @"not right result");
}

@end