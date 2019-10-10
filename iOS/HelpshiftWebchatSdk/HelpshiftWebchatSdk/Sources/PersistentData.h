//
//  PersistentData.h
//  HelpshiftPortfolio
//

#import <Foundation/Foundation.h>

static NSString *const DOMAIN_NAME = @"com.helpshift.webchat.sdk";

@interface PersistentData : NSObject
+ (void) initializeData;
+ (void) reInitializeData;

+ (NSString *) stringForKey:(NSString *)key;
+ (void) setString:(NSString *)object forKey:(NSString *)key;

+ (NSInteger) integerForKey:(NSString *)key;
+ (void) setInteger:(NSInteger)value forKey:(NSString *)key;

+ (id) objectForKey:(NSString *)key;
+ (void) setObject:(id)object forKey:(NSString *)key;

@end
