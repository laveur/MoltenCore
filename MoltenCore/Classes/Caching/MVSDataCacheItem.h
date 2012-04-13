//
//  MVSDataCacheItem.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/29/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class MVSDataCacheItem
 * @ingroup Caching
 * @brief Represents a data item in the the data cache.
 * 
 * A single cached item in the shared data class.
 */
@interface MVSDataCacheItem : NSObject {
@private
	NSString *key;
	NSString *contentType;
	NSData *data;
}
@property (nonatomic, readonly) NSString *key; ///< The Key
@property (nonatomic, readonly) NSString *contentType; ///< The Content Type
@property (nonatomic, readonly) NSData *data; ///< The actual data

/**
 * @brief Create a cache item
 * @param theData The data you want cache
 * @param theContentType The content type of the data you are caching
 * @param theKey The key you are storing the data as
 *
 * Initializes a new cache item with the specified argurments.
 */
- (id)initWithData:(NSData *)theData contentType:(NSString *)theContentType andKey:(NSString *)theKey;

@end
