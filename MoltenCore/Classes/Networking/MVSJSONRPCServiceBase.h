//
//  MVSJSONRPCServiceBase.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVSRPCServiceBase.h"
#import "MVSJSONRPCRequest.h"
#import "MVSSignedJSONRPCRequest.h"

/**
 * @class MVSJSONRPCServiceBase
 * @ingroup Networking
 * @brief Base class for all JSON-RPC Style clients.
 *
 * Base class that provides the basic methods needed to build an JSON-RPC client.
 * Sub-class to implement a full fledged JSON-RPC Client class. Read the GoogleCode Wiki for
 * details on using this class.
 */
@interface MVSJSONRPCServiceBase : MVSRPCServiceBase {
@private
    
}

/**
 * @brief Generate a JSON-RPC request for the specified method
 * @param method The RPC method
 * @param dictionary The paremeter dictionary
 * @param anID The method ID for this call
 *
 * Generates a request that conforms to the JSON-RPC 2.0 Spec, with a dictionary for the parameters.
 */
- (MVSJSONRPCRequest *)requestForJSONRPCMethod:(NSString *)method paramDictionary:(NSDictionary *)dictionary methodID:(id)anID;

- (MVSSignedJSONRPCRequest *)signedRequestWithSecret:(NSString *)secret forJSONRPCMethod:(NSString *)method paramDictionary:(NSDictionary *)dictionary methodID:(id)anID;

/**
 * @brief Generate a JSON-RPC request for the specified method
 * @param method The RPC method
 * @param array The parameter array
 * @param anID The method ID for this call
 *
 * Generates a request that conforms to the JSON-RPC 2.0 Spec, with an array for the parameters.
 */
- (MVSJSONRPCRequest *)requestForJSONRPCMethod:(NSString *)method paramArray:(NSArray *)array methodID:(id)anID;

- (MVSSignedJSONRPCRequest *)signedRequestWithSecret:(NSString *)secret forJSONRPCMethod:(NSString *)method paramArray:(NSArray *)array methodID:anID;

/**
 * @brief Send a request to the server for processing.
 * @param rpcRequest A JSON-RPC Request generated with with one of the requestFORJSONRPCMethod:'s
 * @param serviceCallback A selector that gets called on self when the data returns
 * @param delegate The object that will ultimately called when all the processing is done
 * @param callback The selector to ultimately call on delegate
 *
 * Sends the request to the server to be proccessed. Upon completion \c selector, will be called on self. 
 * Place post processing in this method. selector should be in the form of:\n
 * @code
 * - (void)callback:(MVSJSONRPCResponse *)response delegate:(id)delegate callback:(SEL)callback;
 * @endcode 
 */
- (void)dispatchRequest:(MVSJSONRPCRequest *)rpcRequest callbackSelector:(SEL)serviceCallback delegate:(id<MVSWebserviceDelegate>)delegate clientCallbackSelector:(SEL)callback;

- (void)sendRequestData:(NSData *)requestData callbackSelector:(SEL)serviceCallback delegate:(id<MVSWebserviceDelegate>)delegate clientCallbackSelector:(SEL)callback;

/**
 * @brief Internal method to convert the returned data to a JSON-RPC Response object
 * @param data A string that contains a valid JSON-RPC Response
 * @param serviceCallback A selector that gets called on self when the data returns
 * @param delegate The object that will ultimately called when all the processing is done
 * @param callback The selector to ultimately call on delegate
 * @note INTERNAL METHOD -DO NOT- CALL
 *
 * Decodes the the JSON-RPC response in data, converting it to a JSON-RPC Response object.
 * Then calls \c serviceCallback passing along the JSON-RPC Response object, \c delegate, 
 * \c callback.
 */
- (void)didReceiveRPCResponseData:(NSString *)data serviceCallback:(SEL)serviceCallback delegate:(id<MVSWebserviceDelegate>)delegate callback:(SEL)callback;

@end
