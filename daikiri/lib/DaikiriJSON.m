#import "RVCollection.h"
#import "DaikiriJSON.h"

@implementation DaikiriJSON

static NSMutableDictionary* classesForKeyPathsCached;

//==================================================================
#pragma mark - FROM/TO DICTIONARY
//==================================================================
+ (instancetype)fromDictionary:(NSDictionary*)dict{
    if (isNull(dict) || isEqual(@"null", dict) || isEqual(@"", dict) ){
        return nil;
    }
    return [self.class fromDictionary:dict placeholder:self.class.new];
}

+ (instancetype)fromDictionary:(NSDictionary*)dict placeholder:(DaikiriJSON*)placeholder{
    if (isNull(dict) || isEqual(@"null", dict) || isEqual(@"", dict) ){
        return nil;
    }
    
    if (! [dict isKindOfClass:NSDictionary.class]) {
        [NSException raise:@"Not a NSDictionary" format:@"Trying to create a Daikiri model from a non dictionary object"];
        return nil;
    }
    [dict.allKeys each:^(NSString* key) {
        id valueConverted = [placeholder valueConverted:dict[key] forKey:key];
        if (valueConverted != nil){
            [placeholder setValue:valueConverted forKey:key];
        }
    }];
    return placeholder;
}

+(instancetype)fromDictionaryString:(NSString*)string{
    NSData *data        = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dict  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [self.class fromDictionary:dict];
}

-(NSDictionary*)toDictionary{
    return [self toDictionary:@[]];
}

-(NSDictionary*)toDictionary:(NSArray*)foceKeys{
    NSMutableDictionary* dict = NSMutableDictionary.new;
    
    [self.class properties:^(NSString *name) {
        if ([self shouldIgnoreKey:name] && ![foceKeys containsObject:name]) return;

        id value = [self valueForKey:name];
        if ( isNull(value) ){
            dict[name] = NSNull.null;
        }
        else if([value isKindOfClass:NSString.class]){
            dict[name] = [self convertoNSString:value];
        }
        else if([value isKindOfClass:NSNumber.class]){
            dict[name] = [self convertToNSNumber:value];
        }
        else if([value isKindOfClass:NSDictionary.class]){
            dict[name] = value;
        }
        else if([value isKindOfClass:DaikiriJSON.class]){
            dict[name] = [value toDictionary];
        }
        else if([value isKindOfClass:NSArray.class]){
            NSMutableArray* dictArray = NSMutableArray.new;
            for(id child in value){
                if([child isKindOfClass:DaikiriJSON.class])
                    [dictArray addObject:[child toDictionary]];
                else
                    [dictArray addObject:child];
            }
            dict[name] = dictArray;
        }
        else{
            [NSException raise:@"Non convertable to dictionary value in object" format:@"Non convertable to dictionary value in object"];
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
    
    if ( isNull(value)) {
        return nil;
    }
    if (isEqual(@"id", key) ){
        return [self convertToNSNumber:value];
    }
    if ([self classForKeyPath:key] == NSString.class){
        return [self convertoNSString:value];
    }
    if ([self classForKeyPath:key] == NSNumber.class){
        return [self convertToNSNumber:value];
    }
    if ([self classForKeyPath:key] == NSDictionary.class || [self classForKeyPath:key] == NSMutableDictionary.class){
        return value;
    }
    else if([value isKindOfClass:NSArray.class]){
        NSString* methodName        = str(@"%@_DaikiriArray", key);
        SEL s                       = NSSelectorFromString(methodName);
        
        if (![self respondsToSelector:s]) {
            return value;
        }
        Class childClass            = [self performSelector:s];
        NSMutableArray* newArray    = NSMutableArray.new;
        for (id arrayDict in value){
            [newArray addObject:[childClass fromDictionary:arrayDict]];
        }
        return newArray;
    }
    
    id subValue = [[self classForKeyPath:key] fromDictionary:value];
    return subValue;
}
#pragma clang diagnostic pop
-(void)cacheClassesForKeyPath{
    if(classesForKeyPathsCached == nil) classesForKeyPathsCached = NSMutableDictionary.new;
    NSMutableDictionary* classesForKeyPath = NSMutableDictionary.new;
    
    [self.class propertiesWithProperty:^(NSString *name, objc_property_t property) {
        const char* attributes = property_getAttributes(property);
        if (attributes[1] == '@') {
            NSMutableString* className = NSMutableString.new;
            
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

//=======================================================
#pragma mark - From / to Dictionary array
//=======================================================
+(NSArray*)fromDictionaryArray:(NSArray*)array{
    return [array map:^id(NSDictionary* dict, NSUInteger idx) {
        return [self.class fromDictionary:dict];
    }];
}

+(NSArray*)toDictionaryArray:(NSArray*)array{
    return [array map:^id(DaikiriJSON* obj, NSUInteger idx) {
        return obj.toDictionary;
    }];
}

@end
