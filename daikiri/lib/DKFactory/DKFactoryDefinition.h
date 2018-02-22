#import <Foundation/Foundation.h>

@interface DKFactoryDefinition : NSObject

+ (void)registerFactories:(NSArray<DKFactoryDefinition *> *)definitions;
- (void)registerFactories;
@end
