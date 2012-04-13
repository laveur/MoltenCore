//
//  MVSJSONRPCResponse.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/31/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVSJSONDataModel.h"
#import "MVSJSONRPCError.h"

/**
 * @class MVSJSONRPCResponse
 * @ingroup DataModels
 * @brief A JSON-RPC Response
 *
 * Represents a JSON-RPC Response object based on the JSON RPC 2.0 spec.
 */
@interface MVSJSONRPCResponse : MVSJSONDataModel {
@private
	NSString *jsonrpc;
	id result;
	MVSJSONRPCError *error;
	id id;
}
@property (nonatomic, copy) NSString *jsonrpc; ///< The Version of the jsonrpc spec. MUST-BE "2.0"
@property (nonatomic, copy) id result; ///< The result of the call
@property (nonatomic, copy) MVSJSONRPCError *error; ///< The error if one occured
@property (nonatomic, copy) id id; ///< The method ID

@end
