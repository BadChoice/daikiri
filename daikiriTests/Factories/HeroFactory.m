#import "HeroFactory.h"
#import "Hero.h"
#import "Enemy.h"

@implementation HeroFactory

-(void)registerFactories{

    [DKFactory define:Hero.class builder:^NSDictionary *(DKFaker *faker) {
        return @{
                @"name": @"Batman",
                @"age" : @"49"
        };
    }];
    
    [DKFactory define:Enemy.class builder:^NSDictionary * (DKFaker *faker){
        return @{
                 @"name": @"Luxor",
                 @"age" : @"32"
                 };
    }];
    
}
@end
