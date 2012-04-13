//
//  MVSHTTPServer.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVSServerSocket.h"
#import "MVSSocketConnection.h"
#import "MVSHTTPResponseOperation.h"

@class MVSHTTPResponseHandlerFactory;

extern UInt16 MVS_DEFAULT_HTTP_PORT; ///< Define for The Default Port to listen on - 8080

/**
 * @class MVSHTTPServer
 * @ingroup Networking
 * @brief Basic HTTP Server
 * @note This class hasn't been well tested and may have significant bugs or performance issues.
 *
 * Implements a basic class for an HTTP Server, and publishes it via Bonjour.
 */
@interface MVSHTTPServer : MVSServerSocket<MVSSocketConnectionDelegate, MVSHTTPResponseOperationDelegate> {
@private
    CFMutableDictionaryRef incommingConnections;
	MVSHTTPResponseHandlerFactory *handlerFactory;
	NSOperationQueue *responseOperations;
}
@property (nonatomic, retain) MVSHTTPResponseHandlerFactory *handlerFactory; ///< Factory class for response handlers.



@end
