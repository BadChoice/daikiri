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
}

@property(strong,nonatomic) NSNumber* id;


//-----------------
// CORE DATA
//-----------------

+(bool)create:(Daikiri*)object;
/**
 * The save function uses the model ID for checking if it already 
 * exists so it will do an update, or if model ID is null or can't
 * find the object, it will create a new one and save it to the
 * database
 */
-(bool)save;

-(bool)update;

-(bool)delete;

+(id)find:(NSNumber*)id;
+(NSArray*)all;

//+(id)fromManaged:(NSManagedObject*)managedObject;


-(void)setManaged:(NSManagedObject*)managed;

@end
