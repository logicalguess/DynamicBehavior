#import <Foundation/Foundation.h>
#import "ObjectWrapper.h"
#import "CyclingProtocol.h"


@interface CyclingExtension : NSObject <ObjectWrapper, CyclingProtocol>

@end