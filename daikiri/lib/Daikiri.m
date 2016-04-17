//
//  Daikiri.m
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "Daikiri.h"
#import <objc/runtime.h>

#import "DaikiriCoreData.h"

@implementation Daikiri

//==================================================================
#pragma mark - CORE DATA
#pragma mark -
//==================================================================
+(id)create:(Daikiri*)toCreate{
    
    if(toCreate.id == nil){
        NSLog(@"model without id");
        return nil;
    }
    
    Daikiri* previous = [[self class] find:toCreate.id];
    if(previous) {
        NSLog(@"Model already exists with id: %@, returning the one from the DB",toCreate.id);
        return previous;
    }
    
    NSString* entityName    = NSStringFromClass([self class]);
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[[self class] managedObjectContext]];
    
    [toCreate valuesToManaged:object];
    [[self class] saveCoreData];
    
    return toCreate;
}
-(bool)save{
    Daikiri* previous = [[self class] find:self.id];
    if(previous) {
        return [self update];
    }
    else{
        return [[self class] create:self];
    }
}

-(bool)update{
    if(_managed){
        [self valuesToManaged:_managed];
        return [[self class] saveCoreData];
    }
    else{
        Daikiri* previous = [[self class] find:self.id];
        if(!previous){
            NSLog(@"Model not in database");
            return false;
        }
        else{
            [previous destroy];
            [self save];
        }
        
    }
    return true;    
}


-(bool)destroy{
    if(_managed){
        [[[self class] managedObjectContext] deleteObject:_managed];
        return [[self class] saveCoreData];
    }
    else{
        Daikiri *toDelete = [[self class] find:self.id];
        return [toDelete destroy];
    }
}

//==================================================================
#pragma mark - convenience methods
#pragma mark -
//==================================================================
+(bool)updateWith:(NSDictionary*)dict{
    Daikiri* object = [[self class] fromDictionary:dict];
    return [object update];
}

+(id)createWith:(NSDictionary*)dict{
    Daikiri* object = [[self class] fromDictionary:dict];
    return [[self class] create:object];
}

+(bool)destroyWith:(NSNumber*)id{
    Daikiri * object = [[self class] find:id];
    return [object destroy];
}

//==================================================================
#pragma mark - Active record
#pragma mark -
//==================================================================
+(id)find:(NSNumber*)id{
    if(id == nil) return nil;
    
    NSString* entityName    = NSStringFromClass([self class]);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", id];
    [request setPredicate:predicate];
    
    NSError *error   = nil;
    NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching object: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    if([results count] > 0){
        Daikiri *mo = [[self class] fromManaged:results[0]];
        return mo;
    }
    else
        return nil;
}

+(NSArray*)all{
    NSString* entityName    = NSStringFromClass([self class]);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];

    
    NSError *error   = nil;
    NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    return [[self class] managedArrayToDaikiriArray:results];
}

-(Daikiri*)belongsTo:(NSString*)model localKey:(NSString*)localKey{
    return [NSClassFromString(model) find:[self valueForKey:localKey]];
}

-(NSArray*)hasMany:(NSString*)model foreignKey:(NSString*)foreignKey{
    NSString* entityName    = model;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",foreignKey, self.id];
    [request setPredicate:predicate];
    
    NSError *error   = nil;
    NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    return [[self class] managedArrayToDaikiriArray:results];
}

-(NSArray*)belongsToMany:(NSString*)model pivot:(NSString*)pivotModel localKey:(NSString*)localKey foreignKey:(NSString*)foreingKey{
    
    //Pivots
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:pivotModel];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",localKey, self.id];
    [request setPredicate:predicate];
    
    NSError *error   = nil;
    NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    //
    NSMutableArray* finalResults = [[NSMutableArray alloc] init];
    NSArray* pivots = [NSClassFromString(pivotModel) managedArrayToDaikiriArray:results];
    for(id pivot in pivots){
        id object = [NSClassFromString(model) find:[pivot valueForKey:foreingKey]];
        [object setPivot:pivot];
        [finalResults addObject:object];
    }
    
    return finalResults;
}

+(NSManagedObjectContext*)managedObjectContext{
    //NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSManagedObjectContext * context = [DaikiriCoreData manager].managedObjectContext;
    return context;
}

//==================================================================
#pragma mark - HELPERS
#pragma mark -
//==================================================================
-(void)valuesToManaged:(NSManagedObject*)managedObject{
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray  = class_copyPropertyList([self class], &numberOfProperties);
    
    //We se the id always
    [managedObject setValue:[self valueForKey:@"id"] forKey:@"id"];
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name           = [[NSString alloc] initWithUTF8String:property_getName(property)];
        
        id value = [self valueForKey:name];
        
        if([value isKindOfClass:[NSString class]]){
            [managedObject setValue:value forKey:name];
        }
        else if([value isKindOfClass:[NSNumber class]]){
            [managedObject setValue:value forKey:name];
        }
        
    }
    free(propertyArray);
}

+(id)fromManaged:(NSManagedObject*)managedObject{
    Daikiri *newObject = [[[self class ]alloc] init];
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray  = class_copyPropertyList([self class], &numberOfProperties);
    
    [newObject setValue:[managedObject valueForKey:@"id"] forKey:@"id"];
    
    for (NSUInteger i = 0; i < numberOfProperties; i++)
    {
        objc_property_t property = propertyArray[i];
        NSString *name           = [[NSString alloc] initWithUTF8String:property_getName(property)];
        
        @try{
            id value = [managedObject valueForKey:name];
            
            if([value isKindOfClass:[NSString class]]){
                [newObject setValue:value forKey:name];
            }
            else if([value isKindOfClass:[NSNumber class]]){
                [newObject setValue:value forKey:name];
            }
        }@catch (NSException * e) {
            //NSLog(@"Model value not in core data entity: %@", e);
        }
        
    }
    free(propertyArray);
    [newObject setManaged:managedObject];
    return newObject;
}

+(NSArray*)managedArrayToDaikiriArray:(NSArray*)results{
    NSMutableArray* daikiriObjects = [[NSMutableArray alloc] init];
    for(NSManagedObject* managed in results){
        [daikiriObjects addObject:[[self class] fromManaged:managed]];
    }
    return daikiriObjects;
}

-(void)setManaged:(NSManagedObject *)managed{
    _managed = managed;
}

-(Daikiri*)pivot{
    return _pivot;
}

-(void)setPivot:(Daikiri*)pivot{
    _pivot = pivot;
}

+(BOOL)saveCoreData{
    NSError* error = nil;
    if(![[[self class] managedObjectContext] save:&error]){
        NSLog(@"Error: %@", [error localizedDescription]);
        return false;
    }
    return true;
}

@end
