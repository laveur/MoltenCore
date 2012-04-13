//
//  MVSWebserviceBase.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSWebserviceBase.h"


@implementation MVSWebserviceBase
@synthesize baseURL;
@synthesize asynchronous;

- (id)initWithBaseURL:(NSString *)aBaseURL {
    if((self = [super init])) {
		self->baseURL = [aBaseURL copy];
		self->asynchronous = YES;
		self->aSyncQueue = [[NSOperationQueue alloc] init];
		[self->aSyncQueue setMaxConcurrentOperationCount:5];
	}
    
    return self;
}

- (void)dealloc {
	[self->baseURL release];
	[self->aSyncQueue release];
	
    [super dealloc];
}

- (void)addWebserviceOperation:(MVSWebserviceOperation *)op {
	[self->aSyncQueue addOperation:(NSOperation *)op];
}

- (NSInvocation *)prepareInvocationForObject:(id)object andSelector:(SEL)selector {
	NSInvocation *prepInvocation = [NSInvocation invocationWithMethodSignature:[object methodSignatureForSelector:selector]];
	[prepInvocation setTarget:object];
	[prepInvocation setSelector:selector];
	
	return prepInvocation;
}

- (void)dispatchClient:(id<MVSWebserviceDelegate>)client callbackSelector:(SEL)selector params:(id)firstParam, ... {
	id eachObject = nil;
	va_list argumentList;
	int argIndex = 2;
	NSInvocation *invocation = [self prepareInvocationForObject:client andSelector:selector];
	
	if(firstParam) {
		[invocation setArgument:&firstParam atIndex:argIndex];
		argIndex++;
		
		va_start(argumentList, firstParam);
		while ((eachObject = va_arg(argumentList, id)) != nil) {
			[invocation setArgument:&eachObject atIndex:argIndex];
			argIndex++;
		}
		va_end(argumentList);
	}
	
	[invocation invoke];
}

- (NSString *)escapeString:(NSString *)str {
	NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				   NULL,
																				   (CFStringRef)str,
																				   NULL,
																				   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				   kCFStringEncodingUTF8 );
	return [encodedString autorelease];
}

@end
