//
//  PersistentData.m
//  HelpshiftPortfolio
//

#import "PersistentData.h"

@implementation PersistentData

+ (void) initializeData {
    [PersistentData sharedInstance];
}

+ (void) reInitializeData {
    NSMutableDictionary *helpshiftDefaults = [[NSMutableDictionary alloc] init];

    [helpshiftDefaults setObject:@"done" forKey:@"init"];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:helpshiftDefaults forName:DOMAIN_NAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    helpshiftDefaults = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:DOMAIN_NAME] mutableCopy];
}

+ (instancetype) sharedInstance {
    static PersistentData *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[PersistentData alloc] init];
        NSMutableDictionary *helpshiftDefaults = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:DOMAIN_NAME] mutableCopy];

        if(helpshiftDefaults == nil) {
            helpshiftDefaults = [[NSMutableDictionary alloc] init];
            [helpshiftDefaults setObject:@"done" forKey:@"init"];
            [[NSUserDefaults standardUserDefaults] setPersistentDomain:helpshiftDefaults forName:DOMAIN_NAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    });
    return instance;
}

+ (NSInteger) integerForKey:(NSString *)key {
    NSMutableDictionary *helpshiftDefaults = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:DOMAIN_NAME] mutableCopy];

    if(helpshiftDefaults) {
        return [[helpshiftDefaults objectForKey:key] integerValue];
    }

    return -1;
}

+ (void) setInteger:(NSInteger)value forKey:(NSString *)key {
    NSMutableDictionary *helpshiftDefaults = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:DOMAIN_NAME] mutableCopy];

    if(helpshiftDefaults) {
        [helpshiftDefaults setObject:[NSNumber numberWithInteger:value] forKey:key];
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:helpshiftDefaults forName:DOMAIN_NAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString *) stringForKey:(NSString *)key {
    NSMutableDictionary *helpshiftDefaults = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:DOMAIN_NAME] mutableCopy];

    if(helpshiftDefaults) {
        return [helpshiftDefaults objectForKey:key];
    }

    return nil;
}

+ (void) setString:(NSString *)value forKey:(NSString *)key {
    NSMutableDictionary *helpshiftDefaults = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:DOMAIN_NAME] mutableCopy];

    if(helpshiftDefaults) {
        [helpshiftDefaults setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:helpshiftDefaults forName:DOMAIN_NAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (id) objectForKey:(NSString *)key {
    NSMutableDictionary *helpshiftDefaults = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:DOMAIN_NAME] mutableCopy];

    if(helpshiftDefaults) {
        return [helpshiftDefaults objectForKey:key];
    }

    return nil;
}

+ (void) setObject:(id)value forKey:(NSString *)key {
    NSMutableDictionary *helpshiftDefaults = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:DOMAIN_NAME] mutableCopy];

    if(helpshiftDefaults) {
        [helpshiftDefaults setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:helpshiftDefaults forName:DOMAIN_NAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
