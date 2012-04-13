//
//  MVSJSONRPCRequest.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/31/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import "MVSJSONRPCRequest.h"
#import "JSONKit.h"

@implementation MVSJSONRPCRequest

#pragma mark - Synthesized Properties
@synthesize jsonrpc;
@synthesize method;
@synthesize params;
@synthesize id;

#pragma mark - Init Methods
- (id)initWithJSONRPC:(NSString *)version rpcMethod:(NSString *)theMethod methodParameters:(id)theParams methodID:(id)methodID {
	if((self = [super init])) {
		self.jsonrpc = version;
		self.method = theMethod;
		self.params = theParams;
		self.id = methodID;
	}
	
	return self;
}

- (void)dealloc {
	self.jsonrpc = nil;
	self.method = nil;
	self.params = nil;
	self.id = nil;
	
	[super dealloc];
}

#pragma mark - Instance Methods
- (NSDictionary *)serializeRequest {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setValue:self.jsonrpc forKey:@"jsonrpc"];
	[dictionary setValue:self.method forKey:@"method"];
	
	if(self.params) {
		[dictionary setValue:self.params forKey:@"params"];
	}
	
	[dictionary setValue:self.id forKey:@"id"];
	
	return dictionary;
}

- (NSString *)description {
	return [[self serializeRequest] JSONString];
}

@end
