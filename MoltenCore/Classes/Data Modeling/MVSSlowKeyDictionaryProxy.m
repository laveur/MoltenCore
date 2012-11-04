//
//  MVSSlowKeyDictionaryProxy.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import "MVSSlowKeyDictionaryProxy.h"


@implementation MVSSlowKeyDictionaryProxy

#pragma mark -
#pragma mark Inherited
- (void)dealloc {
	[self->_key release];
	self->_key = nil;
	
	[self->_target release];
	self->_target = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark Initialize Methods
- (id)initWithKey:(NSString *)aKey andTarget:(id)aTarget {
	if((self = [super init])) {
		self->_key = [aKey retain];
		self->_target = [aTarget retain];
		
		NSString *setSelectorString = [NSString stringWithFormat:@"setObjectIn%@:forKey:", [self->_key capitalizedString]];
		
		self->_setSelector = NSSelectorFromString(setSelectorString);
		
		NSString *removeSelectorString = [NSString stringWithFormat:@"removeObjectFrom%@ForKey:", [self->_key capitalizedString]];
		
		self->_removeSelector = NSSelectorFromString(removeSelectorString);
	}
	return self;
}

#pragma mark -
#pragma mark Instance Methods
- (void)setObject:(id)anObject forKey:(id)key {
	if([self->_target respondsToSelector:self->_setSelector]) {
		[self->_target performSelector:self->_setSelector withObject:anObject withObject:key];
	}
}

- (void)removeObjectForKey:(id)object {
	if([self->_target respondsToSelector:self->_removeSelector]) {
		[self->_target performSelector:self->_removeSelector withObject:object];
	}
}

@end
