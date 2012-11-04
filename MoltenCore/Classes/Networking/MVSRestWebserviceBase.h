//
//  MVSRestWebserviceBase.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "MVSWebserviceBase.h"

/**
 * @class MVSRestWebserviceBase
 * @ingroup Networking
 * @brief Base class for REST based Wesbervices
 *
 * A base class for creating REST based webservices.
 */
@interface MVSRestWebserviceBase : MVSWebserviceBase {
@private
    
}

/**
 * @brief Generate a  NSURLRequest for a method.
 * @param method The REST Method
 * @return NSURLRequest
 * 
 * Generate an NSURLRequest for the REST method, \c method.
 */
- (NSURLRequest *)urlRequestForMethod:(NSString *)method;

/**
 * @brief Generate a  NSURLRequest, using GET, for a REST method, that has parameters.
 * @param method The REST Method
 * @param params The Parameters to the call
 * @return NSURLRequest
 *
 * Generate an NSURLRequest, using GET, for the REST Method, \c method. \c params, is a dictionrary
 * of key=value's to pass in as a query string.
 */
- (NSURLRequest *)urlRequestForMethod:(NSString *)method parameters:(NSDictionary *)params;

/**
 * @brief Generate a  NSURLRequest, using PUT, for a REST method, that has data.
 * @param method The REST Method
 * @param data The Parameters to the call
 * @return NSURLRequest
 *
 * Generate an NSURLRequest, using PUT, for the REST Method, \c method. \c data is the HTTP bod.
 */
- (NSURLRequest *)urlPUTRequestForMethod:(NSString *)method PUTData:(NSData *)data;

/**
 * @brief Generate a  NSURLRequest, using POST, for a REST method, that has data.
 * @param method The REST Method
 * @param params The Parameters to the call
 * @return NSURLRequest
 *
 * Generate an NSURLRequest, using POST, for the REST Method, \c method. \c data is the HTTP body.
 */
- (NSURLRequest *)urlPOSTRequestForMethod:(NSString *)method POSTData:(NSData *)data;

/**
 * @brief Dispatch a REST request to the server.
 * @param request An NSURLRequest generated by a call to one of urlRequestForMethod: calls
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
- (void)dispatchRequest:(NSURLRequest *)request callbackSelector:(SEL)selector delegate:(id)delegate clientCallbackSelector:(SEL)callback;
@end