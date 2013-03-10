# Motivation

In complex, large-scale projects it is essential to rely on generic code and frameworks to ensure reuse and development speed.
The single inheritance model is a big obstacle from this point of view, that is why languages like Ruby and Scala
are using mixins or traits to solve this problem. This project is an attempt to bring the same kind of functionality to
Objective-C.

# Dynamic Properties

In order to automate the data flow in a non-trivial application we want to avoid relying on properties, and instead we
want a mechanism that ensures we provide and consume **ALL** and **ONLY** the pieces of data that belong in a certain
**context**.

## Enumerations

Using WSEnum. Each enum values is defined by a class, so it can provide behavior on top of a "constant" value.

### Sample usage

ActivityEnum.h

    @interface ActivityEnum : WSEnum
    + (ActivityEnum*)WALKING;
    + (ActivityEnum*)RUNNING;
    + (ActivityEnum*)CYCLING; 
    @end

ActivityEnum.m

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

## The LGEnumDictionary class

An enum dictionary behaves like a dictionary whose keys are restricted to the values of an enumeration. The implementation
is actually backed by an array and it is KVC compliant.

It provides a compromise between a strongly typed object (an instance of a class) and an <code>NSDictionary</code>. The enumeration
expresses the structure of data, and it can be used to do that in a consistent way across an application. For example,
a model and view can use the same enumeration to express the dependency on receiving and the promise to provide data
that is structured in a certain way.

### Protocol

The following protocol describes the interface of an <code>LGEnumDictionary</code>:

    @protocol LGEnumDictionary <NSObject>
    - (id)objectForEnum:(WSEnum *)key;
    - (void)setObject:(id)value forEnum:(WSEnum *)key;
    - (void)clearObjects;
    @end

### Sample usage

We can create an instance of <code>LGEnumDictionary</code> by using the factory method <code>dictionaryWithEnumClass</code>:

    LGEnumDictionary *rec = [LGEnumDictionary dictionaryWithEnumClass:[ActivityEnum class]];

    STAssertTrue([[ActivityRecord class] conformsToProtocol:@protocol(LGEnumDictionary)], @"should conform to protocol");

    [rec setObject:@"abc" forEnum:[ActivityEnum WALKING]];
    STAssertEquals([rec valueForKey:@"WALKING"], @"abc", @"incorrect value");

    [rec setValue:@"def" forKey:@"CYCLING"];
    STAssertEquals([rec valueForKey:@"CYCLING"], @"def", @"incorrect value");
    STAssertEquals([rec objectForEnum:ActivityEnum.CYCLING], @"def", @"incorrect value");

    [rec clearObjects];

Or we can create a dedicated subclass if it is going to be used a lot in a project and/or if we want 
more help from the compiler.

ActivityRecord.h

    @class ActivityEnum;
    
    @interface ActivityRecord : LGEnumDictionary
    - (id)objectForEnum:(ActivityEnum *)key;
    - (void)setObject:(id)value forEnum:(ActivityEnum *)key;
    @end

ActivityRecord.m

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
    
## The LGEnumDictionary category

Adding this category to a class makes its instances behave like an enum dictionary. 
As an example we added the category to NSObject (in general this is a bad idea), 
and then we can write code like this:
    
    NSObject *obj = [NSObject new];
    [obj setEnumClass:[ActivityEnum class]];

    [obj setObject:@"abc" forEnum:[ActivityEnum WALKING]];
    STAssertEquals([obj objectForEnum:ActivityEnum.WALKING], @"abc", @"incorrect value");
    
    [obj clearObjects];

## The LGDynamic class and category

The LGDynamic class makes subclasses behave like a dictionary that will accept any NSString key in a KVC compliant way
(by handling undefined keys). It does not use instance variables, so it can be used as a category 
(by copying and pasting or by defining a macro). You guessed, it uses associative references...

### Sample usage
    SomeDynamic *obj = [SomeDynamic new];

    [obj setValue:@"abc" forKey:@"key1"];

    STAssertEquals([obj valueForKey:@"key1"], @"abc", @"incorrect value");
    STAssertNil([obj valueForKey:@"key2"], @"value of inexistent should be nil");

All the class <code>SomeDynamic</code> has to do is extend <code>LGDynamic</code> 

SomeDynamic.h  
    
    @interface SomeDynamic : LGDynamic
    @end

SomeDynamic.m  
   
    @implementation SomeDynamic 
    @end

# Instance Enhancement and Behavior Injection

Objective-C allows the addition and modification of methods, and there is definitely a place for that, 
but what we are more interested in the runtime enhancement of object instances in a context dependent manner. 

The most common examples of such enhacements are wrapper patterns (Proxy, Decorator, Adapter, Facade) found in
virtually all programming languages. Arguably, adding a level of indirection to raise the level of abstraction has been
the main engine of progress in computer science, and it is also how large-scale projects remain maintainable (think IOC 
containers).

In this project we are using Objective-C's support for message-forwarding to implement instance 
decoration/proxying/adapting.

## The LGDecorator class

This class helps decorate some of the methods of a particular instance, by invoking a *before* and/or *after* method.
Here is its interface:

    @interface LGDecorator : NSObject
    +(id)decorateInstance:(id)target withClass:(Class)decoratorClass;
    +(id)decorateInstance:(id)target with:(id)decorator;
    @end

The decorated instance is a proxy for the real (target) instance.
### Sample Usage

Assume we want to decorate the <code>name</code> method of the <code>ActivityEnum</code> class so we log something 
before and after it is invoked. Then we can implement the *before_<method>* and/or *after_<method>* methods in a class, let's call it
<code>ActivityDecorator</code>.

ActivityDecorator.h

    @interface ActivityDecorator : NSObject
    - (void)before_name;
    - (void)after_name;
    @end

ActivityDecorator.m

    @implementation ActivityDecorator
    - (void)before_name {
        NSLog(@"Before interceptor called");
    }
    
    - (void)after_name {
        NSLog(@"After interceptor called");
    }
    @end

Then we can decorate an instance of <code>ActivityEnum</code>:

    ActivityEnum *activity = [LGDecorator decorateInstance:ActivityEnum.WALKING withClass:[ActivityDecorator class]];
    [activity name];

The output will show that the method was indded decorated:

    2013-03-10 13:52:05.289 otest[3185:707] Before interceptor called
    2013-03-10 13:52:05.290 otest[3185:707] After interceptor called

## The LGExtensible Class and Category

This class allows to "replace" or "add" methods to object instances by specifying another object instance which will 
respond to the "replaced" or "added" methods. 

    @protocol LGExtensible <NSObject>
    - (void)extendWithObject:(id)obj;
    @end
    
    @interface LGExtensible : NSObject <LGExtensible>
    @end
    
Unlike <code>LGDecorator</code>, extending an <code>LGExtensible</code> instance will not create a proxy for the real one.

The class is written in such a way that it can be used as a cateogory (by copy and paste or by defining a macro).

### Sample Usage

Assume we have a class inheriting from <code>LGExtensible</code>:

ExtensiblePerson.h

    @interface ExtensiblePerson : LGExtensible
    @end
    
ExtensiblePerson.m

    @implementation ExtensiblePerson  
    @end
    
Then we can add a <code>name</code> method to an instance of it, coming from an <code>ActivityEnum</code> implementation:

    ExtensiblePerson *obj = [ExtensiblePerson new];
    [obj extendWithObject:ActivityEnum.WALKING];

    STAssertTrue([obj respondsToSelector:@selector(name)], @"should respond to protocol");
    STAssertEquals([obj performSelector:@selector(name)], @"WALKING", @"incorrect value");
    STAssertEquals([(ActivityEnum*)obj name], @"WALKING", @"incorrect value");

## The LGSelectorExtensible Class and Category

Similar to <code>LGExtensible</code> but it allows specifying different objects for different "replaced" or "added" 
selectors. Here are the protocol and interface:

    @protocol LGSelectorExtensible <NSObject>
    - (void)extendWithObject:(id)obj forSelector:(SEL)sel;
    @end
    
    @interface LGSelectorExtensible : NSObject <LGSelectorExtensible>
    @end

## The LGBlockExtensible Class and Category

Similar to <code>LGExtensible</code> but it allows specifying different blocks for different "replaced" or "added" 
selectors. Here are the protocol and interface:

    typedef id (^extension_block_t)(id target, id param);
    
    @protocol LGBlockExtensible <NSObject>
    - (void)extendWithBlock:(extension_block_t)block forSelector:(SEL)sel;
    @end
    
    @interface LGBlockExtensible : NSObject <LGBlockExtensible>
    @end
    
We are making the important simplifying assumption (requirement) that the selectors handled by blocks take at most 
one parameter. The block will receive the target object as the first parameter, and the selector's single parameter as
the second. 

## The LGObjectExtender Singleton Helper

This is a utility class that encapsulates the usage of the extension methods presented above.

    @interface LGObjectExtender : NSObject
    + (id)sharedInstance;
    
    - (id)extendTarget:(id)target withObject:(id)obj forSelector:(SEL)sel;
    - (id)extendTarget:(id)target withBlock:(extension_block_t)block forSelector:(SEL)sel;
    - (id)extendTarget:(id)target withClass:(Class)cls forProtocol:(Protocol *)protocol;
    - (id)extendTarget:(id)target WithClass:(Class)cls forSelectorsWithPrefix:(NSString *)prefix;
    
    @end

## Sample Usage

It is always a good idea to define a protocol for the desired extension:

    @protocol CyclingProtocol <NSObject>
    - (NSString *)cycle:(id)param;
    @end

Then write the extension class interface:

    @interface CyclingExtension : NSObject <ObjectWrapper, CyclingProtocol>
    
    @end
    
And implementation:

    @implementation CyclingExtension {
        id _target;
    
    }
    - (id)initWithTarget:(id)target {
        self = [super init];
        if (self) {
            _target = target;
        }
        return self;
    }
    
    - (NSString *)cycle:(id)param {
        NSLog(@"Got invocation in CyclingExtension with target: %@ and arg: %@", _target, param);
        return [NSString stringWithFormat:@"EXTENSION-%@", param];
    }
    
    @end
    
Then we can use <code>LGObjectExtender</code> to enhance/extend an instance: 

    SelectorExtensiblePerson *obj = [SelectorExtensiblePerson new];
    [[LGObjectExtender sharedInstance] extendTarget:obj withClass:[CyclingExtension class]
                                        forProtocol:@protocol(CyclingProtocol)];

    NSString *result = [obj performSelector:@selector(cycle:) withObject:@"FROM-CYCLE-SELECTOR"];
    STAssertTrue([result isEqualToString:@"EXTENSION-FROM-CYCLE-SELECTOR"], @"not right result");

    result = [(id<CyclingProtocol>)obj cycle:@"FROM-CYCLE-METHOD"];
    STAssertTrue([result isEqualToString:@"EXTENSION-FROM-CYCLE-METHOD"], @"not right result");
    
DCI suggests using roles to manage extensions in a standard and systematic way. This is the subject of the next section.

# DCI Features

TODO - see unit tests for now
