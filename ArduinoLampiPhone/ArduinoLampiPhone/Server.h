//
//  Server.h
//
//  Licensed under the Apache 2.0 license
//  http://apache.org/licenses/LICENSE-2.0
//
//  Created by Bill Dudney on 2/20/09.
//  Copyright 2009 Gala Factory Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// forward declaration so protpcol and be at the top of the file
@class Server;
@class ServerBrowser;

@protocol ServerDelegate <NSObject>

// sent when both sides of the connection are ready to go
- (void)serverRemoteConnectionComplete:(Server *)server;
// called when the server is finished stopping
- (void)serverStopped:(Server *)server;
// called when something goes wrong in the starup
- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict;
// called when data gets here from the remote side of the server
- (void)server:(Server *)server didAcceptData:(NSData *)data;
// called when the connection to the remote side is lost
- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict;
// called when a new service comes on line
- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more;
// called when a service goes off line
- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more;

@end

typedef enum {
    kServerCouldNotBindToIPv4Address = 1,
    kServerCouldNotBindToIPv6Address = 2,
    kServerNoSocketsAvailable = 3,
    kServerNoSpaceOnOutputStream = 4,
    kServerOutputStreamReachedCapacity = 5 // should be able to try again 'later'
} ServerErrorCode;

@interface Server : NSObject <NSNetServiceDelegate, NSStreamDelegate, NSNetServiceBrowserDelegate>
{
    NSString *_domain; // the bonjour domain
    NSString *_protocol; // the bonjour protocol
    NSString *_name; // the bonjour name
    uint16_t _port; // the port, reterieved from the OS
    uint8_t _payloadSize; // the size you expect to be sending
    CFSocketRef _socket; // the socket that data is sent over
    
    NSNetService *_netService; // bonjour net service used to publish this server
    
	NSInputStream *_inputStream; // stream that this side reads from
	NSOutputStream *_outputStream; // stream that this side writes two
	BOOL _inputStreamReady; // when input stream is ready to read from this turns to YES
	BOOL _outputStreamReady; // when output stream is ready to read from this turns to YES
    BOOL _outputStreamHasSpace; // when there is space in the output stream this is YES
    
    id<ServerDelegate> _delegate; // see docs on delegate protocol
    
	NSNetServiceBrowser *_browser; // the bonjour service browser
    NSNetService *_currentlyResolvingService; // the service we are currently trying to resolve
    NSNetService *_localService; // the local service that we get back from bonjour
}

// if you want the default domain and name use this method (recommended)
- (id)initWithProtocol:(NSString *)protocol;
// if you want to specify the domain and name as well as protocol use this method
// if you persistently store the name you must grab it back from the server
// after startup is complete
- (id)initWithDomainName:(NSString *)domain
                protocol:(NSString *)protocol
                    name:(NSString *)name;

- (BOOL)start:(NSError **)error;
- (BOOL)sendData:(NSData *)data error:(NSError **)error;
- (void)connectToRemoteService:(NSNetService *)selectedService;
- (void)stop;
- (void)stopBrowser;

@property(nonatomic, assign) id<ServerDelegate> delegate;
@property(nonatomic, assign) uint8_t payloadSize; // how big of a buffer to send on

@end
