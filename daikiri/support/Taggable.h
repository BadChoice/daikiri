//
//  Tag.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 29/2/24.
//  Copyright © 2024 revo. All rights reserved.
//

#import "Daikiri.h"
#import <Foundation/Foundation.h>
#import "Tag.h"

@interface Taggable : Daikiri

@property (strong,nonatomic) NSNumber* tag_id;
@property (strong,nonatomic) NSNumber* taggable_id;
@property (strong,nonatomic) NSString* taggable_type;

-(Tag*)tag;
-(id)taggable;


@end

