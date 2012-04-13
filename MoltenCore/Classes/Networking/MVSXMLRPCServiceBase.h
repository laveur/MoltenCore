//
//  MVSXMLRPCServiceBase.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVSRPCServiceBase.h"

/**
 * @class MVSXMLRPCServiceBase
 * @ingroup Networking
 * @brief Base class for XML-RPC Clients.
 * @todo Rework class to make it more like the JSON-RPC Client class.
 * @note This class is non-functioning at this time and not fully implemented.
 *
 * Base class that provides the basic methods needed to build an XML-RPC client.
 * Sub-class to implement a full fledged XML-RPC Client class. Read the GoogleCode Wiki for
 * details on using this class.
 */
@interface MVSXMLRPCServiceBase : MVSRPCServiceBase {
@private
    
}

/**
 * @brief Generate the XML Document for the XML-RPC Method with a dictionary of key/values
 * @param method The RPC method
 * @param dictionary The parameter dictionary for the request.
 * @param anID An object to use as this method's ID
 *
 * Generates an XML Document that conforms to the XML-RPC Spec that has Key/Value pairs for
 * arguments.
 */
- (NSXMLDocument *)documentForXMLRPCMethod:(NSString *)method paramDictionary:(NSDictionary *)dictionary methodID:(id)anID;

/**
 * @brief Generate the XML Document for an XML-RPC Method with an array of parameters.
 * @param method the RPC Method
 * @param array The parameter array
 * @param anID An object to use as this method's ID
 *
 * Generates an XML Document that conforms to the XML-RPC Spec that has an array of paramters.
 */
- (NSXMLDocument *)documentForXMLNRPCMethod:(NSString *)method paramArray:(NSArray *)array methodID:(id)anID;

/**
 * @brief Sends a request to the the server for processing.
 * @param request An NSURLRequest that represents the RPC Call
 * @param selector A selector that gets called on self when the data returns
 * @param delegate The object that will ultimately called when all the processing is done
 * @param callback The selector to ultimately call on delegate
 *
 * Sends the request to the server to be proccessed. Upon completion \c selector, will be called on self. 
 * Place post processing in this method. selector should be in the form of:\n
 * @code
 * - (void)callback:(NSString *)data delegate:(id)delegate callback:(SEL)callback;
 * @endcode
 */
- (void)dispatchRequest:(NSURLRequest *)request callbackSelector:(SEL)selector delegate:(id<MVSWebserviceDelegate>)delegate clientCallbackSelector:(SEL)callback;

@end
