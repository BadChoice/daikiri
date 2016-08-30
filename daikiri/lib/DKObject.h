//
//  DKObject.h
//  daikiri
//
//  Created by Badchoice on 16/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface DKObject : NSObject <NSCopying>

/**
 * Iterates through all properties of the object
 */
+(void)properties:(void (^)(NSString* name))block;
+(void)propertiesWithProperty:(void (^)(NSString* name, objc_property_t property))block;

@end
