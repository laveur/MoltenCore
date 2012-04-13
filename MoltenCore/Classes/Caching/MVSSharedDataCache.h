//
//  MVSSharedDataCache.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/29/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class MVSSharedDataCache
 * @ingroup Caching
 * @brief Shared Memory Data Cache
 *
 * Cache NSData Objects with a mime type for fast lookup later.
 */
@interface MVSSharedDataCache : NSObject {
@private
	NSMutableDictionary *dataCache;
}

/**
 * @brief Get a shared instance of the data cache.
 * 
 * Singleton Method to access the shared data cache.
 */
+ (MVSSharedDataCache *)sharedDataCache;

/**
 * @brief Add an item to the data cache
 * @param data the NSData object to be cached
 * @param mimeType The Mimetype of the data to cache
 * @param key The Key to store the data as
 *
 * Adds \c data to the memory cache with the mimetype \c mimeType stored for the key, \c key.
 */
- (void)cacheData:(NSData *)data withContentType:(NSString *)mimeType forKey:(NSString *)key;

/**
 * @brief Retrieve a cached data object
 * @param key The key of the data object you want
 *
 * Retrieve the cached data object for \c key.
 */
- (NSData *)cachedDataForKey:(NSString *)key;

/**
 * @brief Retrieve the content type for a specific key.
 * @param key The key for the data you want
 *
 * Retrieves the mime type for the key, \c key.
 */
- (NSString *)contentTypeForKey:(NSString *)key;

/**
 * @brief Clears the cache.
 *
 * Removes all items in the cache.
 */
- (void)emptyCache;

@end
