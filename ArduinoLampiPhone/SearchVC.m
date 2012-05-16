//
//  SearchVC.m
//  ArduinoLampiPhone
//
//  Created by Esteban on 15/12/11.
//  Copyright (c) 2011 Filloadev. All rights reserved.
//

#import "SearchVC.h"
#import "LightsVC.h"

#define kSERVICE_PROTOCOL_NAME @"ardlights"

@implementation SearchVC

@synthesize myTableView = _myTableView;
@synthesize server = _server;
@synthesize services = _services;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.server = [[[Server alloc] initWithProtocol:kSERVICE_PROTOCOL_NAME] autorelease];
        self.server.delegate = self;
        NSError *error = nil;
        [self.server start:&error];
        
        self.services = [[[NSMutableArray alloc] init] autorelease];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {

    [_myTableView release];
    [super dealloc];
}

#pragma mark - Table stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [self.services count];
    count = (count == 0)? 1 : count;
    NSLog(@"rows: %d", count );
    return count; 
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Available servers";
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    static NSString *myid = @"kkdvk";
    
    cell = [tableView dequeueReusableCellWithIdentifier:myid];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myid] autorelease];
    }
    
    if ([self.services count] == 0) {
        cell.textLabel.text = @"Searching...";
        UIActivityIndicatorView *act = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        [act startAnimating];
        cell.accessoryView = act;
    } else {
        NSString *msg = [NSString stringWithFormat:@"%@", [[self.services objectAtIndex:indexPath.row] name]];
        cell.textLabel.text = msg;
        cell.accessoryView = nil;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   	[self.server connectToRemoteService:[self.services objectAtIndex:indexPath.row]];

}

- (void)serviceUpdate {
    NSLog(@"service update");
    [self.myTableView reloadData];
}


#pragma mark Server Delegate Methods

- (void)serverRemoteConnectionComplete:(Server *)server {
    NSLog(@"Server Started");
    
    LightsVC *lvc = [[[LightsVC alloc] initWithNibName:@"LightsVC" bundle:nil] autorelease];
    lvc.server = self.server;
    
    [self.navigationController pushViewController:lvc animated:YES];
    
}

- (void)serverStopped:(Server *)server {
    NSLog(@"Server stopped");
    // [self.navigationController popViewControllerAnimated:YES];
}

- (void)server:(Server *)server didNotStart:(NSDictionary *)errorDict {
    NSLog(@"Server did not start %@", errorDict);
}

- (void)server:(Server *)server didAcceptData:(NSData *)data {
    NSLog(@"Server did accept data %@", data);
    NSString *message = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if(nil != message || [message length] > 0) {
        //  serverRunningVC.message = message;
    } else {
        // serverRunningVC.message = @"no data received";
    }
}

- (void)server:(Server *)server lostConnection:(NSDictionary *)errorDict {
    NSLog(@"Server lost connection %@", errorDict);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)serviceAdded:(NSNetService *)service moreComing:(BOOL)more {
    [self.services addObject:service];
    [self.myTableView reloadData];
}

- (void)serviceRemoved:(NSNetService *)service moreComing:(BOOL)more {
    [self.services removeObject:service];
    [self.myTableView reloadData];
}


#pragma mark - Client

- (void)startClient {

}

- (IBAction)btnConnectPressed:(id)sender {
    NSLog(@"btn pressed");
    NSError *error = nil;
    
    [self.server sendData:[[[NSDate dateWithTimeIntervalSinceNow:0] description] dataUsingEncoding:NSUTF8StringEncoding] error:&error];
}



@end
