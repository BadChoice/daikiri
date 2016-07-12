//
//  Daikiri.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "DaikiriJSON.h"
#import <objc/runtime.h>


@implementation DaikiriJSON

//==================================================================
#pragma mark - FROM/TO DICTIONARY
#pragma mark -
//==================================================================
+(id)fromDictionary:(NSDictionary*)dict{
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

-(NSDictionary*)toDictionary{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray  = class_copyPropertyList(self.class, &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name              = [[NSString alloc] initWithUTF8String:property_getName(property)];
        
        if(![self shouldIgnoreKey:name]){
        
            id value = [self valueForKey:name];
            if([self isNull:value]){
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
    }
    free(propertyArray);
    
    return dict;
}

-(BOOL)shouldIgnoreKey:(NSString*)key{
    return [self.toDictionaryIgnore containsObject:key];
}

-(NSArray*)toDictionaryIgnore{
    return @[];
}

//==================================================================
#pragma mark - HELPERS
//==================================================================
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
-(id)valueConverted:(id)value forKey:(NSString*)key{
    
    if([self isNull:value]){
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
    Class class = 0;
    
    unsigned int n = 0;
    objc_property_t* properties = class_copyPropertyList(self.class, &n);
    for (unsigned int i=0; i<n; i++) {
        objc_property_t* property = properties + i;
        NSString* name = [NSString stringWithCString:property_getName(*property) encoding:NSUTF8StringEncoding];
        if (![keyPath isEqualToString:name]) continue;
        
        const char* attributes = property_getAttributes(*property);
        if (attributes[1] == '@') {
            NSMutableString* className = [NSMutableString new];
            for (int j=3; attributes[j] && attributes[j]!='"'; j++)
                [className appendFormat:@"%c", attributes[j]];
            class = NSClassFromString(className);
        }
        break;
    }
    free(properties);
    
    return class;
}

-(NSNumber*)convertToNSNumber:(NSNumber*)value{
    if([value isKindOfClass:NSString.class]){
        return @([value floatValue]);
    }
    return value;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


-(BOOL)isNull:(id)value{
    return (value == nil || [value isKindOfClass:[NSNull class]]);
}


@end
