#import "ActivityDecorator.h"


@implementation ActivityDecorator {

}

- (void)before_name {
    NSLog(@"Before interceptor called");
}

- (void)after_name {
    NSLog(@"After interceptor called");
}
@end