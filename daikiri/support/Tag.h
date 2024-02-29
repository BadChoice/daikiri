//
//  Tag.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 29/2/24.
//  Copyright © 2024 revo. All rights reserved.
//

#import "Daikiri.h"
#import <Foundation/Foundation.h>


@interface Tag : Daikiri

@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSNumber* taggable_id;
@property (strong,nonatomic) NSString* taggable_type;

-(id)taggable;

@end

