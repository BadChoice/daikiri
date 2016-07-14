//
//  Daikiri.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "DaikiriJSON.h"
#import <objc/runtime.h>
#define IsEqual(x,y) ((x && [x isEqual:y]) || (!x && !y))

@implementation DaikiriJSON

//==================================================================
#pragma mark - FROM/TO DICTIONARY
//==================================================================
+(id)fromDictionary:(NSDictionary*)dict{
    
    if([dict isKindOfClass:[NSDictionary class]]){
        DaikiriJSON* model = [[self.class alloc] init];
        
        for(NSString* key in [dict allKeys]){
            
            id value = dict[key];
            id valueConverted = [model valueConverted:value forKey:key];
            if(valueConverted != nil){
                [model setValue:valueConverted forKey:key];
            }
        }
        return model;
    }
    if([self.class isNull:dict] || [@"" isEqualToString:(NSString*)dict] ){
        return nil;
    }
    
    [NSException raise:@"Not a NSDictionary" format:@"Trying to create a Daikiri model from a non dictionary object"];
    return nil;
}

-(NSDictionary*)toDictionary{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [self properties:^(NSString *name, objc_property_t property) {
        
        if(![self shouldIgnoreKey:name]){
            
            id value = [self valueForKey:name];
            if([self.class isNull:value]){
                dict[name] = [NSNull null];
            }
            else if([value isKindOfClass:NSString.class]){
                dict[name] = value;
            }
            else if([value isKindOfClass:NSNumber.class]){
                dict[name] = [self convertToNSNumber:value];
            }
            else if([value isKindOfClass:NSArray.class]){
                NSMutableArray* dictArray = [[NSMutableArray alloc] init];
                for(id child in value){
                    if([child isKindOfClass:[DaikiriJSON class]])
                        [dictArray addObject:[child toDictionary]];
                    else
                        [dictArray addObject:child];
                }
                dict[name] = dictArray;
            }
            else{
                id subValue = [value toDictionary];
                dict[name] = subValue;
            }
        }
        
    }];    
    
    return dict;
}

-(BOOL)shouldIgnoreKey:(NSString*)key{
    return [self.toDictionaryIgnore containsObject:key];
}

-(NSArray*)toDictionaryIgnore{
    return @[];
}

//==================================================================
#pragma mark - Copy with zone
//==================================================================
- (id)copyWithZone:(NSZone *)zone{
    id newObject = [[self.class alloc] init];
    
    [self properties:^(NSString *name, objc_property_t property) {
        [newObject setValue:[self valueForKey:name] forKey:name];
    }];
    
    return newObject;
}

-(BOOL)isEqual:(id)object{
    __block bool isEqual = YES;
    
    [self properties:^(NSString *name, objc_property_t property) {
        if( ! IsEqual ( [object valueForKey:name] , [self valueForKey:name]))
            isEqual = NO;
    }];
    
    return isEqual;
}

//==================================================================
#pragma mark - HELPERS
//==================================================================
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
-(id)valueConverted:(id)value forKey:(NSString*)key{
    
    if([self.class isNull:value]){
        return nil;
    }
    
    if([key isEqualToString:@"id"]){
        return [self convertToNSNumber:value];
    }
    if ([self classForKeyPath:key] == NSString.class){
        return value;   //TODO: convert to string if nsnumber
    }
    if ([self classForKeyPath:key] == NSNumber.class){
        return [self convertToNSNumber:value];
    }
    else if([value isKindOfClass:NSArray.class]){
        NSString* methodName        = [NSString stringWithFormat:@"%@_DaikiriArray",key];
        SEL s                       = NSSelectorFromString(methodName);
        
        if ([self respondsToSelector:s]) {
            Class childClass            = [self performSelector:s];
            NSMutableArray* newArray    = [[NSMutableArray alloc] init];
            for(id arrayDict in value){
                id childModel = [childClass fromDictionary:arrayDict];
                [newArray addObject:childModel];
            }
            return newArray;
        }
        else{
            return value;
        }
    }
    else{
        id subValue = [[self classForKeyPath:key] fromDictionary:value];
        return subValue;
    }
    return nil;
}
#pragma clang diagnostic pop

-(Class)classForKeyPath:(NSString*)keyPath {
    
    __block Class class = 0;
    [self properties:^(NSString *name, objc_property_t property) {
        
        if ( [keyPath isEqualToString:name] ){
            const char* attributes = property_getAttributes(property);
            if (attributes[1] == '@') {
                NSMutableString* className = [NSMutableString new];
                
                for (int j=3; attributes[j] && attributes[j]!='"'; j++){
                    [className appendFormat:@"%c", attributes[j]];
                }
                class = NSClassFromString(className);
            }
        }
    }];
    
    return class;
}

-(void)properties:(void (^)(NSString* name, objc_property_t property))block{
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


-(NSNumber*)convertToNSNumber:(NSNumber*)value{
    if([value isKindOfClass:NSString.class]){
        return @([value floatValue]);
    }
    return value;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(BOOL)isNull:(id)value{
    return (value == nil || [value isKindOfClass:[NSNull class]]);
}


@end
