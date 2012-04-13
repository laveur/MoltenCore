//
//  MVSJSONRPCServiceBase.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSJSONRPCServiceBase.h"
#import "JSONKit.h"
#import "MVSWebserviceOperation.h"
#import "MVSJSONRPCResponse.h"

@implementation MVSJSONRPCServiceBase

#pragma mark - Inherited Methods
- (id)initWithBaseURL:(NSString *)aBaseURL {
    if((self = [super initWithBaseURL:aBaseURL])) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - Instance Methods
- (MVSJSONRPCRequest *)requestForJSONRPCMethod:(NSString *)method paramDictionary:(NSDictionary *)dictionary methodID:(id)anID {
	MVSJSONRPCRequest *request = [[MVSJSONRPCRequest alloc] initWithJSONRPC:@"2.0" rpcMethod:method methodParameters:dictionary methodID:anID];
	
	return [request autorelease];
}

- (MVSSignedJSONRPCRequest *)signedRequestWithSecret:(NSString *)secret forJSONRPCMethod:(NSString *)method paramDictionary:(NSDictionary *)dictionary methodID:(id)anID {
	MVSSignedJSONRPCRequest *request = [[MVSSignedJSONRPCRequest alloc] initWithSecret:secret JSONRPC:@"2.0" rpcMethod:method methodParameters:dictionary methodID:anID];
	
	return [request autorelease];
}

- (MVSJSONRPCRequest *)requestForJSONRPCMethod:(NSString *)method paramArray:(NSArray *)array methodID:(id)anID {
	MVSJSONRPCRequest *request = [[MVSJSONRPCRequest alloc] initWithJSONRPC:@"2.0" rpcMethod:method methodParameters:array methodID:anID];
	
	return [request autorelease];
}

- (MVSSignedJSONRPCRequest *)signedRequestWithSecret:(NSString *)secret forJSONRPCMethod:(NSString *)method paramArray:(NSArray *)array methodID:anID {
	MVSSignedJSONRPCRequest *request = [[MVSSignedJSONRPCRequest alloc] initWithSecret:secret JSONRPC:@"2.0" rpcMethod:method methodParameters:array methodID:anID];
	
	return [request autorelease];
}

- (void)dispatchRequest:(MVSJSONRPCRequest *)rpcRequest callbackSelector:(SEL)serviceCallback delegate:(id<MVSWebserviceDelegate>)delegate clientCallbackSelector:(SEL)callback {
	NSLog(@"Dispatching Request: server:%@\n\n%@", self.baseURL, rpcRequest);
	
	[self sendRequestData:[[[rpcRequest serializeRequest] JSONString] dataUsingEncoding:NSUTF8StringEncoding] callbackSelector:serviceCallback delegate:delegate clientCallbackSelector:callback];
}

- (void)sendRequestData:(NSData *)requestData callbackSelector:(SEL)serviceCallback delegate:(id<MVSWebserviceDelegate>)delegate clientCallbackSelector:(SEL)callback {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.baseURL]];
	[request setHTTPMethod:@"POST"];
	[request addValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:requestData];
	
	if(!self.asynchronous) {
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		if(error != nil) {
			[delegate serviceDidReceiveError:self error:error];
		} else {
			NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			NSInvocation *invocation = [self prepareInvocationForObject:self andSelector:@selector(didReceiveRPCResponseData:serviceCallback:delegate:callback:)];
			
			[invocation setArgument:&dataStr atIndex:2];
			[invocation setArgument:&serviceCallback atIndex:3];
			[invocation setArgument:&delegate atIndex:4];
			[invocation setArgument:&callback atIndex:5];
			[invocation invoke];
			[dataStr release];
		}
	} else {
		MVSWebserviceOperation *op = [[MVSWebserviceOperation alloc] initWithURLRequest:request service:self selector:@selector(didReceiveRPCResponseData:serviceCallback:delegate:callback:) serviceCallback:serviceCallback client:delegate callbackSelector:callback];
		
		[self addWebserviceOperation:op];
		[op release];
	}
}

- (void)didReceiveRPCResponseData:(NSString *)data serviceCallback:(SEL)serviceCallback delegate:(id<MVSWebserviceDelegate>)delegate callback:(SEL)callback {
	MVSJSONRPCResponse *response = [[MVSJSONRPCResponse alloc] initWithDictionary:[data objectFromJSONString]];
	NSInvocation *invocation = [self prepareInvocationForObject:self andSelector:serviceCallback];
	
	[invocation setArgument:&response atIndex:2];
	[invocation setArgument:&delegate atIndex:3];
	[invocation setArgument:&callback atIndex:4];
	[invocation invoke];
	[response release];
}

@end
