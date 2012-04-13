//
//  MVSJSONRPCError.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/31/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import "MVSJSONRPCError.h"
#import "JSONKit.h"

@implementation MVSJSONRPCError

#pragma mark - Synthesized Properties
@synthesize code;
@synthesize message;
@synthesize data;

#pragma mark - Inherited
- (void)dealloc {
	self.code = nil;
	self.message = nil;
	self.data = nil;
	
	[super dealloc];
}

- (NSString *)description {
	NSString *str = [NSString stringWithFormat:@"code=%@, message=%@, data=%@", self.code, self.message, self.data];
	
	return str;
}

@end
