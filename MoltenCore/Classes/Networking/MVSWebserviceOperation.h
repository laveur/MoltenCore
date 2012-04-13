//
//  MVSWebserviceOperation.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVSWebserviceBase.h"

/**
 * @class MVSWebserviceOperation
 * @ingroup Networking
 * @brief A subclass of NSOperation for Webservice calls.
 *
 * An NSOperation subclass for webservice calls. Used internally by all Webservice classes
 * to implement Asynchronous calls to webservice methods. Increases overall performance of
 * the webservice calls allowing multiple calls to be made at the same time.
 */
@interface MVSWebserviceOperation : NSOperation {
@private
	NSURLRequest *request;
	MVSWebserviceBase *service;
	SEL selector;
	SEL serviceCallback;
	id<MVSWebserviceDelegate> client;
	SEL callbackSelector;
	
	NSMutableData *data;
	NSURLConnection *connection;
	
	// State //
	BOOL isExecuting;
	BOOL isFinished;
}

/**
 * @brief Intialize a Webservice Operation
 * @param aRequest An NSURLRequest for this operation
 * @param service The service that is making this request
 * @param aSelector Service callback selector
 * @param client The delegate object for this call
 * @param callback The delegate callback selector
 *
 * Create a new Webservice Operation for \c aRequest that will call \c selector on \c service when finished.\n
 * Passes \c client and \c callback are passed along to \c selector as parameters.
 */
- (id)initWithURLRequest:(NSURLRequest *)aRequest service:(MVSWebserviceBase *)service selector:(SEL)aSelector client:(id<MVSWebserviceDelegate>)client callbackSelector:(SEL)callback;

/**
 * @brief Initialize a Webservice Operation
 * @param aRequest An NSURLRequest for this operation
 * @param aService The service that is making this request
 * @param aSelector In-between service callback
 * @param aServiceCallback Service callback selector
 * @param aClient The delegate object for this call
 * @param callback The delegate callback selector
 *
 * Create a new Webservice Operation for \c aRequest that will call \c selector on \c service when finished.\n
 * Passes \c client, \c aServiceCallback, \c client and \c callback along to \c selector as parameters.
 */
- (id)initWithURLRequest:(NSURLRequest *)aRequest service:(MVSWebserviceBase *)aService selector:(SEL)aSelector serviceCallback:(SEL)aServiceCallback client:(id<MVSWebserviceDelegate>)aClient callbackSelector:(SEL)callback;
@end
