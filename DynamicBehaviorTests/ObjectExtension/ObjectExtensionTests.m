#import "ObjectExtensionTests.h"
#import "ActivityEnum.h"
#import "LGDecorator.h"
#import "ActivityDecorator.h"
#import "CyclingProtocol.h"
#import "CyclingExtension.h"
#import "LGObjectExtender.h"
#import "SelectorExtensiblePerson.h"
#import "ExtensiblePerson.h"

NSString  *const kACTIVITY_WALKING = @"WALKING";

@implementation ObjectExtensionTests {

}

- (void)testDecorator
{
    ActivityEnum *activity = [LGDecorator decorateInstance:ActivityEnum.WALKING withClass:[ActivityDecorator class]];
    [activity name];
}

- (void)testExtensible
{
    ExtensiblePerson *obj = [ExtensiblePerson new];
    [obj extendWithObject:ActivityEnum.WALKING];

    STAssertTrue([obj respondsToSelector:@selector(name)], @"should respond to protocol");
    STAssertEquals([obj performSelector:@selector(name)], @"WALKING", @"incorrect value");
    STAssertEquals([(ActivityEnum*)obj name], kACTIVITY_WALKING, @"incorrect value");

}

- (void)testObjectExtension
{
    SelectorExtensiblePerson *obj = [SelectorExtensiblePerson new];

    //[obj extendWithClass:[CyclingExtension class] forSelector:@selector(test:)];
    //[obj extendWithClass:[CyclingExtension class] forSelectorsWithPrefix:@"test"];
    //[obj extendWithClass:[CyclingExtension class] forProtocol:@protocol(CyclingProtocol)];

    [[LGObjectExtender sharedInstance] extendTarget:obj withClass:[CyclingExtension class]
                                        forProtocol:@protocol(CyclingProtocol)];

    NSString *result = [obj performSelector:@selector(cycle:) withObject:@"FROM-CYCLE-SELECTOR"];
    STAssertTrue([result isEqualToString:@"EXTENSION-FROM-CYCLE-SELECTOR"], @"not right result");

    result = [(id<CyclingProtocol>)obj cycle:@"FROM-CYCLE-METHOD"];
    STAssertTrue([result isEqualToString:@"EXTENSION-FROM-CYCLE-METHOD"], @"not right result");
}

- (void)testSelectorExtension
{
    SelectorExtensiblePerson *obj = [SelectorExtensiblePerson new];

    //[obj extendWithClass:[CyclingExtension class] forSelector:@selector(test:)];
    //[obj extendWithClass:[CyclingExtension class] forSelectorsWithPrefix:@"test"];
    //[obj extendWithClass:[CyclingExtension class] forProtocol:@protocol(CyclingProtocol)];

    [[LGObjectExtender sharedInstance] extendTarget:obj withObject:[[CyclingExtension alloc] initWithTarget:obj]
                                        forSelector:@selector(cycle:)];

    NSString *result = [obj performSelector:@selector(cycle:) withObject:@"FROM-CYCLE-SELECTOR"];
    STAssertTrue([result isEqualToString:@"EXTENSION-FROM-CYCLE-SELECTOR"], @"not right result");

    result = [(id<CyclingProtocol>)obj cycle:@"FROM-CYCLE-METHOD"];
    STAssertTrue([result isEqualToString:@"EXTENSION-FROM-CYCLE-METHOD"], @"not right result");
}


@end