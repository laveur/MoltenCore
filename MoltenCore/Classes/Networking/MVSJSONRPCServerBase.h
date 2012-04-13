//
//  MVSJSONRPCServerBase.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/26/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVSHTTPServer.h"

/**
 * @class MVSJSONRPCServerBase
 * @ingroup Networking
 * @brief Base class that implements a JSON-RPC 2.0 Server.
 * @todo Actually implement this class, utilizing MVSServerSocket and MVSHTTPServer
 * @note DO NOT USE THIS YET
 *
 * Implements a JSON-RPC 2.0 complient server.
 */
@interface MVSJSONRPCServerBase : NSObject {
@private
	NSMutableDictionary *rpcMethodTable;
	
	MVSHTTPServer *httpServer;
}

- (id)initWithPort:(UInt16)aPort;

/**
 * @brief Register a RPC method
 * @param name RPC Method name
 * @param selector The real method
 *
 * Registers \c name as an RPC Method and maps it to the selector \c selector.
 * @note \c selector must be a method within \c self.
 */
- (void)registerRPCMethodWithName:(NSString *)name andSelector:(SEL)selector;

/**
 * @brief Starts the RPC Server
 *
 * Starts the RPC Server listening on listening on the specified port.
 */
- (BOOL)start;

@end
