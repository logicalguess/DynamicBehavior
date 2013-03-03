#import "BlockExtensionTests.h"
#import "SomeBlockExtensible.h"


@implementation BlockExtensionTests {

}

- (void)testBlockExtension
{
    SomeBlockExtensible *obj = [SomeBlockExtensible new];

    id (^test)(id , id) = (id)^(id target, id param){
        NSLog(@"Got invocation in the test block with target: %@ and arg: %@", target, param);
        NSString *result = [target performSelector:@selector(test1:) withObject:@"WITH-SELECTOR"];
        STAssertTrue([result isEqualToString:@"TEST1-WITH-SELECTOR"], @"not right result");
        return [NSString stringWithFormat:@"TEST-%@", param];
    };
    [obj extendWithBlock:test forSelector:@selector(test:)];

    id (^test1)(id , id) = (id)^(id target, id param){
        NSLog(@"Got invocation in the test1 block with target: %@ and arg: %@", target, param);
        return [NSString stringWithFormat:@"TEST1-%@", param];
    };
    [obj extendWithBlock:test1 forSelector:@selector(test1:)];


    NSString *result = [obj performSelector:@selector(test:) withObject:@"WITH-SELECTOR"];
    STAssertTrue([result isEqualToString:@"TEST-WITH-SELECTOR"], @"not right result");
}

@end