//
//  MVSSharedDataCache.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/29/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import "MVSSharedDataCache.h"
#import "MVSDataCacheItem.h"

static MVSSharedDataCache *staticDataCache = nil;

@implementation MVSSharedDataCache

#pragma mark - Class Methods
+ (MVSSharedDataCache *)sharedDataCache {
	@synchronized(self) {
		if(staticDataCache == nil) {
			staticDataCache = [[MVSSharedDataCache alloc] init];
		}
	}
	
	return staticDataCache;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(staticDataCache == nil) {
			staticDataCache = [super allocWithZone:zone];
			return staticDataCache;
		}
	}
	
	return nil;
}

#pragma mark - Inherited Methods
- (id)init {
	if((self = [super init])) {
		self->dataCache = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void)dealloc {
	[self->dataCache release];
	
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

#pragma mark - Private Methods

#pragma mark - Instance Methods
- (void)cacheData:(NSData *)data withContentType:(NSString *)mimeType forKey:(NSString *)key {
	MVSDataCacheItem *cacheItem = [[MVSDataCacheItem alloc] initWithData:data contentType:mimeType andKey:key];
	[self->dataCache setObject:cacheItem forKey:key];
	[cacheItem release];
}

- (NSData *)cachedDataForKey:(NSString *)key {
	MVSDataCacheItem *item = [self->dataCache objectForKey:key];
	return item.data;
}

- (NSString *)contentTypeForKey:(NSString *)key {
	MVSDataCacheItem *item = [self->dataCache objectForKey:key];
	return item.contentType;
}

- (void)emptyCache {
	[self->dataCache removeAllObjects];
}


@end
