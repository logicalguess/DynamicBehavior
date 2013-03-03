#import "CyclingExtension.h"


@implementation CyclingExtension {
    id _target;

}
- (id)initWithTarget:(id)target {
    self = [super init];
    if (self) {
        _target = target;
    }
    return self;
}

- (NSString *)cycle:(id)param {
    NSLog(@"Got invocation in CyclingExtension with target: %@ and arg: %@", _target, param);
    return [NSString stringWithFormat:@"EXTENSION-%@", param];
}

@end