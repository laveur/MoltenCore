//
//  MVSSharedObjectCache.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 6/7/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import "MVSSharedObjectCache.h"

static MVSSharedObjectCache *sharedCache = nil;

@implementation MVSSharedObjectCache

#pragma mark - Class Methods
+ (MVSSharedObjectCache *)sharedObjectCache {
	@synchronized(self) {
		if(sharedCache == nil) {
			sharedCache = [[MVSSharedObjectCache alloc] init];
		}
	}
	
	return sharedCache;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(sharedCache == nil) {
			sharedCache = [super allocWithZone:zone];
			return sharedCache;
		}
	}
	
	return nil;
}

#pragma mark - Inherited
- (id)init {
    if((self = [super init])) {
        self->objectCache = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc {
	[self->objectCache release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (NSUInteger)retainCount {
	return NSUIntegerMax;
}

- (oneway void)release {
}

- (id)autorelease {
	return self;
}

#pragma mark - Instance Methods
- (void)cacheObject:(id)obj withName:(NSString *)name {
	[self->objectCache setObject:obj forKey:name];
}

- (id)cachedItemForName:(NSString *)name {
	return [self->objectCache objectForKey:name];
}

- (void)removeCachedItemForName:(NSString *)name {
	[self->objectCache removeObjectForKey:name];
}

- (void)clearCache {
	[self->objectCache removeAllObjects];
}

@end
