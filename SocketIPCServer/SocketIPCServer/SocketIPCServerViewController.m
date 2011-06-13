//
//  SocketIPCServerViewController.m
//  SocketIPCServer
//
//  Created by Manuel Binna on 29.04.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//

#import "SocketIPCServerViewController.h"

#import <stdio.h>
#import <unistd.h>
#import <sys/socket.h>
#import <sys/un.h>
#import <string.h>

#if TARGET_IPHONE_SIMULATOR
    #define SOCKET_PATH     "/Users/Manu/Desktop/SocketIPCSocket"
#else
    #define SOCKET_PATH     "/var/mobile/Library/AddressBook/SOCKET"
#endif


@interface SocketIPCServerViewController ()

@property(nonatomic) UIBackgroundTaskIdentifier socketTaskID;

- (void)listenForIncomingConnections;

@end


@implementation SocketIPCServerViewController

@synthesize socketTaskID = _socketTaskID;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Begin async exection in background.
    __block __typeof__(self) blockSelf = self;  // Prevent creating a retain cycle.
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    self.socketTaskID = [sharedApplication beginBackgroundTaskWithExpirationHandler:^(void) {
        [sharedApplication endBackgroundTask:blockSelf.socketTaskID];
        blockSelf.socketTaskID = UIBackgroundTaskInvalid;
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [blockSelf listenForIncomingConnections];
        [sharedApplication endBackgroundTask:blockSelf.socketTaskID];
        blockSelf.socketTaskID = UIBackgroundTaskInvalid;
    });
}

- (void)listenForIncomingConnections
{
    int serverSocket = socket(AF_UNIX, SOCK_STREAM, 0);
    if (serverSocket < 0) {
        perror("socket");
        exit(EXIT_FAILURE);
    }
    
    // Ensure that SOCKET_PATH does not exist
    unlink(SOCKET_PATH);
    
    struct sockaddr_un address;
    address.sun_family = AF_UNIX;
    strcpy(address.sun_path, SOCKET_PATH);
    socklen_t addressLength = SUN_LEN(&address);
    
    if (bind(serverSocket, (struct sockaddr *)&address, addressLength) != 0) {
        perror("bind");
        exit(EXIT_FAILURE);
    }
    
    if (listen(serverSocket, 5) != 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    
    int connection = 0;
    while ((connection = accept(serverSocket, (struct sockaddr *)&address, &addressLength)) >= 0) {
        NSString *message = @"This is a message from the other program.";
        NSMutableData *messageData = [[[message dataUsingEncoding:NSUTF8StringEncoding] mutableCopy] autorelease];
        write(connection, [messageData mutableBytes], [messageData length]);
        close(connection);
    }
    close(serverSocket);
    
    // Ensure that SOCKET_PATH does not exist
    unlink(SOCKET_PATH);
}

- (void)dealloc
{
    [super dealloc];
}

@end
