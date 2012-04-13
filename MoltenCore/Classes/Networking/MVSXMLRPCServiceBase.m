//
//  MVSXMLRPCServiceBase.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSXMLRPCServiceBase.h"
#import "MVSWebserviceOperation.h"

@implementation MVSXMLRPCServiceBase

- (id)initWithBaseURL:(NSString *)aBaseURL {
    if ((self = [super initWithBaseURL:aBaseURL])) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (NSXMLDocument *)documentForXMLRPCMethod:(NSString *)method paramDictionary:(NSDictionary *)dictionary methodID:(id)anID {
	NSXMLDocument *doc = [[NSXMLDocument alloc] initWithRootElement:[NSXMLNode elementWithName:@"methodCall"]];
	[doc addChild:[NSXMLNode elementWithName:@"methodName" stringValue:method]];
	
	return [doc autorelease];
}

- (NSXMLDocument *)documentForXMLNRPCMethod:(NSString *)method paramArray:(NSArray *)array methodID:(id)anID {
	NSXMLDocument *doc = [[NSXMLDocument alloc] initWithRootElement:[NSXMLNode elementWithName:@"methodCall"]];
	[doc addChild:[NSXMLNode elementWithName:@"methodName" stringValue:method]];
	
	return [doc autorelease];
}

- (void)dispatchRequest:(NSXMLDocument *)requestDoc callbackSelector:(SEL)selector delegate:(id<MVSWebserviceDelegate>)delegate clientCallbackSelector:(SEL)callback {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.baseURL]];
	[request setHTTPMethod:@"POST"];
	[request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:[[requestDoc stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
	
	if(self.asynchronous) {
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		if(error != nil) {
			[delegate serviceDidReceiveError:self error:error];
		} else {
			NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			NSInvocation *invocation = [self prepareInvocationForObject:self andSelector:selector];

			[invocation setArgument:&dataStr atIndex:2];
			[invocation setArgument:&delegate atIndex:3];
			[invocation setArgument:&callback atIndex:4];
			[invocation invoke];
			[dataStr release];
		}
	} else {
		MVSWebserviceOperation *op = [[MVSWebserviceOperation alloc] initWithURLRequest:request service:self selector:selector client:delegate callbackSelector:callback];
		
		[self addWebserviceOperation:op];
		[op release];
	}
}

@end
