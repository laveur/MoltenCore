//
//  MVSQueryString.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MVSQueryString.h"


@implementation MVSQueryString

+ (NSDictionary *)parseQueryString:(NSString *)queryString {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	NSArray *kvPairs = [queryString componentsSeparatedByString:@"&"];
	
	for(NSString *kvPair in kvPairs) {
		NSArray *pair = [kvPair componentsSeparatedByString:@"="];
		[dictionary setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
	}
	
	return dictionary;
}

+ (NSString *)serializeDictionary:(NSDictionary *)dict {
	NSMutableString *queryString = [NSMutableString string];
	NSArray *keys = [dict allKeys];
	
	for(int i = 0; i < [keys count]; i++) {
		NSString *key = [keys objectAtIndex:i];
		if([[dict valueForKey:key] isKindOfClass:[NSString class]]) {
			[queryString appendFormat:@"%@=%@", key, [MVSQueryString escapeString:[dict valueForKey:key]]];
		} else {
			[queryString appendFormat:@"%@=%@", key, [dict valueForKey:key]];
		}
		
		
		if(i < ([keys count] - 1)) {
			[queryString appendString:@"&"];
		}
	}
	
	return queryString;
}

+ (NSString *)escapeString:(NSString *)str {
	NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)str, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
	return [encodedString autorelease];
}

@end
