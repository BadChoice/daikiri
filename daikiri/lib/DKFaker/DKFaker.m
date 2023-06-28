#import "DKFaker.h"
#import "RVCollection.h"

@implementation DKFaker

- (NSString*) name{
    NSArray* names = @[
        @"Jordi",
        @"Eduard",
        @"Pau",
        @"Marti",
        @"Marc",
        @"Lou",
        @"Jenni",
        @"Cristian",
        @"Adria",
        @"Aleix",
        @"Alex",
        @"Ignasi",
        @"Gerard",
        @"Eva",
        @"Isabel",
        @"Sandra"
    ];
    NSUInteger randomIndex = arc4random() % names.count;
    return names[randomIndex];
}

- (NSNumber*) number{
    return @(arc4random_uniform(100));
}

- (NSString*)address{
    NSArray* names = @[
        @"C/Bruc 23, 1er Pis",
        @"C/Arquitecte oms 2",
        @"Plaça del sol, 23",
        @"Plaça St Domenech, 15",
        @"General Prim 9-11",
        @"Alzina 11, Pineda de Bages",
    ];
    NSUInteger randomIndex = arc4random() % names.count;
    return names[randomIndex];
}

- (NSString*)company{
    NSArray* names = @[
        @"Revo Systems",
        @"Apple",
        @"Facebook S.L",
        @"Meta",
        @"Google Inc",
        @"Microsoft",
        @"Oculus Quest",
    ];
    NSUInteger randomIndex = arc4random() % names.count;
    return names[randomIndex];
}

- (NSString*)email{
    NSArray* names = @[
        @"example@example.com",
        @"jordi@revo.works",
        @"jordi@gmail.com",
        @"jordi@msn.com",
        @"johndoe@me.com",
        @"no-reply@github.com",
    ];
    NSUInteger randomIndex = arc4random() % names.count;
    return names[randomIndex];
}

- (NSString*)ipv4{
    NSArray* names = @[
        @"192.168.1.1",
        @"192.168.1.2",
        @"192.168.1.3",
        @"192.168.1.4",
        @"192.168.1.5",
        @"192.168.1.6",
    ];
    NSUInteger randomIndex = arc4random() % names.count;
    return names[randomIndex];
}

/*- (NSString*)ipv6{
    return MBFakerInternet.ipV6Address;
}*/

- (NSString*)url{
    NSArray* names = @[
        @"https://revo.com",
        @"https://revo.works",
        @"https://revointouch.works",
        @"https://revosolo.works",
        @"https://revoflow.works",
        @"https://revoretail.works",
    ];
    NSUInteger randomIndex = arc4random() % names.count;
    return names[randomIndex];
}

- (NSString*)username{
    NSArray* names = @[
        @"aragorn",
        @"guitarboy000",
        @"jpuigdellivol",
        @"codepassion.io",
        @"armagedoon1234",
        @"sexygirl",
    ];
    NSUInteger randomIndex = arc4random() % names.count;
    return names[randomIndex];
}

- (NSString*)word{
    NSArray* names = @[
        @"Potatoe",
        @"House",
        @"Mall",
        @"Incredible",
        @"Nation",
        @"Afire",
        @"Affinity",
        @"Word",
    ];
    NSUInteger randomIndex = arc4random() % names.count;
    return names[randomIndex];
}

- (NSString*)sentence{
    NSArray* names = @[
        @"The blue house is not blue anymore",
        @"Working from home, is good, but just sometimes",
        @"Close slack if you want to be productive",
        @"We only use the 7% of our brain",
        @"Dream big, work hard, or the other way around",
        @"I have no place to sleep tonight, can I come to your site?",
        @"Never deploy on fridays, or not",
        @"I've run out of ideas for new sentences",
    ];
    NSUInteger randomIndex = arc4random() % names.count;
    return names[randomIndex];
}

/*- (NSString*)paragraph{
    return MBFakerLorem.paragraph;
}*/

@end
