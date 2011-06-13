//
//  SocketIPCClientViewController.m
//  SocketIPCClient
//
//  Created by Manuel Binna on 29.04.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//

#import "SocketIPCClientViewController.h"
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


@implementation SocketIPCClientViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int clientSocket = socket(AF_UNIX, SOCK_STREAM, 0);
    if (clientSocket < 0) {
        perror("socket");
        exit(EXIT_FAILURE);
    }
    
    struct sockaddr_un address;
    address.sun_family = AF_UNIX;
    strcpy(address.sun_path, SOCKET_PATH); 
    socklen_t addressLength = SUN_LEN(&address);
    
    if (connect(clientSocket, (struct sockaddr *)&address, addressLength) !=0 ) {
        perror("connect");
        exit(EXIT_FAILURE);
    }
    
    NSLog(@"Connected to Server ... receiving data ..."); 
    
    NSMutableData *receivedData = [[NSMutableData alloc] initWithLength:100];
    read(clientSocket, [receivedData mutableBytes], [receivedData length]);

    NSString *receivedMessage = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"Received data: %@", receivedMessage);
    
    [receivedData release];
    close(clientSocket);
}

- (void)dealloc
{
    [super dealloc];
}

@end
