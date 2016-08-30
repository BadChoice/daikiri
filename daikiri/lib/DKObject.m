//
//  DKObject.m
//  daikiri
//
//  Created by Badchoice on 16/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "DKObject.h"

#define IsEqual(x,y) ((x && [x isEqual:y]) || (!x && !y))

@implementation DKObject

static NSMutableDictionary * cachedProperties;

//==================================================================
#pragma mark - Copy with zone
//==================================================================
- (id)copyWithZone:(NSZone *)zone{
    id newObject = [[self.class alloc] init];
    
    [self.class properties:^(NSString *name) {
        [newObject setValue:[self valueForKey:name] forKey:name];
    }];
    
    return newObject;
}

-(BOOL)isEqual:(id)object{
    if (self == object)                       return YES;
    if (![object isMemberOfClass:self.class]) return NO;
    
    __block bool isEqual = YES;
    
    [self.class properties:^(NSString *name) {
        if( ! IsEqual ( [object valueForKey:name] , [self valueForKey:name])){
            isEqual = NO;
        }
    }];
    
    return isEqual;
}

- (NSUInteger)hash {
    NSUInteger __block hash = 0;
    [self.class properties:^(NSString *name) {
        hash = hash ^ [[self valueForKey:name] hash];
    }];
    return hash;
}

/*-(NSString*)description{
 [self.class properties:^(NSString *name, objc_property_t property) {
 NSLog(@"%@ => %@", name, [self valueForKey:name] );
 }];
 }*/


+(void)properties:(void (^)(NSString* name))block{
    if(cachedProperties[self.class] == nil) [self.class cacheProperties];
    for(NSString* propertyName in cachedProperties[self.class]){
        block(propertyName);
    }
}

+(void)propertiesWithProperty:(void (^)(NSString* name, objc_property_t property))block{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray  = class_copyPropertyList(self.class, &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name           = @(property_getName(property));
        block(name, property);
    }
    free(propertyArray);
}

+(void)cacheProperties{
    if(cachedProperties == nil) cachedProperties = [NSMutableDictionary new];
    NSMutableArray* properties                   = [NSMutableArray new];
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray  = class_copyPropertyList(self.class, &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name           = @(property_getName(property));
        [properties addObject:name];
        //block(name, property);
    }
    free(propertyArray);
    cachedProperties[self.class] = properties;
}

@end
