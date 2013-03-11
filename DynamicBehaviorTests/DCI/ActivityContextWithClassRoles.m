#import "ActivityContextWithClassRoles.h"
#import "ActivityEnum.h"
#import "ActivityRecord.h"
#import "LGClassRole.h"
#import "CyclingProtocol.h"
#import "CyclingExtension.h"


@implementation ActivityContextWithClassRoles {

}
- (id)init {
    ActivityRecord *namedRoles = [ActivityRecord new];
    [namedRoles setObject:[LGClassRole roleWithProtocol:@protocol(CyclingProtocol) implClass:[CyclingExtension class]]
                     forEnum:[ActivityEnum CYCLING]];
    self = [super initWithRoles:namedRoles];

    if (self) {
    }

    return self;
}

- (id)run {
    id<CyclingProtocol> performer = [self performerForRole:[ActivityEnum CYCLING]];
    return [performer cycle:@"FROM-CLASS-CONTEXT"];
}
@end