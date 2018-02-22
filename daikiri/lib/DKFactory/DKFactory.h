#import <Foundation/Foundation.h>
#import "DKFaker.h"

#define factory(A)      [DKFactory factory:A]

@interface DKFactory : NSObject{
    Class       _class;
    int         _count;
    NSString*   _name;
}

+(void)define   :(Class)class                       builder:(NSDictionary*(^)(DKFaker * faker))builder;
+(void)defineAs :(Class)class name:(NSString*)name  builder:(NSDictionary*(^)(DKFaker * faker))builder;

+(DKFactory*)factory:(Class)class;
+(DKFactory*)factory:(Class)class count:(int)count;
+(DKFactory*)factory:(Class)class name:(NSString*)name;
+(DKFactory*)factory:(Class)class name:(NSString*)name count:(int)count;

-(id)make;
-(id)create;

-(id)make:(NSDictionary*)overrideAttributes;
-(id)create:(NSDictionary*)overrideAttributes;

@end
