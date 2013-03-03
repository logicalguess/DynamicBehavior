#import "ActivityContextWithBlockRoles.h"
#import "ActivityEnum.h"
#import "CyclingProtocol.h"
#import "ActivityRecord.h"
#import "LGBlockRole.h"
#import "ExtensiblePerson.h"


@implementation ActivityContextWithBlockRoles {
    id (^cycle)(ExtensiblePerson *, id);

}
- (id)init {

    cycle = (id)^(ExtensiblePerson *target, id param){
        NSLog(@"Got invocation in the cycle block in context with target: %@ and arg: %@", target, param);
        return [NSString stringWithFormat:@"EXTENSION-%@", param];
    };

    NSMutableDictionary *blocks = [NSMutableDictionary dictionaryWithCapacity:1];
    [blocks setValue:cycle forKey:@"cycle:"];

    ActivityRecord *namedRoles = [ActivityRecord new];
    [namedRoles setObject:[LGBlockRole roleWithProtocol:@protocol(CyclingProtocol) blocks:blocks]
                     forEnum:[ActivityEnum CYCLING]];
    self = [super initWithRoles:namedRoles];

    if (self) {
    }

    return self;
}

- (id)run {
    id<CyclingProtocol> performer = [self performerForRole:[ActivityEnum CYCLING]];
    return [performer cycle:@"FROM-BLOCK-CONTEXT"];
}
@end