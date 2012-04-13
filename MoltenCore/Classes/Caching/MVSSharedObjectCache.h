//
//  MVSSharedObjectCache.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 6/7/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MVSSharedObjectCache : NSObject {
@private
    NSMutableDictionary *objectCache;
}

+ (MVSSharedObjectCache *)sharedObjectCache;

- (void)cacheObject:(id)obj withName:(NSString *)name;
- (id)cachedItemForName:(NSString *)name;
- (void)removeCachedItemForName:(NSString *)name;
- (void)clearCache;

@end
