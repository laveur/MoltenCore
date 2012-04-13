//
//  MVSHTTPRequstHandlerFactory.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSHTTPResponseHandlerFactory.h"
#import "MVSHTTPResponseHandler.h"

// This is just here to get rid of annoying warnings
@interface NSObject (MVSHTTPRequestHandler)

+ (NSUInteger)priority;
+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest method:(NSString *)requestMethod url:(NSURL *)requestURL headerFields:(NSDictionary *)requstHeaderFields;

@end

@implementation MVSHTTPResponseHandlerFactory

#pragma mark - Inherited Methods
- (id)init {
	if((self = [super init])) {
		self->registeredHandlers = [[NSMutableArray alloc] init];
		
		[self registerHandler:[MVSHTTPResponseHandler class]];
	}
	
	return self;
}


- (void)dealloc {
	[self->registeredHandlers release];
	
	[super dealloc];
}

#pragma mark - Instance Methods
- (void)registerHandler:(Class)handlerClass {
	NSUInteger index;
	
	for(index = 0; index < [registeredHandlers count]; index++) {
		if([handlerClass priority] >= [[registeredHandlers objectAtIndex:index] priority]) {
			break;
		}
	}
	
	[registeredHandlers insertObject:handlerClass atIndex:index];
}

- (Class)handlerClassForRequest:(CFHTTPMessageRef)aRequest requestMethod:(NSString *)requestMethod requestedURL:(NSURL *)requestedURL requestHeaders:(NSDictionary *)requestHeaders {
	for(Class handlerClass in registeredHandlers) {
		if([handlerClass canHandleRequest:aRequest method:requestMethod url:requestedURL headerFields:requestHeaders]) {
			return handlerClass;
		}
	}
	
	return nil;
}

- (MVSHTTPResponseHandler *)handlerForRequest:(CFHTTPMessageRef)aRequest connection:(MVSSocketConnection *)connection {
	NSDictionary *requestHeaders = [(NSDictionary *)CFHTTPMessageCopyAllHeaderFields(aRequest) autorelease];
	NSURL *requestedURL = [(NSURL *)CFHTTPMessageCopyRequestURL(aRequest) autorelease];
	NSString *requestMethod = [(NSString *)CFHTTPMessageCopyRequestMethod(aRequest) autorelease];
	
	Class requestHandlerClass = [self handlerClassForRequest:aRequest requestMethod:requestMethod requestedURL:requestedURL requestHeaders:requestHeaders];
	
	if(requestHandlerClass != nil) {
		MVSHTTPResponseHandler *responseHandler = [[[requestHandlerClass alloc] initWithRequest:aRequest requestMethod:requestMethod requestedURL:requestedURL requestHeaders:requestHeaders connection:connection] autorelease];
		
		return responseHandler;
	}
	
	return nil;
}

@end
