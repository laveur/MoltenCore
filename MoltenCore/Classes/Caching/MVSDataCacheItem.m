//
//  MVSDataCacheItem.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/29/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import "MVSDataCacheItem.h"


@implementation MVSDataCacheItem

#pragma mark - Synthesized Properties
@synthesize key;
@synthesize contentType;
@synthesize data;

- (id)initWithData:(NSData *)theData contentType:(NSString *)theContentType andKey:(NSString *)theKey {
	if((self = [super init])) {
		self->data = [theData copy];
		self->contentType = [theContentType copy];
		self->key = [theKey copy];
	}
	
	return self;
}

- (void)dealloc {
	[self->data release];
	[self->contentType release];
	[self->key release];
	
	[super dealloc];
}

@end
