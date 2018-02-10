//
//  Daikiri.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "DaikiriJSON.h"

@implementation DaikiriJSON

static NSMutableDictionary* classesForKeyPathsCached;

//==================================================================
#pragma mark - FROM/TO DICTIONARY
//==================================================================
+(id)fromDictionary:(NSDictionary*)dict{
    
    if([dict isKindOfClass:NSDictionary.class]){
        DaikiriJSON* model = [self.class new];
        
        for(NSString* key in dict.allKeys){
            
            id value = dict[key];
            id valueConverted = [model valueConverted:value forKey:key];
            if(valueConverted != nil){
                [model setValue:valueConverted forKey:key];
            }
        }
        return model;
    }
    if([self.class isNull:dict] || [@"null" isEqualToString:(NSString*)dict] || [@"" isEqualToString:(NSString*)dict] ){
        return nil;
    }
    
    [NSException raise:@"Not a NSDictionary" format:@"Trying to create a Daikiri model from a non dictionary object"];
    return nil;
}

+(id)fromDictionaryString:(NSString*)string{
    NSData *data        = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dict  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [self.class fromDictionary:dict];
}

-(NSDictionary*)toDictionary{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    
    [self.class properties:^(NSString *name) {
        
        if(![self shouldIgnoreKey:name]){
            
            id value = [self valueForKey:name];
            if([self.class isNull:value]){
                dict[name] = NSNull.null;
            }
            else if([value isKindOfClass:NSString.class]){
                dict[name] = [self convertoNSString:value];
            }
            else if([value isKindOfClass:NSNumber.class]){
                dict[name] = [self convertToNSNumber:value];
            }
            else if([value isKindOfClass:NSArray.class]){
                NSMutableArray* dictArray = [NSMutableArray new];
                for(id child in value){
                    if([child isKindOfClass:DaikiriJSON.class])
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
#pragma mark - HELPERS
//==================================================================
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
-(id)valueConverted:(id)value forKey:(NSString*)key{
    
    if ([self.class isNull:value]){
        return nil;
    }
    if ([key isEqualToString:@"id"]){
        return [self convertToNSNumber:value];
    }
    if ([self classForKeyPath:key] == NSString.class){
        return [self convertoNSString:value];
    }
    if ([self classForKeyPath:key] == NSNumber.class){
        return [self convertToNSNumber:value];
    }
    if ([self classForKeyPath:key] == NSDictionary.class){
        return value;
    }
    else if([value isKindOfClass:NSArray.class]){
        NSString* methodName        = [NSString stringWithFormat:@"%@_DaikiriArray",key];
        SEL s                       = NSSelectorFromString(methodName);
        
        if (![self respondsToSelector:s]) {
            return value;
        }
        Class childClass            = [self performSelector:s];
        NSMutableArray* newArray    = [NSMutableArray new];
        for(id arrayDict in value){
            id childModel = [childClass fromDictionary:arrayDict];
            [newArray addObject:childModel];
        }
        return newArray;
    }
    
    id subValue = [[self classForKeyPath:key] fromDictionary:value];
    return subValue;
}
#pragma clang diagnostic pop
-(void)cacheClassesForKeyPath{
    if(classesForKeyPathsCached == nil) classesForKeyPathsCached = [NSMutableDictionary new];
    NSMutableDictionary* classesForKeyPath = [NSMutableDictionary new];
    
    [self.class propertiesWithProperty:^(NSString *name, objc_property_t property) {
        const char* attributes = property_getAttributes(property);
        if (attributes[1] == '@') {
            NSMutableString* className = [NSMutableString new];
            
            for (int j=3; attributes[j] && attributes[j]!='"'; j++){
                [className appendFormat:@"%c", attributes[j]];
            }
            classesForKeyPath[name] = className;
        }
    }];
    
    classesForKeyPathsCached[NSStringFromClass(self.class)] = classesForKeyPath;
}

-(Class)classForKeyPath:(NSString*)keyPath {
    if(classesForKeyPathsCached[NSStringFromClass(self.class)] == nil) [self cacheClassesForKeyPath];
    
    NSString* className = classesForKeyPathsCached[NSStringFromClass(self.class)][keyPath];
    return NSClassFromString(className);
}

-(NSNumber*)convertToNSNumber:(NSNumber*)value{
    if([value isKindOfClass:NSString.class]){
        return @(value.doubleValue);
    }
    return value;
}

-(NSString*)convertoNSString:(NSString*)value{
    if([value isKindOfClass:NSNumber.class]){
        return ((NSNumber*)value).stringValue;
    }
    return value;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(BOOL)isNull:(id)value{
    return (value == nil || [value isKindOfClass:NSNull.class]);
}


//=======================================================
#pragma mark - From / to Dictionary array
//=======================================================
//TODO: Import RVCollection and use its map
+(NSArray*)fromDictionaryArray:(NSArray*)array{
    NSMutableArray *newArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSDictionary* dict, NSUInteger idx, BOOL *stop) {
        [newArray addObject:[self.class fromDictionary:dict]];
    }];
    return newArray;
}

+(NSArray*)toDictionaryArray:(NSArray*)array{
    NSMutableArray *newArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(DaikiriJSON* obj, NSUInteger idx, BOOL *stop) {
        [newArray addObject:obj.toDictionary];
    }];
    return newArray;
}

@end
