//
//  MVSJSONDataModel.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * @class MVSJSONDataModel
 * @ingroup DataModeling
 * @brief Base class for JSON data models
 *
 * A base class that implements the core methods for JSON based data Models.
 * See the wiki on GoogleCode for more details on creating data models with this class.
 */
@interface MVSJSONDataModel : NSObject {
@private
    
}

/**
 * @brief Initialize the data model with a NSDictionary
 * @param dict The dictionary that will initializ the data model.
 *
 * Initialize the data model with \c dict.
 * \c dict contains the keys that maps to the properties in your data model.
 */
- (id)initWithDictionary:(NSDictionary *)dict;

/**
 * @brief Initialuze the data model with an array.
 * @param array The array that will initialize your data model.
 *
 * Initialize the data model with \c array.
 */
- (id)initWithArray:(NSArray *)array;

@end
