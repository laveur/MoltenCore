//
//  MVSSlowKeyDictionaryProxy.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class MVSSlowKeyDictionaryProxy
 * @ingroup DataModeling
 * @brief Helper class for MVSJSONDataModel
 *
 * This class is used internally by MVSJSONDataModel for initializing dictionary objects
 * within your data models.
 */
@interface MVSSlowKeyDictionaryProxy : NSObject {
@private
	NSString *_key;
	id _target;
	SEL _setSelector;
	SEL _removeSelector;
}

/**
 * @brief Initializes the the dictionary proxy.
 * @param aKey The Property key you are setting
 * @param target The target object you are setting the property for
 *
 * Returns a proxy object that inserts objects into a dictionary in your data model.
 */
- (id)initWithKey:(NSString *)aKey andTarget:(id)target;

/**
 * @brief Replacement object for NSDictionary's setObject:forKey: method.
 * @param anObject The object you are setting
 * @param key The key that you are setting
 *
 * Sets \c anObject for \c key in your data model.
 */
- (void)setObject:(id)anObject forKey:(id)key;

/**
 * @brief Replacement method for NSDictionary's removeObjectForKey: method.
 * @param object The key you wish to remove.
 *
 * Removes an object from your data model.
 */
- (void)removeObjectForKey:(id)object;

@end
