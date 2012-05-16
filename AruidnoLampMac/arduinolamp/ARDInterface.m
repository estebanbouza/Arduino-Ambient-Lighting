//
//  ARDInterface.m
//  arduinolamp
//
//  Created by Esteban on 17/12/11.
//  Copyright (c) 2011 Filloadev. All rights reserved.
//

#import "ARDInterface.h"

@implementation ARDInterface

@synthesize fd;

#pragma mark Arduino Service Interface

- (void)openArduino:(NSString *)path baud:(uint32_t)baud {
    self.fd = serialport_init([path UTF8String], baud);
}

- (void)openArduino:(NSString *)path {
    [self openArduino:path baud:115200];
}


- (BOOL)validateIntensity:(uint8_t)intensity {
    if (intensity < 0 ||
        intensity > 255) {
        NSLog(@"Out of range intensity: %d", intensity);
        return false;
    }
    return true;
}

- (void)switchOn {
    serialport_write(self.fd, "S");
    serialport_write_int(fd, MSGON);
}

- (void)switchOff {
    serialport_write(fd, "S");
    serialport_write_int(fd, MSGOFF);
}

- (void)setIntensity:(uint8_t)intensity {
    [self validateIntensity:intensity];
    serialport_write(fd, "A");
    serialport_write_int(fd, intensity);
}

- (void)progressiveTo:(uint8_t)intensity {
    [self validateIntensity:intensity];
    serialport_write(fd, "P");
    serialport_write_int(fd, intensity);
}

- (void)blinkTimes:(uint8_t)times {
    serialport_write(fd, "K");
    serialport_write_int(fd, times); 
}



@end
