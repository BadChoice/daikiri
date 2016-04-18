//
//  QueryBuilder.h
//  daikiri
//
//  Created by Badchoice on 18/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueryBuilder : NSObject{
    NSMutableArray* _predicates;
    NSMutableArray* _sortPredicates;
    NSString*       _model;
}

+(QueryBuilder*)query:(NSString*)model;

-(QueryBuilder*)where:(NSString*)field value:(id)value;
-(QueryBuilder*)where:(NSString*)field operator:(NSString*)operator value:(id)value;

-(QueryBuilder*)sort:(NSString*)key;
-(QueryBuilder*)sort:(NSString*)key ascendig:(BOOL)ascending;

-(NSArray*)get;
-(id)first;
@end
