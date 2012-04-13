//
//  MVSSocketConnection.m
//  MoltenCore
//
//  Created by Nicholas Bourey on 4/27/11.
//  Copyright 2011 Molten Visuals. All rights reserved.
//
#import <arpa/inet.h>
#import "MVSSocketConnection.h"

#pragma mark - Forward Declarations
static void inputStreamEventProxy(CFReadStreamRef stream, CFStreamEventType eventType, void *info);
static void outputStreamEventProxy(CFWriteStreamRef stream, CFStreamEventType eventType, void *info);

@interface MVSSocketConnection (Private)

- (BOOL)setupStreams;
- (void)writeToStream;
- (void)readFromStream;

- (void)handleInputStreamEvent:(CFStreamEventType)eventType;
- (void)handleOuputStreamEvent:(CFStreamEventType)eventType;

@end

@implementation MVSSocketConnection

#pragma mark - Synthesized Properties
@synthesize delegate;

#pragma mark - Initialization Methods
- (id)initWithHostAddress:(NSString *)aHost andPort:(UInt16)aPort {
	if((self = [super init])) {
		self->host = [aHost retain];
		self->port = aPort;
	}
	
	return self;
}

- (id)initWithNativeSocket:(CFSocketNativeHandle)aNativeSocket {
	if((self = [super init])) {
		self->connectedSocketHandle = aNativeSocket;
	}
	
	return self;
}

#pragma mark - Inherited
- (void)dealloc {
	[self close];
	[super dealloc];
}

#pragma mark - Instance Methods
- (BOOL)open {
	if(self->host != nil) {
		CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)self->host, self->port, &self->inputStream, &self->outputStream);
		
		if((self->inputStream == nil) || (self->outputStream == nil)) {
			return NO;
		}
		
		return [self setupStreams];
	} else if(self->connectedSocketHandle != -1) {
		CFStreamCreatePairWithSocket(kCFAllocatorDefault, self->connectedSocketHandle, &self->inputStream, &self->outputStream);
		
		if((self->inputStream == nil) || (self->outputStream == nil)) {
			return NO;
		}
		
		return [self setupStreams];
	}
	
	return NO;
}

- (void)close {
	if(self->inputStream != nil) {
		CFReadStreamUnscheduleFromRunLoop(self->inputStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		CFReadStreamClose(self->inputStream);
		CFRelease(self->inputStream);
		self->inputStreamOpened = NO;
		self->inputStream = nil;
	}
	
	if(self->outputStream != nil) {
		CFWriteStreamUnscheduleFromRunLoop(self->outputStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		CFWriteStreamClose(self->outputStream);
		CFRelease(self->outputStream);
		self->outputStreamOpened = NO;
		self->outputStream = nil;
	}
	
	[self->inputDataBuffer release];
	self->inputDataBuffer = nil;
	
	[self->outputDataBuffer release];
	self->outputDataBuffer = nil;
	
	if(self.delegate != nil) {
		[self.delegate socketConnectionDidDisconnect:self];
	}
}

- (BOOL)hasSpaceAvailable {
	return CFWriteStreamCanAcceptBytes(self->outputStream);
}

- (void)sendData:(NSData *)data {
	@synchronized(self->inputDataBuffer) {
		[self->outputDataBuffer appendData:data];
	
		[self writeToStream];
	}
}

- (NSUInteger)bytesAvailable {
	@synchronized(self->inputDataBuffer) {
		return [self->inputDataBuffer length];
	}
}

- (NSData *)readDataOfLength:(NSUInteger)length {
	NSRange range;
	NSData *retData;
	
	if(length > [self->inputDataBuffer length]) {
		length = [self->inputDataBuffer length];
	}
	
	@synchronized(self->inputDataBuffer) {
		range = NSMakeRange(0, length);
		retData = [self->inputDataBuffer subdataWithRange:range];
	
		[self->inputDataBuffer replaceBytesInRange:range withBytes:nil length:0];
	}
	
	return retData;
}

#pragma mark - Private Methods
- (BOOL)setupStreams {
	BOOL isOpen = NO, isError = NO;
	
	self->inputDataBuffer = [[NSMutableData alloc] init];
	self->outputDataBuffer = [[NSMutableData alloc] init];
	
	CFReadStreamSetProperty(self->inputStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	CFWriteStreamSetProperty(self->outputStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
	
	if(!CFReadStreamOpen(self->inputStream) || !CFWriteStreamOpen(self->outputStream)) {
		[self close];
		return NO;
	}
	
	while((isError == NO) && (isOpen == NO)) {
		NSError *error = nil;
		CFStreamStatus inputStatus = CFReadStreamGetStatus(self->inputStream);
		CFStreamStatus outputStatus = CFWriteStreamGetStatus(self->outputStream);
		
		if(inputStatus == kCFStreamStatusOpen) {
			self->inputStreamOpened = YES;
		}
		
		if(outputStatus == kCFStreamStatusOpen) {
			self->outputStreamOpened = YES;
		}
		
		if(inputStatus == kCFStreamStatusError) {
			error = (NSError *)CFReadStreamCopyError(self->inputStream);
			NSLog(@"[MVSSocketConnection open]: %@", error);
		} else if(outputStatus == kCFStreamStatusError) {
			error = (NSError *)CFWriteStreamCopyError(self->outputStream);
			NSLog(@"[MVSSocketConnection open]: %@", error);
		}
		
		if(error != nil) {
			[error release];
		}
		
		isOpen = ((inputStatus == kCFStreamStatusOpen) && (outputStatus == kCFStreamStatusOpen));
		isError = ((inputStatus == kCFStreamStatusError) || (outputStatus == kCFStreamStatusError));
	}
	
	if(isError) {
		[self close];
		return NO;
	}
	
	if(isOpen) {
		CFStreamClientContext context = {0, self, nil, nil, nil};
		CFOptionFlags registeredEvents = kCFStreamEventHasBytesAvailable | kCFStreamEventCanAcceptBytes | kCFStreamEventEndEncountered | kCFStreamEventErrorOccurred;
		
		CFReadStreamSetClient(self->inputStream, registeredEvents, inputStreamEventProxy, &context);
		CFWriteStreamSetClient(self->outputStream, registeredEvents, outputStreamEventProxy, &context);
		
		
		CFReadStreamScheduleWithRunLoop(self->inputStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		CFWriteStreamScheduleWithRunLoop(self->outputStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		
		return YES;
	}
	
	return NO;
}

- (void)writeToStream {
	CFIndex bytesWritten;
	
	if(!self->inputStream || !self->outputStream) {
		return;
	}
	
	if([self->outputDataBuffer length] == 0) {
		return;
	}
	
	if(![self hasSpaceAvailable]) {
		return;
	}
	@synchronized(self->outputDataBuffer) {
		while([self->outputDataBuffer length] > 0) {
			bytesWritten = CFWriteStreamWrite(self->outputStream, [self->outputDataBuffer bytes], [self->outputDataBuffer length]);
			
			if(bytesWritten == -1) {
				[self close];
				return;
			}
			
			[self->outputDataBuffer replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:nil length:0];
		}
	}
}

- (void)readFromStream {
	UInt8 buf[1024];
	CFIndex bytesRead = 0;
	if(!self->inputStream || !self->outputStream) {
		return;
	}
	
	@synchronized(self->inputDataBuffer) {
		while(CFReadStreamHasBytesAvailable(self->inputStream)) {
			bytesRead = CFReadStreamRead(self->inputStream, buf, sizeof(buf));
			
			if(bytesRead <= 0) {
				[self close];
				return;
			}
			
			[self->inputDataBuffer appendBytes:buf length:bytesRead];
		}
	}
	
	if([self bytesAvailable] > 0) {
		[self.delegate socketConnectionHasDataAvailable:self];
	}
}

- (void)handleInputStreamEvent:(CFStreamEventType)eventType {
	NSError *error = nil;
	switch (eventType) {
		case kCFStreamEventHasBytesAvailable:
			[self readFromStream];
			break;
		case kCFStreamEventEndEncountered:
			[self close];
			break;
		case kCFStreamEventErrorOccurred:
			error = (NSError *)CFReadStreamCopyError(self->inputStream);
			NSLog(@"[MVSSocketConnection handleInputStreamEvent]: %@", error);
			[self close];
			break;
		default:
			break;
	}
	
	if(error != nil) {
		[error release];
	}
}

- (void)handleOuputStreamEvent:(CFStreamEventType)eventType {
	NSError *error = nil;
	switch (eventType) {
		case kCFStreamEventCanAcceptBytes:
			if([self->outputDataBuffer length]) {
				[self writeToStream];
			}
			break;
		case kCFStreamEventEndEncountered:
			[self close];
			break;
		case kCFStreamEventErrorOccurred:
			error = (NSError *)CFWriteStreamCopyError(self->outputStream);
			NSLog(@"[MVSSocketConnection handleOuputStreamEvent]: %@", error);
			[self close];
			break;
		default:
			break;
	}
	
	if(error != nil) {
		[error release];
	}
}

@end

#pragma mark - CFStream Callbacks
static void inputStreamEventProxy(CFReadStreamRef stream, CFStreamEventType eventType, void *info) {
	MVSSocketConnection *connection = (MVSSocketConnection *)info;
	[connection handleInputStreamEvent:eventType];
}

static void outputStreamEventProxy(CFWriteStreamRef stream, CFStreamEventType eventType, void *info) {
	MVSSocketConnection *connection = (MVSSocketConnection *)info;
	[connection handleOuputStreamEvent:eventType];
}
