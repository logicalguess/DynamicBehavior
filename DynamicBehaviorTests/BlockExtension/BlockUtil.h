
extern char const *GetObjCTypesForBlock(id param);

// BlockDescriptor
struct BlockDescriptor
{
    unsigned long reserved;
    unsigned long size;
    void *rest[1];
};

// Block
struct Block
{
    void *isa;
    int flags;
    int reserved;
    void *invoke;
    struct BlockDescriptor *descriptor;
};

// Flags of Block
enum {
    BLOCK_HAS_COPY_DISPOSE =	(1 << 25),
    BLOCK_HAS_CTOR =			(1 << 26), // helpers have C++ code
    BLOCK_IS_GLOBAL =			(1 << 28),
    BLOCK_HAS_STRET =			(1 << 29), // IFF BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE =		(1 << 30),
};

@interface NSInvocation (LGBlockExtension)
- (void)invokeUsingIMP:(IMP)imp;
@end

NSMethodSignature *GetMethodSignatureForBlock(id block) {
// Make signatures
    NSMethodSignature *blockSignature;
    NSMutableString *objCTypes;
    blockSignature = [NSMethodSignature signatureWithObjCTypes:GetObjCTypesForBlock(block)];
    objCTypes = [NSMutableString stringWithFormat:@"%@@:", [NSString stringWithCString:[blockSignature methodReturnType] encoding:NSUTF8StringEncoding]];
    for (NSInteger i = 2; i < [blockSignature numberOfArguments]; i++) {
        [objCTypes appendString:[NSString stringWithCString:[blockSignature getArgumentTypeAtIndex:i] encoding:NSUTF8StringEncoding]];
    }
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:[objCTypes cStringUsingEncoding:NSUTF8StringEncoding]];
    return methodSignature;
}


char const *GetObjCTypesForBlock(id _block) {
    {
        // Get descriptor of block
        struct BlockDescriptor *descriptor;
        struct Block *block;
        block = (__bridge struct Block*)_block;
        descriptor = block->descriptor;

        // Get index of rest
        int index = 0;
        if (block->flags & BLOCK_HAS_COPY_DISPOSE) {
            index += 2;
        }

        return descriptor->rest[index];
    }
}

