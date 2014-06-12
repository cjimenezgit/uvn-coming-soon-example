//
// Created by Jon Slenk on 4/3/14.
// Copyright (c) 2014 Ooyala, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Constrained to require http:// or https://.
*/
@interface OOPlayerDomain : NSObject
+ (id) domainWithString:(NSString*)string;
- (id) init __attribute__((unavailable("Use initWithString: instead")));
- (id) initWithString:(NSString*)domainStr;
- (NSString*)asString;
- (NSURL*)asURL;
@end