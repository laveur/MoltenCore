//
//  NSString+HMAC.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 5/23/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import <CommonCrypto/CommonHMAC.h>
#import "NSString+HMAC.h"

@implementation NSString (NSString_HMAC)

- (NSString *)hmacSHA1SignatureWithKey:(NSString *)key {
	unsigned char buffer[CC_SHA1_DIGEST_LENGTH] = {0};
	
	CCHmac(kCCHmacAlgSHA1, [key cStringUsingEncoding:NSUTF8StringEncoding], [key length], [self cStringUsingEncoding:NSUTF8StringEncoding], [self length], buffer);
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		[output appendFormat:@"%02x",buffer[i]];
	}
	
	return output;
}

@end
