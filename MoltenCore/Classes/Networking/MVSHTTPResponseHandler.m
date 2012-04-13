//
//  MVSHTTPResponseHandler.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSHTTPResponseHandler.h"
#import "MVSHTTPResponseHandlerFactory.h"
#import "MVSSocketConnection.h"

@implementation MVSHTTPResponseHandler

#pragma mark - Class Methods
+ (NSUInteger)priority {
	return 0;
}

+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest method:(NSString *)requestMethod url:(NSURL *)requestURL headerFields:(NSDictionary *)requstHeaderFields {
	return YES;
}

#pragma mark - Synthesized Properties
@synthesize connection;
@synthesize requestURL;

#pragma mark - Initialization Methods
- (id)initWithRequest:(CFHTTPMessageRef)aRequest requestMethod:(NSString *)aRequestMethod requestedURL:(NSURL *)requestedURL requestHeaders:(NSDictionary *)theRequestHeaders connection:(MVSSocketConnection *)theConnection {
	if((self = [super init])) {
		self->request = aRequest;
		self->requestMethod = aRequestMethod;
		self->requestURL = requestedURL;
		self->requestHeaders = theRequestHeaders;
		self->connection = theConnection;
	}
	
	return self;
}

#pragma mark - Inherited
- (void)dealloc {
    [super dealloc];
}

#pragma mark - Instance Methods
- (void)handleResponse {
	CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 400, NULL, kCFHTTPVersion1_1);
	
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Type", (CFStringRef)@"text/html");
	CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Connection", (CFStringRef)@"close");
	
	NSString *responseBody = [NSString stringWithFormat:@"<html><head><title>400 - Bad Request</title></head>"
							  							@"<body><h1>400 - Bad Request</h1>"
							  							@"<p>No Handler exists to handle %@.</p></body></html>",
							  							[self->requestURL absoluteURL]];
	
	CFHTTPMessageSetBody(response, (CFDataRef)[responseBody dataUsingEncoding:NSUTF8StringEncoding]);
	NSData *responseData = (NSData *)CFHTTPMessageCopySerializedMessage(response);
	
	[self->connection sendData:responseData];
	
	CFRelease(responseData);
	CFRelease(response);
}

@end
