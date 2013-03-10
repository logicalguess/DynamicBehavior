#import <Foundation/Foundation.h>
#import "LGEnumDictionary.h"

@class ActivityEnum;

@interface ActivityRecord : LGEnumDictionary
- (id)objectForEnum:(ActivityEnum *)key;
- (void)setObject:(id)value forEnum:(ActivityEnum *)key;
@end