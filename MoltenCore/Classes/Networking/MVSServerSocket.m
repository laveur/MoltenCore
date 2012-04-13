//
//  MVSServerSocket.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//

#pragma mark - Includes
#import <sys/socket.h>
#import <netinet/in.h>
#import <unistd.h>

#import "MVSServerSocket.h"
#import "MVSSocketConnection.h"

UInt16 MVSSERVERSOCKET_PORT_AUTO_ASSSIGNED = -1;

#pragma mark - Forward Declarations
static void serverSocketAcceptCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

#pragma mark - Private Interface
@interface MVSServerSocket (Private)

- (BOOL)createServerSocket;
- (void)closeServerSocket;
- (BOOL)publisNetService;
- (void)unpublishNetService;
- (void)handleNewNativeSocket:(CFSocketNativeHandle)nativeSocketHandle;

@end

@implementation MVSServerSocket

#pragma mark - Synthesized Properties
@synthesize publishService;
@synthesize serviceName;
@synthesize serviceType;
@synthesize serviceDomain;

#pragma mark - Initialization Methods
- (id)init {
	return [self initWithPort:MVSSERVERSOCKET_PORT_AUTO_ASSSIGNED];
}

- (id)initWithPort:(UInt16)aPort {
	return [self initWithPort:aPort shouldPublisService:NO withServiceName:nil serviceDomain:nil andServiceType:nil];
}

- (id)initWithPort:(UInt16)aPort shouldPublisService:(BOOL)shouldPublisService withServiceName:(NSString *)aServiceName serviceDomain:(NSString *)aServiceDomain andServiceType:(NSString *)aServiceType {
    if((self = [super init])) {
        self->port = aPort;
		self.publishService = shouldPublisService;
		self.serviceName = aServiceName;
		self.serviceDomain = aServiceDomain;
		self.serviceType = aServiceType;
    }
    
    return self;
}

#pragma mark - Inhertied
- (void)dealloc {
    [super dealloc];
}

#pragma mark - Instance Methods
- (BOOL)listen {
	if([self createServerSocket] == NO) {
		return NO;
	}
	
	if(self.publishService) {
		if([self publisNetService] == NO) {
			[self closeServerSocket];
			return NO;
		}
	}
	
	return YES;
}

- (void)close {
	[self closeServerSocket];
	
	if(self.publishService) {
		[self unpublishNetService];
	}
}

- (void)newConnection:(MVSSocketConnection *)connection {
	NSLog(@"Oh Noes! It appears you forgot to override newConnection: in your subclass... You're now gonna crash!");
	[self doesNotRecognizeSelector:_cmd];
}

#pragma mark - Private Methods
- (BOOL)createServerSocket {
	CFSocketContext socketContext = {0, self, nil, nil, nil};
	NSInteger existingValue = 1;
	UInt16 actualPort;
	struct sockaddr_in socketAddress, socketAddressActual;
	NSData *socketAddressData;
	NSData *socketAddressActualData;
	
	// Create Our Socket
	self->serverSocket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)&serverSocketAcceptCallback, &socketContext);
	
	if(self->serverSocket == nil) {
		return NO;
	}
	
	// Make sure this connection gets reused
	setsockopt(CFSocketGetNative(self->serverSocket), SOL_SOCKET, SO_REUSEADDR, (void *)&existingValue, sizeof(existingValue));
	
	// Bind our socket to an end point
	memset(&socketAddress, 0, sizeof(socketAddress));
	socketAddress.sin_len = sizeof(socketAddress);
	socketAddress.sin_family = AF_INET;
	
	// Either let the kernel assign a port or use the one provided when we where inited.
	if(self->port == MVSSERVERSOCKET_PORT_AUTO_ASSSIGNED) {
		socketAddress.sin_port = 0;
	} else {
		socketAddress.sin_port = htons(self->port);
	}
	
	socketAddress.sin_addr.s_addr = htonl(INADDR_ANY);
	
	// Convert to an NSData object
	socketAddressData = [NSData dataWithBytes:&socketAddress length:sizeof(socketAddress)];
	
	// Bind our socket to the address
	if(CFSocketSetAddress(self->serverSocket, (CFDataRef)socketAddressData) != kCFSocketSuccess) {
		if(self->serverSocket != nil) {
			CFRelease(self->serverSocket);
			self->serverSocket = nil;
		}
		
		return NO;
	}
	
	// Figure out our real port
	socketAddressActualData = [(NSData *)CFSocketCopyAddress(self->serverSocket) autorelease];
	
	memcpy(&socketAddressActual, [socketAddressActualData bytes], [socketAddressActualData length]);
	
	actualPort = ntohs(socketAddressActual.sin_port);
	
	if(actualPort != self->port) {
		self->port = actualPort;
	}
	
	// Finally add the socket to our run loop
	CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
	CFRunLoopSourceRef socketRunLoopSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, self->serverSocket, 0);
	CFRunLoopAddSource(currentRunLoop, socketRunLoopSource, kCFRunLoopCommonModes);
	CFRelease(socketRunLoopSource);
	
	return YES;
}

- (void)closeServerSocket {
	if(self->serverSocket != nil) {
		CFSocketInvalidate(self->serverSocket);
		CFRelease(self->serverSocket);
		self->serverSocket = nil;
	}
}

- (BOOL)publisNetService {
	self->netService = [[NSNetService alloc] initWithDomain:self.serviceDomain type:self.serviceType name:self.serviceName port:self->port];
	
	if(self->netService == nil) {
		return NO;
	}
	
	[self->netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[self->netService setDelegate:self];
	[self->netService publish];
	
	return YES;
}

- (void)unpublishNetService {
	if(self->netService != nil) {
		[self->netService stop];
		[self->netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
		[self->netService release];
		self->netService = nil;
	}
}

- (void)handleNewNativeSocket:(CFSocketNativeHandle)nativeSocketHandle {
	MVSSocketConnection *connection = [[[MVSSocketConnection alloc] initWithNativeSocket:nativeSocketHandle] autorelease];
	
	if(connection == nil) {
		close(nativeSocketHandle);
		return;
	}
	
	[self newConnection:connection];
}

#pragma mark - NSNetServiceDelegate Methods
- (void)netService:(NSNetService*)sender didNotPublish:(NSDictionary*)errorDict {
	if(sender != self->netService) {
		return;
	}
	
	[self closeServerSocket];
	[self unpublishNetService];
	NSLog(@"Failed to publish service via Bonjour (duplicate server name?)");
}

@end

#pragma mark - Static Functions
static void serverSocketAcceptCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
	MVSServerSocket *serverSocket = (MVSServerSocket *)info;
	
	if(type != kCFSocketAcceptCallBack) {
		return;
	}
	
	CFSocketNativeHandle nativeSocket = *(CFSocketNativeHandle *)data;
	
	[serverSocket handleNewNativeSocket:nativeSocket];
}
