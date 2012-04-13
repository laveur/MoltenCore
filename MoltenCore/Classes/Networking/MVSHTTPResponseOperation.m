//
//  MVSHTTPResponseOperation.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/28/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSHTTPResponseOperation.h"
#import "MVSHTTPResponseHandler.h"

@interface MVSHTTPResponseOperation (Private)

- (void)notifyOnMain;

@end

@implementation MVSHTTPResponseOperation

#pragma mark - Initialization Methods
- (id)initWithResponseHandler:(MVSHTTPResponseHandler *)aHandler delegate:(id<MVSHTTPResponseOperationDelegate>)theDelegate {
    if((self = [super init])) {
        self->handler = [aHandler retain];
		self->delegate = theDelegate;
    }
    
    return self;
}

#pragma mark - Inherited Methods
- (void)dealloc {
    [super dealloc];
}

- (void)start {
	[self willChangeValueForKey:@"isExecuting"];
	self->isExecuting = YES;
	[self didChangeValueForKey:@"isExecuting"];
	
	[self->handler handleResponse];
	
	[self willChangeValueForKey:@"isExecuting"];
	self->isExecuting = NO;
	[self didChangeValueForKey:@"isExecuting"];
	
	[self performSelectorOnMainThread:@selector(notifyOnMain) withObject:nil waitUntilDone:YES];
	
	[self willChangeValueForKey:@"isFinished"];
	self->isFinished = YES;
	[self didChangeValueForKey:@"isFinished"];
}

- (BOOL)isExecuting {
	return self->isExecuting;
}

- (BOOL)isFinished {
	return self->isFinished;
}

#pragma mark - Instance Methods
- (MVSHTTPResponseHandler *)handler {
	return self->handler;
}

#pragma mark - Private Methods
- (void)notifyOnMain {
	[self->delegate responseOperationDidComplete:self];
}

@end
