//
//  MVSHTTPRequstHandlerFactory.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MVSHTTPResponseHandler;
@class MVSSocketConnection;

/**
 * @class MVSHTTPResponseHandlerFactory
 * @ingroup Networking
 * @brief Factory Class for creating HTTP Repsonse Handlers
 *
 * Factory class for creating HTTP Response Handlers
 */
@interface MVSHTTPResponseHandlerFactory : NSObject {
@private
  NSMutableArray *registeredHandlers;  
}

/**
 * @brief Register a HTTP Response Handler
 * @param handlerClass The class of an MVSHTTPResponseHandler
 *
 * Registers the MVSHTTPResponseHandler sub-class as a response handler.
 */
- (void)registerHandler:(Class)handlerClass;

/**
 * @brief Determine the class that can handle a request.
 * @param aRequest The HTTP Request
 * @param requestMethod The HTTP Request Method
 * @param requestedURL The requested URL
 * @param requestHeaders The HTTP Request Headers
 * @return Class
 *
 * Returns the Objective-C Class reference for an MVSHTTPResponseHandler that can handle the specified request.
 */
- (Class)handlerClassForRequest:(CFHTTPMessageRef)aRequest requestMethod:(NSString *)requestMethod requestedURL:(NSURL *)requestedURL requestHeaders:(NSDictionary *)requestHeaders;

/**
 * @brief Create an MVSHTTPResponseHandler for the request.
 * @param aRequest The HTTP Request
 * @param connection The MVSSocketConnection that made this request.
 *
 * Creates a new repsonse handler for \c aRequest with the connection \c connection.
 */
- (MVSHTTPResponseHandler *)handlerForRequest:(CFHTTPMessageRef)aRequest connection:(MVSSocketConnection *)connection;

@end
