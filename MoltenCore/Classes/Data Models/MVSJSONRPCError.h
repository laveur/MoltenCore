//
//  MVSJSONRPCError.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/31/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVSJSONDataModel.h"

/**
 * @class MVSJSONRPCError
 * @ingroup DataModels
 * @brief Represents a JSON-RPC Error.
 * 
 * Represents a JSON-RPC Error message per the JSON-RPC 2.0 Spec.
 */
@interface MVSJSONRPCError : MVSJSONDataModel {
@private
	NSNumber *code;
	NSString *message;
	id data;
}
@property (nonatomic, copy) NSNumber *code; ///< The error code
@property (nonatomic, copy) NSString *message; ///< The error message
@property (nonatomic, copy) id data; ///< Optional Data

@end
