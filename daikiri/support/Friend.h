//
//  Friend.h
//  daikiri
//
//  Created by Jordi Puigdellívol on 17/4/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "Daikiri.h"
#import "Hero.h"

@interface Friend : Daikiri

@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSNumber* hero_id;

-(Hero*)hero;

@end
