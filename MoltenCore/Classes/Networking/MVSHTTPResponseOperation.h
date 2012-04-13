//
//  MVSHTTPResponseOperation.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/28/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MVSHTTPResponseHandler;
@protocol MVSHTTPResponseOperationDelegate;

/**
 * @class MVSHTTPResponseOperation
 * @ingroup Networking
 * @brief NSOperation for handling HTTP Responses
 *
 * An NSOperation sub-class to handle multiple HTTP Responses at a time.
 */
@interface MVSHTTPResponseOperation : NSOperation {
@private
	MVSHTTPResponseHandler *handler;
	id<MVSHTTPResponseOperationDelegate> delegate;
    BOOL isExecuting;
	BOOL isFinished;
}

/**
 * @brief Initialize an HTTP Response Operation
 * @param aHandler The HTTP Handler Object
 * @param theDelegate The Operation's Delegate
 *
 * Initializes an HTTP Response Operation with the hanlder, \c aHandler and
 * \c theDelegate as its Delegate.
 */
- (id)initWithResponseHandler:(MVSHTTPResponseHandler *)aHandler delegate:(id<MVSHTTPResponseOperationDelegate>)theDelegate;

/**
 * @brief Retreive the handler object for this operation.
 * @return MVSHTTPResponseHandler
 *
 * Return the handler that this operation is performing.
 */
- (MVSHTTPResponseHandler *)handler;

@end

/**
 * @protocol <MVSHTTPResponseOperationDelegate>
 * @ingroup Networking
 * @brief Protocol that HTTP Operation delegate's must implement.
 *
 * Describes the protocol that all HTTPResponseOperation delegates must implement.
 */
@protocol MVSHTTPResponseOperationDelegate <NSObject>

/**
 * @brief Callback for completed operations.
 * @param operation The Operation that completed.
 *
 * This method is called every time an HTTP Response Operation completes.
 */
- (void)responseOperationDidComplete:(MVSHTTPResponseOperation *)operation;

@end
