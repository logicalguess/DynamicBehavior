### Enumerations

Using WSEnum. Each enum values is defined by a class, so it can provide behavior on top of a "constant" value.

Sample usage:

ActivityEnum.h
<pre><code>
@interface ActivityEnum : WSEnum
+ (ActivityEnum*)WALKING;
+ (ActivityEnum*)RUNNING;
+ (ActivityEnum*)CYCLING; 
@end
</code></pre>
ActivityEnum.m
<pre><code>
@interface RunningActivityEnum : ActivityEnum @end
@interface WalkingActivityEnum : ActivityEnum @end
@interface CyclingActivityEnum : ActivityEnum @end

@implementation ActivityEnum
WS_ENUM(CyclingActivityEnum, CYCLING)
WS_ENUM(RunningActivityEnum, RUNNING)
WS_ENUM(WalkingActivityEnum, WALKING)
@end

@implementation CyclingActivityEnum
@end

@implementation WalkingActivityEnum
@end

@implementation RunningActivityEnum
@end
</code></pre>

### LGEnumDictionary

An enum dictionary behaves like a dictionary whose keys are restricted to the values of an enumeration. The implementation
is actually backed by an array and it is KVC compliant.

It provides a compromise between a strongly typed object (an instance of a class) and an NSDictionary. The enumeration
expresses the structure of data, and it can be used to do that in a consistent way across an application. For example,
a model and view can use the same enumeration to epxress the dependency on receieving and the promise to provide data
that is structured in a certain way.

Sample usage:

ActivityRecord.h
<pre><code>
@class ActivityEnum;

@interface ActivityRecord : LGEnumDictionary
- (id)objectForEnum:(ActivityEnum *)key;
- (void)setObject:(id)value forEnum:(ActivityEnum *)key;
@end
</code></pre>
ActivityRecord.m
<pre><code>@implementation ActivityRecord {

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
</code></pre>

