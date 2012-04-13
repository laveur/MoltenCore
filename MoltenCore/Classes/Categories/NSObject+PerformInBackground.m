//
//  NSObject+PerformInBackground.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 5/20/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import "NSObject+PerformInBackground.h"


@implementation NSObject (PerformInBackground)

- (void)performSelectorInBackground:(SEL)aSelector withValues:(void *)context, ... {
	if(context) {
		NSMethodSignature *theSignature = [self methodSignatureForSelector:aSelector];
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:theSignature];
		NSUInteger argCount = [theSignature numberOfArguments] - 2;
		
		[invocation retainArguments];
		
		[invocation setTarget:self];
		[invocation setSelector:aSelector];
		
		va_list arguments;
		va_start(arguments, context);
		void *currentValue = context;
		
		for(NSUInteger i = 0; i < argCount; i++) {
			[invocation setArgument:&currentValue atIndex:(i + 2)];
			currentValue = va_arg(arguments, void *);
		}
		
		va_end(arguments);
		
		[invocation performSelectorInBackground:@selector(invoke) withObject:nil];
	} else {
		[self performSelectorInBackground:aSelector withObject:nil];
	}
}

@end
