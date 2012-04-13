//
//  MVSHTTPServer.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSHTTPServer.h"
#import "MVSHTTPResponseHandlerFactory.h"
#import "MVSHTTPResponseHandler.h"

UInt16 MVS_DEFAULT_HTTP_PORT = 8080;

@implementation MVSHTTPServer

#pragma mark - Synthesized Properties
@synthesize handlerFactory;

#pragma mark - Inherited Methods
- (id)init {
    return [self initWithPort:MVS_DEFAULT_HTTP_PORT];
}

- (id)initWithPort:(UInt16)aPort {
	return [self initWithPort:aPort shouldPublisService:YES withServiceName:@"MVS HTTP Server" serviceDomain:@"" andServiceType:@"_http._tcp"];
}

- (id)initWithPort:(UInt16)aPort shouldPublisService:(BOOL)shouldPublisService withServiceName:(NSString *)aServiceName serviceDomain:(NSString *)aServiceDomain andServiceType:(NSString *)aServiceType {
	if((self = [super initWithPort:aPort shouldPublisService:shouldPublisService withServiceName:aServiceName serviceDomain:aServiceDomain andServiceType:aServiceType])) {
		self->responseOperations = [[NSOperationQueue alloc] init];
		[self->responseOperations setMaxConcurrentOperationCount:5];
		self->incommingConnections = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	}
	
	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)newConnection:(MVSSocketConnection *)connection {
	CFDictionaryAddValue(self->incommingConnections, connection, [(id)CFHTTPMessageCreateEmpty(kCFAllocatorDefault, TRUE) autorelease]);
	connection.delegate = self;
	[connection open];
}

#pragma mark - MVSSocketConnectionDelegate
- (void)socketConnectionHasDataAvailable:(MVSSocketConnection *)connection {
	NSData *data = [connection readDataOfLength:1024];
	
	if([data length] == 0) {
		return;
	}
	
	CFHTTPMessageRef request = (CFHTTPMessageRef)CFDictionaryGetValue(self->incommingConnections, connection);
	
	if(!request) {
		return;
	}
	
	if(!CFHTTPMessageAppendBytes(request, [data bytes], [data length])) {
		return;
	}
	
	if(CFHTTPMessageIsHeaderComplete(request)) {
		MVSHTTPResponseHandler *handler = [self->handlerFactory handlerForRequest:request connection:connection];
		
		MVSHTTPResponseOperation *operation = [[MVSHTTPResponseOperation alloc] initWithResponseHandler:handler delegate:self];
		[self->responseOperations addOperation:operation];
		[operation release];
	}
}

- (void)socketConnectionDidDisconnect:(MVSSocketConnection *)connection {
	CFDictionaryRemoveValue(self->incommingConnections, connection);
}

#pragma mark - MVSHTTPResponseOperationDelegate
- (void)responseOperationDidComplete:(MVSHTTPResponseOperation *)operation {
	CFDictionaryRemoveValue(self->incommingConnections, operation.handler.connection);
}

@end
