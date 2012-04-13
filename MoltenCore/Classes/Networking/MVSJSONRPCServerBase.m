//
//  MVSJSONRPCServerBase.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/26/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSJSONRPCServerBase.h"


@implementation MVSJSONRPCServerBase

#pragma mark Synthesized Properties

#pragma mark Initializer Methods
- (id)initWithPort:(UInt16)aPort {
    if((self = [super init])) {
		self->rpcMethodTable = [[NSMutableDictionary alloc] init];
		self->httpServer = [[MVSHTTPServer alloc] initWithPort:aPort shouldPublisService:YES withServiceName:@"MVS JSON-RPC Server" serviceDomain:@"" andServiceType:@"_jsonrpc._tcp"];
    }
    
    return self;
}

#pragma mark Inherited
- (void)dealloc {
	[self->httpServer release];
	[self->rpcMethodTable release];
    [super dealloc];
}

#pragma mark Instance Methods
- (void)registerRPCMethodWithName:(NSString *)name andSelector:(SEL)selector {
	NSMethodSignature *methoSignature = [self methodSignatureForSelector:selector];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methoSignature];
	[invocation setTarget:self];
	[invocation setSelector:selector];
	
	[self->rpcMethodTable setObject:invocation forKey:name];
}

- (BOOL)start {
	return [self->httpServer listen];
}

@end
