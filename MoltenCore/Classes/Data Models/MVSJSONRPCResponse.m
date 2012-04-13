//
//  MVSJSONRPCResponse.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/31/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import "MVSJSONRPCResponse.h"
#import "JSONKit.h"

@interface MVSJSONRPCResponse (Private)

- (void)setDictionaryValueForError:(NSDictionary *)dict;

@end

@implementation MVSJSONRPCResponse

#pragma mark - Synthesized Properties
@synthesize jsonrpc;
@synthesize result;
@synthesize error;
@synthesize id;


#pragma mark - Inherited
- (void)dealloc {
	self.jsonrpc = nil;
	self.result = nil;
	self.error = nil;
	self.id = nil;
	
	[super dealloc];
}

- (void)setDictionaryValueForError:(NSDictionary *)dict {
	self->error = [[MVSJSONRPCError alloc] initWithDictionary:dict];
}

- (NSString *)description {
	NSString *str = [NSString stringWithFormat:@"jsonrpc=%@, result=%@, error=%@, id=%@", self.jsonrpc, self.result, self.error, self.id];
	return str;
}

@end
