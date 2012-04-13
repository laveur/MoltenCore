//
//  NSString+QueryString.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "NSString+QueryString.h"
#import "MVSQueryString.h"

@implementation NSString (NSString_QueryString)

- (NSDictionary *)dictionaryForQueryString {
	return [MVSQueryString parseQueryString:self];
}

@end
