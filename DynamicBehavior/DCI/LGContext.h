#import <Foundation/Foundation.h>

@class LGEnumDictionary;
@class WSEnum;


@interface LGContext : NSObject
+ (id)contextWithRoles:(LGEnumDictionary *)namedRolesDictionary;

- (id)initWithRoles:(LGEnumDictionary *)namedRolesDictionary;
- (void)fillRolesWithObjects:(LGEnumDictionary *)namedObjectsDictionary;
- (id)performerForRole:(WSEnum *)roleName;
- (id)run;
@end