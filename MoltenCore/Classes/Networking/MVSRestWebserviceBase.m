//
//  MVSRestWebserviceBase.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSRestWebserviceBase.h"
#import "MVSQueryString.h"
#import "MVSWebserviceOperation.h"

@interface MVSRestWebserviceBase (Private)

- (NSURL *)generateURLForMethod:(NSString *)method parameters:(NSDictionary *)params;

@end

@implementation MVSRestWebserviceBase

- (void)dealloc {
    [super dealloc];
}

- (NSURLRequest *)urlRequestForMethod:(NSString *)method {
	return [NSURLRequest requestWithURL:[self generateURLForMethod:method parameters:nil]];
}

- (NSURLRequest *)urlRequestForMethod:(NSString *)method parameters:(NSDictionary *)params {
	return [NSURLRequest requestWithURL:[self generateURLForMethod:method parameters:params]];
}

- (NSURLRequest *)urlPUTRequestForMethod:(NSString *)method PUTData:(NSData *)data {
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[self generateURLForMethod:method parameters:nil]];
	[urlRequest setHTTPMethod:@"PUT"];
	
	if(data != nil) {
		[urlRequest setHTTPBody:data];
	}
	
	return urlRequest;
}

- (NSURLRequest *)urlPOSTRequestForMethod:(NSString *)method POSTData:(NSData *)data {
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[self generateURLForMethod:method parameters:nil]];
	[urlRequest setHTTPMethod:@"POST"];
	
	if(data != nil) {
		[urlRequest setHTTPBody:data];
	}
	
	return urlRequest;
}

- (void)dispatchRequest:(NSURLRequest *)request callbackSelector:(SEL)selector delegate:(id<MVSWebserviceDelegate>)delegate clientCallbackSelector:(SEL)callback {
	NSLog(@"Dispatching Request: %@", request);
	if(!self.asynchronous) {
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		if(error) {
			[delegate serviceDidReceiveError:self error:error];
		} else {
			NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			NSInvocation *invocation = [self prepareInvocationForObject:self andSelector:selector];
			
			[invocation setArgument:&dataStr atIndex:2];
			[invocation setArgument:&delegate atIndex:3];
			[invocation setArgument:&callback atIndex:4];
			[invocation invoke];
		}
	} else {
		MVSWebserviceOperation *op = [[MVSWebserviceOperation alloc] initWithURLRequest:request service:self selector:selector client:delegate callbackSelector:callback];
		
		[self addWebserviceOperation:op];
		[op release];
	}
}

- (NSURL *)generateURLForMethod:(NSString *)method parameters:(NSDictionary *)params {
	NSMutableString *url = [NSMutableString stringWithFormat:@"%@/%@", self.baseURL, method];
	
	if(params != nil) {
		[url appendFormat:@"?%@", [MVSQueryString serializeDictionary:params]];
	}
	
	return [NSURL URLWithString:url];
}

@end
