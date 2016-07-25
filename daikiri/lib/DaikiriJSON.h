//
//  Daikiri.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 15/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface DaikiriJSON : NSObject <NSCopying>

/*
 Things left to do:
 - Eloquent like
 */

//-----------------
// DICT
//-----------------
/**
 * Creates a new model using the dictionary as a source
 *
 * - √ Submodels. Automatically converts to the submodel to its class as long as it extends `Daikiri`
 *
 * - √ Arrays. to be able to do the conversion to another model
 * the method `-(Class)property_DaikiriArray` should be defined.
 */
+(id)fromDictionary:(NSDictionary*)dict;

/**
 * It calls the +(id)fromDictionary but first 
 * converting the string to a dict
 */
+(id)fromDictionaryString:(NSString*)string;

/**
 * Creates a dictionary from the model
 *
 * - √ Submodels
 * - √ Arrays
 */
-(NSDictionary*)toDictionary;

/**
 * Return an array of strings with the names of the values to ignore
 */
-(NSArray*)toDictionaryIgnore;


/**
 * Iterates through all properties of the object
 */
+(void)properties:(void (^)(NSString* name, objc_property_t property))block;

@end
