//
//  MVSHTTPResponseHandler.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVSSocketConnection.h"

/**
 * @class MVSHTTPResponseHandler
 * @ingroup Networking
 * @brief Base class for all HTTP Response Handlers
 * @todo Refactor and clean up the code a bit.
 *
 * Base class for all HTTP Response Handlers.
 * @note This class also acts as a catch all for
 * for when a there is no handler for a response.
 */
@interface MVSHTTPResponseHandler : NSObject {
@private
    CFHTTPMessageRef request; ///< The HTTP Request
	NSString *requestMethod; ///< The HTTP Request Method
	NSURL *requestURL; ///< The Requested URL
	NSDictionary *requestHeaders; ///< The HTTP Headers
	MVSSocketConnection *connection;
}
@property (nonatomic, retain) MVSSocketConnection *connection; ///< The connection this response is responding on.
@property (nonatomic, readonly) NSURL *requestURL; ///< The requested URL.

/**
 * @brief The Handlers Priority
 * @return NSUInteger
 * @note OVERRIDE THIS METHOD!
 *
 * Returns the priority for this handler. Higher values means that this handler will have a higher priority.
 */
+ (NSUInteger)priority;

/**
 * @brief Determine if this handler can respond to a request.
 * @note OVERRIDE THIS METHOD!
 * @param aRequest The HTTP Request
 * @param requestMethod The HTTP Request Method
 * @param requestURL The URL of this HTTP Request
 * @param requestHeaderFields The HTTP Headers for this request
 * @return BOOL
 *
 * Returns YES if this Response Handler can handle the request.
 */
+ (BOOL)canHandleRequest:(CFHTTPMessageRef)aRequest method:(NSString *)requestMethod url:(NSURL *)requestURL headerFields:(NSDictionary *)requestHeaderFields;

/**
 * @brief Initialize a response handler
 * @param aRequest The HTTP Request
 * @param aRequestMethod The HTTP Request Method
 * @param requestedURL The requested URL
 * @param theRequestHeaders The HTTP Headers for this request
 * @param theConnection The Socket Connection that received this request.
 *
 * Initializes a new response handler for the specified request.
 */
- (id)initWithRequest:(CFHTTPMessageRef)aRequest requestMethod:(NSString *)aRequestMethod requestedURL:(NSURL *)requestedURL requestHeaders:(NSDictionary *)theRequestHeaders connection:(MVSSocketConnection *)theConnection;

/**
 * @brief Handle the requst
 *
 * Actually handles the response and send it to the connection.
 */
- (void)handleResponse;

@end
