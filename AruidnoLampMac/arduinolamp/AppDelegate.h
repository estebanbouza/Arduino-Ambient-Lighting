//
//  AppDelegate.h
//  arduinolamp
//
//  Created by Esteban on 03/12/11.
//  Copyright (c) 2011 Filloadev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Server.h"
#import "ARDInterface.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, ServerDelegate> {
    int fd;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSSlider *sldProgressive;
@property (assign) IBOutlet NSTextField *txtBlink;



@property (retain) Server * server;
@property (retain) ARDInterface *ardInterface;




- (IBAction)buttonOFFPressed:(id)sender;

- (IBAction)buttonONPressed:(id)sender;
- (IBAction)buttonUpPressed:(id)sender;
- (IBAction)buttonDownPressed:(id)sender;
- (IBAction)btnPartyPressed:(id)sender;
- (IBAction)sldProgressiveChanged:(id)sender;
- (IBAction)btnBlinkPressed:(id)sender;






@end
