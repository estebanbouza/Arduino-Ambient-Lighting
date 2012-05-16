//
//  ARDInterface.h
//  arduinolamp
//
//  Created by Esteban on 17/12/11.
//  Copyright (c) 2011 Filloadev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARDDriver.h"

#define MSGON   78
#define MSGOFF  70

@interface ARDInterface : NSObject


@property (nonatomic, assign) int fd;

- (void)switchOn;
- (void)switchOff;
- (void)setIntensity:(uint8_t)intensity;
- (void)progressiveTo:(uint8_t)intensity;
- (void)blinkTimes:(uint8_t)times;

- (void)openArduino:(NSString *)path baud:(uint32_t)baud;
- (void)openArduino:(NSString *)path;

@end
