//
//  MVSServerSocket.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MVSSocketConnection;

extern UInt16 MVSSERVERSOCKET_PORT_AUTO_ASSSIGNED; ///< Constant for auto assigning the port.

/**
 * @class MVSServerSocket
 * @ingroup Networking
 * @brief Implements a basic server socket.
 *
 * A base class for implementing a basic server socket using CoreFoundation.
 */
@interface MVSServerSocket : NSObject<NSNetServiceDelegate> {
@private
    UInt16 port;
	CFSocketRef serverSocket;
	NSNetService *netService;
	
	// Bonjour Stuff //
	BOOL publishService;
	NSString *serviceName;
	NSString *serviceType;
	NSString *serviceDomain;
}
@property (nonatomic, assign) BOOL publishService; ///< Flag for publishing with Bonjour, YES to publish no otherwise.
@property (nonatomic, copy) NSString *serviceName; ///< The Bonjour Service name.
@property (nonatomic, copy) NSString *serviceType; ///< The Bonjour Service type.
@property (nonatomic, copy) NSString *serviceDomain; ///< The Bonjour Service Domain.

/**
 * @brief Initialize a new server socket.
 *
 * Initialize a new server socket. Port will be auto assigned, and the service will
 * not be published via Bonjour.
 */
- (id)init;

/**
 * @brief Initialize a new server socket with a specific port.
 * @param aPort The port to listen on
 *
 * Initializes a new server socket that will listen on port, \c port. The service will
 * will not be published via Bonjour.
 */
- (id)initWithPort:(UInt16)aPort;

/**
 * @brief Initializes a new server socket with a with a specific port.
 * @param aPort The port to listen on
 * @param shouldPublishService YES to publish service via Bonjour
 * @param aServiceName The Bonjour service name
 * @param aServiceDomain The Bonjour service domain
 * @param aServiceType The Bonjour service type
 *
 * Initializes a new server socket that will listen on port, \c port. If \c shouldPublish
 * is YES, then this service will be published via Bonjour with the specified settings.
 *
 * @note This is the default initializer, all other init methods call this method.
 */
- (id)initWithPort:(UInt16)aPort shouldPublisService:(BOOL)shouldPublishService withServiceName:(NSString *)aServiceName serviceDomain:(NSString *)aServiceDomain andServiceType:(NSString *)aServiceType;

/**
 * @brief Starts the server socket listening.
 *
 * Starts the server socket listening on the port, and if is configured to publish via Bonjour
 * publishes the service.
 */
- (BOOL)listen;

/**
 * @brief Closes the server socket.
 *
 * Closes the server socket, and if configured to publish via Bonjour, unpublishes the service.
 */
- (void)close;

/**
 * @brief Callback method for new connections.
 * @warning This is an abstract method failing to override this method in your subclasses
 * will result in a crash.
 *
 * Callback method for when a new connection to the server socket is made.
 */
- (void)newConnection:(MVSSocketConnection *)connection;

@end
