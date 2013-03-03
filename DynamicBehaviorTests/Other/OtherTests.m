#import "OtherTests.h"
#import "Something.h"


@implementation OtherTests {

}

- (void)test {
    Something *s1 = [Something new];
    [s1 changeLocalStatic];
    [s1 dispatchOnce];
    NSLog(@"Associated of %@: %@", s1, [s1 associated]);


    Something *s2 = [Something new];
    [s2 changeLocalStatic];
    [s2 dispatchOnce];
    NSLog(@"Associated of %@: %@", s2, [s2 associated]);
}

@end