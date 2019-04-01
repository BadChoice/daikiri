#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface DKObject : NSObject <NSCopying>

- (id)copyWithZone:(NSZone *)zone placeHolder:(id)newObject;

/**
 * Iterates through all properties of the object
 */
+(void)properties:(void (^)(NSString* name))block;
+(void)propertiesWithProperty:(void (^)(NSString* name, objc_property_t property))block;

@end
