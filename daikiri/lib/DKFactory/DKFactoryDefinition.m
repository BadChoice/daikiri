#import "DKFactoryDefinition.h"
#import "RVCollection.h"

@implementation DKFactoryDefinition

+ (void)registerFactories:(NSArray<DKFactoryDefinition*>*)definitions{
    [definitions each_:@selector(registerFactories)];
}

- (void)registerFactories{

}

@end
