#import <Foundation/Foundation.h>

@class LGEnumDictionary;
@class WSEnum;


@interface LGContext : NSObject
- (id)initWithRoles:(LGEnumDictionary *)namedRolesDictionary;
+ (id)contextWithRoles:(LGEnumDictionary *)namedRolesDictionary;
- (void)fillRolesWithObjects:(LGEnumDictionary *)namedObjectsDictionary;
- (id)performerForRole:(WSEnum *)roleName;
- (id)run;
@end