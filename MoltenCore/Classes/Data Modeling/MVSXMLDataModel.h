//
//  MVSXMLDataModel.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class MVSXMLDataModel
 * @ingroup DataModeling
 * @brief Base class for XML Data Models
 *
 * A base class that implements the core methods for XML based data Models.
 * See the wiki on GoogleCode for more details on creating data models with this class.
 */
@interface MVSXMLDataModel : NSObject {
@private
    
}

/**
 * @brief Initialize your data model with an XML Node
 * @param node The node in the XML data to initialize your data model with.
 *
 * Creates a new instance of your data model initializing it with the data stored in \c node.
 */
- (id)initWithXMLElement:(NSXMLNode *)node;

@end
