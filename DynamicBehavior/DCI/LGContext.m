#import "LGContext.h"
#import "LGEnumDictionary.h"
#import "WSEnum.h"
#import "LGRole.h"


@interface LGContext ()
- (void)fillRole:(WSEnum *)roleName withObject:(id)obj;

@end

@implementation LGContext {
    LGEnumDictionary *_roles;
    LGEnumDictionary *_performers;
}
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
    if (![enumClass isEqual:[_roles enumClass]]) {
        @throw [[NSException alloc] initWithName:@"Invalid enum class" reason:@"The role names don't match" userInfo:nil];
    }
    NSArray *roles = [enumClass enumValues];
    for (WSEnum *roleName in roles)  {
        id obj = [namedObjectsDictionary objectForEnum:roleName];
        if (obj && obj != [NSNull null]) {
            id performer = [(id<LGRole>) [_roles objectForEnum:roleName] enableOnObject:obj];
            [_performers setObject:performer forEnum:roleName];
        }
    }
}

- (void)fillRole:(WSEnum *)roleName withObject:(id)obj {
    [_performers setObject:[(id<LGRole>)[_roles objectForEnum:roleName] enableOnObject:obj] forEnum:roleName];
}

- (id)performerForRole:(WSEnum *)roleName {
    return [_performers objectForEnum:roleName];
}

- (id)run {
    @throw [[NSException alloc] initWithName:@"" reason:@"This method needs to be overriden" userInfo:nil];

}


@end