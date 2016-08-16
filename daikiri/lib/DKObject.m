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

//==================================================================
#pragma mark - Copy with zone
//==================================================================
- (id)copyWithZone:(NSZone *)zone{
    id newObject = [[self.class alloc] init];
    
    [self.class properties:^(NSString *name, objc_property_t property) {
        [newObject setValue:[self valueForKey:name] forKey:name];
    }];
    
    return newObject;
}

-(BOOL)isEqual:(id)object{
    __block bool isEqual = YES;
    
    [self.class properties:^(NSString *name, objc_property_t property) {
        if( ! IsEqual ( [object valueForKey:name] , [self valueForKey:name])){
            isEqual = NO;
        }
    }];
    
    return isEqual;
}

- (NSUInteger)hash {
    NSUInteger __block hash = 0;
    [self.class properties:^(NSString *name, objc_property_t property) {
        hash = hash ^ [[self valueForKey:name] hash];
    }];
    return hash;
}

/*-(NSString*)description{
 [self.class properties:^(NSString *name, objc_property_t property) {
 NSLog(@"%@ => %@", name, [self valueForKey:name] );
 }];
 }*/

+(void)properties:(void (^)(NSString* name, objc_property_t property))block{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray  = class_copyPropertyList(self.class, &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name           = [[NSString alloc] initWithUTF8String:property_getName(property)];
        block(name, property);
    }
    free(propertyArray);
}

@end
