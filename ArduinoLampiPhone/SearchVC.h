//
//  SearchVC.h
//  ArduinoLampiPhone
//
//  Created by Esteban on 15/12/11.
//  Copyright (c) 2011 Filloadev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Server.h"

@interface SearchVC : UIViewController <ServerDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    
}

@property (retain, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, retain) Server *server;
@property (nonatomic, retain) NSMutableArray *services;



- (IBAction)btnConnectPressed:(id)sender;
@end
