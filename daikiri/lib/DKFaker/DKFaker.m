#import "DKFaker.h"
#import "MBFaker.h"
#import "RVCollection.h"

@implementation DKFaker

- (NSString*) name{
    return MBFakerName.name;
}

- (NSNumber*) number{
    return @(arc4random_uniform(100));
}

- (NSString*)address{
    return MBFakerAddress.streetAddress;
}

- (NSString*)company{
    return str(@"%@ %@",MBFakerCompany.name, MBFakerCompany.suffix);
}

- (NSString*)email{
    return MBFakerInternet.email;
}

- (NSString*)ipv4{
    return MBFakerInternet.ipV4Address;
}

- (NSString*)ipv6{
    return MBFakerInternet.ipV6Address;
}

- (NSString*)url{
    return MBFakerInternet.url;
}

- (NSString*)username{
    return MBFakerInternet.userName;
}

- (NSString*)word{
    return MBFakerLorem.word;
}

- (NSString*)sentence{
    return MBFakerLorem.sentence;
}

- (NSString*)paragraph{
    return MBFakerLorem.paragraph;
}

@end