#import "DKObject.h"

#define IsEqual(x,y) ((x && [x isEqual:y]) || (!x && !y))

@implementation DKObject

static NSMutableDictionary * cachedProperties;

//==================================================================
#pragma mark - Copy with zone
//==================================================================
- (id)copyWithZone:(NSZone *)zone{
    id newObject = [[self.class alloc] init];
    return [self copyWithZone:zone placeHolder:newObject];
}

- (id)copyWithZone:(NSZone *)zone placeHolder:(id)newObject{
    __weak DKObject* weakSelf = self;
    [self.class properties:^(NSString *name) {
        id value = [weakSelf valueForKey:name];
        if ([value isKindOfClass:NSArray.class]) {
            value = [[NSArray alloc] initWithArray:[value copy] copyItems:YES];
        }
        else if ([value isKindOfClass:NSDictionary.class]) {
            value = [[NSDictionary alloc] initWithDictionary:value copyItems:YES];
        }
        [newObject setValue:value forKey:name];
    }];
    
    return newObject;
}

-(BOOL)isEqual:(id)object{
    if (self == object)                        return YES;
    if (! [object isMemberOfClass:self.class]) return NO;
    
    __block bool isEqual = YES;
    
    [self.class properties:^(NSString *name) {
        if (isEqual && ! IsEqual ([object valueForKey:name], [self valueForKey:name])) {
            isEqual = NO;
        }
    }];    
    return isEqual;
}

- (NSUInteger)hash {
    NSUInteger __block hash = 0;
    [self.class properties:^(NSString *name) {
        hash ^= [[self valueForKey:name] hash];
    }];
    return hash;
}

+(void)properties:(void (^)(NSString* name))block{
    if(cachedProperties[NSStringFromClass(self.class)] == nil) [self.class cacheProperties];
    for(NSString* propertyName in cachedProperties[NSStringFromClass(self.class)]){
        block(propertyName);
    }
}

+(void)propertiesWithProperty:(void (^)(NSString* name, objc_property_t property))block{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray  = class_copyPropertyList(self.class, &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        block(@(property_getName(property)), property);
    }
    free(propertyArray);
}

+(void)cacheProperties{
    if(cachedProperties == nil) cachedProperties = [NSMutableDictionary new];
    NSMutableArray* properties                   = [self.class getProperties];
    cachedProperties[NSStringFromClass(self.class)] = properties;
}

+(NSMutableArray*)getProperties{
    NSMutableArray* properties                   = [NSMutableArray      new];
    
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray  = class_copyPropertyList(self.class, &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        [properties addObject:@(property_getName(property))];
    }
    free(propertyArray);
    return properties;
}

/*
 -(NSString*)description{
    [self.class properties:^(NSString *name, objc_property_t property) {
        NSLog(@"%@ => %@", name, [self valueForKey:name] );
    }];
 }
 */

@end
