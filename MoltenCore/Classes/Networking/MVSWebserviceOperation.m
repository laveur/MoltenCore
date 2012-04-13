//
//  MVSWebserviceOperation.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MVSWebserviceOperation.h"


@implementation MVSWebserviceOperation

#pragma mark - Initialization Methods
- (id)initWithURLRequest:(NSURLRequest *)aRequest service:(MVSWebserviceBase *)aService selector:(SEL)aSelector client:(id<MVSWebserviceDelegate>)aClient callbackSelector:(SEL)aCallback {
    if((self = [super init])) {
        self->request = [aRequest retain];
		self->service = [aService retain];
		self->selector = aSelector;
		self->client = [aClient retain];
		self->callbackSelector = aCallback;
		
		self->isExecuting = NO;
		self->isFinished = NO;
    }
    
    return self;
}

- (id)initWithURLRequest:(NSURLRequest *)aRequest service:(MVSWebserviceBase *)aService selector:(SEL)aSelector serviceCallback:(SEL)aServiceCallback client:(id<MVSWebserviceDelegate>)aClient callbackSelector:(SEL)aCallback {
	if((self = [super init])) {
        self->request = [aRequest retain];
		self->service = [aService retain];
		self->selector = aSelector;
		self->serviceCallback = aServiceCallback;
		self->client = [aClient retain];
		self->callbackSelector = aCallback;
		
		self->isExecuting = NO;
		self->isFinished = NO;
    }
	
	return self;
}

- (void)dealloc {
	[self->request release];
	[self->service release];
	[self->client release];
	
	if(self->data != nil) {
		[self->data release];
	}
	
	if(self->connection != nil) {
		[self->connection release];
	}
	
    [super dealloc];
}

#pragma mark - Inherited
- (void)start {
	self->data = [[NSMutableData alloc] init];
	self->connection = [[NSURLConnection alloc] initWithRequest:self->request delegate:self startImmediately:NO];
	[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[connection start];
	
	[self willChangeValueForKey:@"isExecuting"];
	self->isExecuting = YES;
	[self didChangeValueForKey:@"isExecuting"];
	
	while(!self->isFinished) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
}

- (BOOL)isReady {
	return YES;
}

- (BOOL)isExecuting {
	return self->isExecuting;
}

- (BOOL)isFinished {
	return self->isFinished;
}

#pragma mark - NSURLConnectionDelegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self->data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData {
	[self->data appendData:someData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self willChangeValueForKey:@"isExecuting"];
	self->isExecuting = NO;
	[self didChangeValueForKey:@"isExecuting"];
	
	[self->client serviceDidReceiveError:self->service error:error];
	
	[self willChangeValueForKey:@"isFinished"];
	self->isFinished = YES;
	[self didChangeValueForKey:@"isFinished"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection {
	[self willChangeValueForKey:@"isExecuting"];
	self->isFinished = NO;
	[self didChangeValueForKey:@"isExecuting"];
	
	[self performSelectorOnMainThread:@selector(dispatchResultsOnMainThread) withObject:nil waitUntilDone:YES];
}

#pragma mark - Helpers
- (void)dispatchResultsOnMainThread {
	NSString *dataStr = [[NSString alloc] initWithData:self->data encoding:NSUTF8StringEncoding];
	NSInvocation *invocation = [self->service prepareInvocationForObject:self->service andSelector:self->selector];
	
	[invocation setArgument:&dataStr atIndex:2];
	
	if(self->serviceCallback) {
		[invocation setArgument:&self->serviceCallback atIndex:3];
		[invocation setArgument:&self->client atIndex:4];
		[invocation setArgument:&self->callbackSelector atIndex:5];
	} else {
		[invocation setArgument:&self->client atIndex:3];
		[invocation setArgument:&self->callbackSelector atIndex:4];
	}
	
	[invocation invoke];
	
	[self willChangeValueForKey:@"isFinished"];
	self->isFinished = YES;
	[self didChangeValueForKey:@"isFinished"];
}

@end
