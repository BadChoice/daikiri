//
//  Daikiri.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DaikiriJSON.h"

@interface Daikiri : DaikiriJSON{
    NSManagedObject *_managed;
    Daikiri         *_pivot;
}

@property(strong,nonatomic) NSNumber* id;


//-----------------
// CORE DATA
//-----------------

+(id)create:(Daikiri*)object;
/**
 * The save function uses the model ID for checking if it already 
 * exists so it will do an update, or if model ID is null or can't
 * find the object, it will create a new one and save it to the
 * database
 */
-(bool)save;

-(bool)update;

-(bool)destroy;

// Convenience methods
+(id)createWith:(NSDictionary*)dict;
+(bool)updateWith:(NSDictionary*)dict;
+(bool)destroyWith:(NSNumber*)id;

// Eloquent like
+(id)find:(NSNumber*)id;
+(NSArray*)all;

-(Daikiri*)belongsTo:(NSString*)model localKey:(NSString*)localKey;
-(NSArray*)hasMany:(NSString*)model foreignKey:(NSString*)foreignKey;
-(NSArray*)belongsToMany:(NSString*)model pivot:(NSString*)pivotModel localKey:(NSString*)localKey foreignKey:(NSString*)foreingKey;

-(Daikiri*)pivot;


@end
