//
//  MVSWebserviceBase.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/24/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MVSWebserviceOperation;

@protocol MVSWebserviceDelegate;

/**
 * @class MVSWebserviceBase
 * @ingroup Networking
 * @brief Base class for all webservices.
 *
 * Contains all the methods that all other webservices classes need to work.
 */
@interface MVSWebserviceBase : NSObject {
@private
    NSString *baseURL;
	BOOL asynchronous;
	NSOperationQueue *aSyncQueue;
}
@property (readonly) NSString *baseURL; ///< The baseURL for the webservice.
@property (assign, nonatomic) BOOL asynchronous; ///< Asynchronious flag. YES to operate asynchrounsly, NO for synchronous calls. YES by default.

/**
 * @brief Initialize a Webservice
 * @param aBaseURL The base URL for the webservice
 *
 * Initializes a webservice with the base URL \c baseURL.
 */
- (id)initWithBaseURL:(NSString *)aBaseURL;

/**
 * @brief Add a webservice operation to the queue.
 * @param op The webservice operation.
 *
 * Adds the the webservice operation, \c op, to the operation Queue.
 * This method is used internally, and only when \c asynchronous is YES.
 */
- (void)addWebserviceOperation:(MVSWebserviceOperation *)op;

/**
 * @brief Prepare an NSInvocation for an object and a selector.
 * @param object The object to prepare the invocation for
 * @param selector The selector the NSInvocation reperesents
 * @return NSInvocation
 *
 * Prepare an NSInvcation for an object and a selector the object performs.
 * Used internally for handling callbacks/delegate methods.
 */
- (NSInvocation *)prepareInvocationForObject:(id)object andSelector:(SEL)selector;

/**
 * @brief Dispatches a return call the client.
 * @param client The webservice delegate object for this call
 * @param selector The selector that you are calling back
 * @param firstParam The first parameter to the callback, must be nil terminated.
 *
 * Calls \c selector on \c client with the list of arguments. The params must be nil terminated.
 */
- (void)dispatchClient:(id<MVSWebserviceDelegate>)client callbackSelector:(SEL)selector params:(id)firstParam, ...;

/**
 * @brief URL-Encode a string.
 * @param str The string to URL-Encode
 * @return NSString
 *
 * URL-Encode \c str.
 */
- (NSString *)escapeString:(NSString *)str;

@end

@protocol MVSWebserviceDelegate <NSObject>

- (void)serviceDidReceiveError:(MVSWebserviceBase *)service error:(NSError *)error;

@end