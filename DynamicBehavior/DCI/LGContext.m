#import "LGContext.h"
#import "LGEnumDictionary.h"
#import "WSEnum.h"
#import "LGRole.h"


@interface LGContext ()
@property(readonly) LGEnumDictionary *roles;
@property(readonly) LGEnumDictionary *performers;

@end

@implementation LGContext
- (id)initWithRoles:(LGEnumDictionary *)namedRolesDictionary {
    self = [super init];
    if (self) {
        _roles = namedRolesDictionary;
        _performers = [[LGEnumDictionary alloc] initWithEnumClass:[namedRolesDictionary enumClass]];
    }
    return self;
}

+ (id)contextWithRoles:(LGEnumDictionary *)namedRolesDictionary {
    return [[LGContext alloc] initWithRoles:namedRolesDictionary];
}

- (void)fillRolesWithObjects:(LGEnumDictionary *)namedObjectsDictionary {
    Class enumClass = [namedObjectsDictionary enumClass];
    if (![enumClass isEqual:[[self roles] enumClass]]) {
        @throw [[NSException alloc] initWithName:@"Invalid enum class" reason:@"The role names don't match" userInfo:nil];
    }
    NSArray *roles = [enumClass enumValues];
    for (WSEnum *roleName in roles)  {
        id obj = [namedObjectsDictionary objectForEnum:roleName];
        if (obj && obj != [NSNull null]) {
            [self fillRole:roleName withObject:obj];
        }
    }
}

- (void)fillRole:(WSEnum *)roleName withObject:(id)obj {
    id performer = [(id<LGRole>) [[self roles] objectForEnum:roleName] enableOnObject:obj];
    [[self performers] setObject:performer forEnum:roleName];
}

- (id)performerForRole:(WSEnum *)roleName {
    return [[self performers] objectForEnum:roleName];
}

- (id)run {
    @throw [[NSException alloc] initWithName:@"" reason:@"This method needs to be overriden" userInfo:nil];

}


@end