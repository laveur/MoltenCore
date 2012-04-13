//
//  NSDictionary+QueryString.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "NSDictionary+QueryString.h"
#import "MVSQueryString.h"

@implementation NSDictionary (NSDictionary_QueryString)

- (NSString *)queryStringForDictionary {
	return [MVSQueryString serializeDictionary:self];
}

@end
