//
//  MVSJSONRPCRequest.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 3/31/11.
//  Copyright 2011 Thinking Screen Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVSJSONDataModel.h"

/**
 * @class MVSJSONRPCRequest
 * @ingroup DataModels
 * @brief A JSON-RPC Request.
 *
 * Represents a JSON-RPC Request object based on the JSON RPC 2.0 spec.
 */
@interface MVSJSONRPCRequest : MVSJSONDataModel {
@private
	NSString *jsonrpc;
	NSString *method;
	id params;
	id id;
}
@property (nonatomic, copy) NSString *jsonrpc; ///< The Version of the jsonrpc spec. MUST-BE "2.0"
@property (nonatomic, copy) NSString *method; ///< The JSON-RPC Method name.
@property (nonatomic, copy) id params; ///< The Method's parameters.
@property (nonatomic, copy) id id; ///< The ID of the method.

/**
 * @brief Create a new JSON-RPC Request
 * @param version The JSON-RPC Version
 * @param theMethod The JSON-RPC Method
 * @param theParams The Method Parameters
 * @param methodID The method ID
 *
 * Creates a new JSON-RPC Request object with the specified arguments.
 */
- (id)initWithJSONRPC:(NSString *)version rpcMethod:(NSString *)theMethod methodParameters:(id)theParams methodID:(id)methodID;

/**
 * @brief Serialize the request.
 *
 * Serializes the request to an NSDictionary.
 */
- (NSDictionary *)serializeRequest;


@end
