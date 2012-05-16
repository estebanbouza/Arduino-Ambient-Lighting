//
//  LigthsVC.h
//  ArduinoLampiPhone
//
//  Created by Esteban on 16/12/11.
//  Copyright (c) 2011 Filloadev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"

@interface LightsVC : UIViewController

@property (retain, nonatomic) IBOutlet UISlider *sldAnalog;
@property (retain, nonatomic) IBOutlet UISlider *sldProgressive;
@property (retain, nonatomic) IBOutlet UISwitch *swLight;
@property (retain, nonatomic) IBOutlet UIButton *lblBlink;
@property (retain, nonatomic) IBOutlet UIStepper *stpBlink;
@property (retain, nonatomic) Server *server;
@property (assign, nonatomic) NSInteger blinkTimes;



- (IBAction)sldAnalogChanged:(id)sender;
- (IBAction)sldProgressiveChanged:(id)sender;
- (IBAction)swLightChanged:(id)sender;
- (IBAction)stpChanged:(id)sender;
- (IBAction)btnBlinkPressed:(id)sender;


@end
