//
//  MVSSocketConnection.h
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MVSSocketConnectionDelegate;

/**
 * @class MVSSocketConnection
 * @ingroup Networking
 * @brief A class that represents a raw socket to a server.
 * @todo Add support for getting errors.
 *
 * Represents a network socket to a server. Can be used to open a bi-directional
 * socket to a server.
 */
@interface MVSSocketConnection : NSObject {
@private
	id<MVSSocketConnectionDelegate> delegate;
    NSString *host;
	UInt16 port;
	
	CFSocketNativeHandle connectedSocketHandle;
	
	// IO
	CFReadStreamRef inputStream;
	CFWriteStreamRef outputStream;
	NSMutableData *inputDataBuffer;
	NSMutableData *outputDataBuffer;
	BOOL inputStreamOpened;
	BOOL outputStreamOpened;
}
@property (nonatomic, assign) id<MVSSocketConnectionDelegate> delegate; ///< Delegate Object, Must Implement MVSSocketConnectionDelegate.

/**
 * @brief Initialize a Server Connection
 * @param aHost The hostname of the server you wish to connect to
 * @param aPort The port to connect to
 *
 * Initializes a new Server connection with the specified host and port.
 */
- (id)initWithHostAddress:(NSString *)aHost andPort:(UInt16)aPort;

/**
 * @brief Initialize a Server Connection with a native socket.
 * @param aNativeSocket The CoreFoundation Native socket
 *
 * Initializes a new Server Connection with an existing native socket.
 */
- (id)initWithNativeSocket:(CFSocketNativeHandle)aNativeSocket;

/**
 * @brief Open a connection to the server.
 * @return BOOL
 *
 * Opens the connection to the server, returning YES on success or NO on an error.
 */
- (BOOL)open;

/**
 * @brief Close a connection
 *
 * Closes the connection to the server.
 */
- (void)close;

/**
 * @brief Send Data to the socket.
 * @param data The data to write to the socket.
 *
 * Places the data into a buffer and attempts to send it over the socket.
 */
- (void)sendData:(NSData *)data;

/**
 * @brief Determine the number of bytes available for reading.
 * @return NSUInteger
 *
 * Returns the number of bytes available from the internal buffer that are ready for reading.
 */
- (NSUInteger)bytesAvailable;

/**
 * @brief Read data from the buffer.
 * @param length The length of data to read.
 * @return NSData
 *
 * Returns an NSData object of data from the buffer.
 * @note The size of the returned object maybe <= the \c length.
 */
- (NSData *)readDataOfLength:(NSUInteger)length;

/**
 * @brief Dertermine if the socket has space for writing.
 * @return BOOL
 *
 * Returns YES if there is space available for writing, NO otherwise.
 */
- (BOOL)hasSpaceAvailable;

@end

/**
 * @protocol <MVSSocketConnectionDelegate>
 * @ingroup Networking
 * @brief Protocol for MVSSocketConnection delegate objects.
 *
 * The protocol that all delegates of MVSSocketConnection must implement.
 */
@protocol MVSSocketConnectionDelegate <NSObject>

/**
 * @brief Called when there is data in the buffer for reading.
 * @param connection The connection that has data available.
 *
 * Called every time there is data for reading on a connection.
 */
- (void)socketConnectionHasDataAvailable:(MVSSocketConnection *)connection;

- (void)socketConnectionDidDisconnect:(MVSSocketConnection *)connection;

@end
