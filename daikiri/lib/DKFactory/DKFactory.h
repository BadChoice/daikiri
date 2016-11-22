//
//  DKFactory.h
//  daikiri
//
//  Created by Badchoice on 22/11/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKFactory : NSObject{
    Class       _class;
    int         _count;
    NSString*   _name;
}

+(void)define   :(Class)class                       builder:(NSDictionary*(^)())builder;
+(void)defineAs :(Class)class name:(NSString*)name  builder:(NSDictionary*(^)())builder;

+(DKFactory*)factory:(Class)class;
+(DKFactory*)factory:(Class)class count:(int)count;
+(DKFactory*)factory:(Class)class name:(NSString*)name;
+(DKFactory*)factory:(Class)class name:(NSString*)name count:(int)count;

-(id)make;
-(id)create;

-(id)make:(NSDictionary*)overrideAttributes;
-(id)create:(NSDictionary*)overrideAttributes;

@end
