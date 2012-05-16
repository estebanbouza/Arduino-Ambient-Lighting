//
//  AppDelegate.m
//  arduinolamp
//
//  Created by Esteban on 03/12/11.
//  Copyright (c) 2011 Filloadev. All rights reserved.
//

#import "AppDelegate.h"
#import <unistd.h>
#import <stdio.h>
#import "Constants.h"

#include <stdio.h>    /* Standard input/output definitions */
#include <stdlib.h> 
#include <stdint.h>   /* Standard types */
#include <string.h>   /* String function definitions */
#include <unistd.h>   /* UNIX standard function definitions */
#include <fcntl.h>    /* File control definitions */
#include <errno.h>    /* Error number definitions */
#include <termios.h>  /* POSIX terminal control definitions */
#include <sys/ioctl.h>
#include <getopt.h>


#define kARDUINO_FILE @"/dev/tty.usbserial-A6004l98"
#define kSERVICE_PROTOCOL_NAME @"ardlights"

@implementation AppDelegate

@synthesize window = _window;
@synthesize sldProgressive;
@synthesize server = _server;
@synthesize txtBlink;
@synthesize ardInterface = _ardInterface;

#pragma mark C stuff



#pragma mark - Boring stuff

- (IBAction) buttonOFFPressed:(id)sender {
    NSLog(@"Button OFF pressed");
    [self.ardInterface switchOff];

}

- (IBAction) buttonONPressed:(id)sender {
    NSLog(@"Button ON pressed");
    [self.ardInterface switchOn];
}

- (IBAction)buttonUpPressed:(id)sender {
    [self.sldProgressive setIntValue:[self.sldProgressive intValue] + 1];
    [self sldProgressiveChanged:self];
}

- (IBAction)buttonDownPressed:(id)sender {
    [self.sldProgressive setIntValue:[self.sldProgressive intValue] - 1];
    [self sldProgressiveChanged:self];
}

- (IBAction)btnPartyPressed:(id)sender {
    float sleep = 0.02;
    for (int i = 0; i < 12; i++) {
        [self.ardInterface switchOff];
        [NSThread sleepForTimeInterval:sleep];
        [self.ardInterface switchOn];
        [NSThread sleepForTimeInterval:sleep];
    }
}

- (IBAction)sldProgressiveChanged:(id)sender {
    int val = [self.sldProgressive intValue];
    NSLog(@"Progressive sld: %d", val);
    
    [self.ardInterface progressiveTo:val];
}

- (IBAction)btnBlinkPressed:(id)sender {
    int times = [self.txtBlink.stringValue intValue];
    NSLog(@"Blinking %d times", times);
    [self.ardInterface blinkTimes:times];
}

#pragma mark - App Delegate Stuff

- (void)dealloc {
    [super dealloc];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.ardInterface = [[ARDInterface alloc] init];
    [self.ardInterface openArduino:kARDUINO_FILE];
    
    self.server = [[Server alloc] initWithProtocol:kSERVICE_PROTOCOL_NAME];
    self.server.delegate = self;
    NSError *error = nil;
    [self.server start:&error];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

#pragma mark - Net message handling

/** Receive net message and process it */
- (void)handleMessage:(NSString *)msg {
    NSString *cmd;
    NSInteger param;
    
    NSArray *chunks = [msg componentsSeparatedByString:@"|"];
    
    NSInteger nchunks = [chunks count];
    
    if (nchunks == 0) {
        return;
    }
    if (nchunks == 2) {
        cmd = [chunks objectAtIndex:0];
        param = [[chunks objectAtIndex:1] intValue];
    }
    
    if ([cmd isEqualToString:kHDRAnalog]) {
        [self.ardInterface setIntensity:param];
    } else if ([cmd isEqualToString:kHDRProgressive]) {
        [self.ardInterface progressiveTo:param];
    } else if ([cmd isEqualToString:kHDRBlink]) {
        [self.ardInterface blinkTimes:param];
    } else if ([cmd isEqualToString:kHDRSwitch]) {
        if (param == YES) {
            [self.ardInterface switchOn];
        } else if (param == NO) {
            [self.ardInterface switchOff];
        }
    }
}

#pragma mark Server Delegate Methods

- (void)serverRemoteConnectionComplete:(Server *)server {
    NSLog(@"Server Started");
    // this is called when the remote side finishes joining with the socket as
    // notification that the other side has made its connection with this side
}

- (void)serverStopped:(Server *)server {
    NSLog(@"Server stopped");
}

- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict {
    NSLog(@"Server did not start %@", errorDict);
}

- (void)server:(Server *)server didAcceptData:(NSData *)data {
    NSLog(@"Server did accept data %@", data);
    NSString *message = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if(nil != message || [message length] > 0) {
        [self handleMessage:message];
    } else {

    }
}

- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict {
    NSLog(@"Server lost connection %@", errorDict);
}

- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more {

}

- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more {

}


@end
