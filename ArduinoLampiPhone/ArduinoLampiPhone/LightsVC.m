//
//  LigthsVC.m
//  ArduinoLampiPhone
//
//  Created by Esteban on 16/12/11.
//  Copyright (c) 2011 Filloadev. All rights reserved.
//

#import "LightsVC.h"
#import "Constants.h"

#define kInitBlinkTimes 2
#define kSteperMaxValue 10

@implementation LightsVC
@synthesize sldAnalog = _sldAnalog;
@synthesize server = _server;
@synthesize sldProgressive = _sldProgressive;
@synthesize swLight = _swLight;
@synthesize lblBlink = _lblBlink;
@synthesize stpBlink = _stpBlink;
@synthesize blinkTimes = _blinkTimes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.blinkTimes = kInitBlinkTimes;

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Server helper

- (void)sendString:(NSString *)msg {
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    [self.server sendData:data error:&error];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.blinkTimes = [[[self.lblBlink titleLabel] text] integerValue];
    self.stpBlink.value = self.blinkTimes;
    [self.lblBlink setTitle:[NSString stringWithFormat:@"%d", kInitBlinkTimes] forState:UIControlStateNormal];

}

- (void)viewDidUnload
{

    [self setSldAnalog:nil];
    [self setSldProgressive:nil];
    [self setSwLight:nil];
    [self setLblBlink:nil];
    [self setStpBlink:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {

    [_sldAnalog release];
    [_sldProgressive release];
    [_swLight release];
    [_lblBlink release];
    [_stpBlink release];
    [super dealloc];
}


- (IBAction)sldAnalogChanged:(id)sender {
    NSInteger value = [self.sldAnalog value];
    [self sendString:[NSString stringWithFormat:kMSGFormat1P, kHDRAnalog, value]];
}

- (IBAction)sldProgressiveChanged:(id)sender {
    NSInteger value = [self.sldProgressive value];
    
    [self sendString:[NSString stringWithFormat:kMSGFormat1P, kHDRProgressive, value]];

}

- (IBAction)swLightChanged:(id)sender {
    BOOL state = self.swLight.on;
    [self sendString:[NSString stringWithFormat:kMSGFormat1P, kHDRSwitch, state]];
}

- (IBAction)stpChanged:(id)sender {
    self.blinkTimes = (NSInteger) self.stpBlink.value;
    [self.lblBlink setTitle:[NSString stringWithFormat:@"%d", self.blinkTimes] forState:UIControlStateNormal];

}

- (IBAction)btnBlinkPressed:(id)sender {
    [self sendString:[NSString stringWithFormat:kMSGFormat1P, kHDRBlink, self.blinkTimes]];
}



@end
