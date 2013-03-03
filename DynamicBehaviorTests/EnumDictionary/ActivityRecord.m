#import "ActivityRecord.h"
#import "ActivityEnum.h"


@implementation ActivityRecord {

}
- (id)init {
    return [super initWithEnumClass:[ActivityEnum class]];
}

- (id)objectForEnum:(ActivityEnum *)key {
    return [super objectForEnum:key];
}

- (void)setObject:(id)value forEnum:(ActivityEnum *)key {
    [super setObject:value forEnum:key];
}

@end