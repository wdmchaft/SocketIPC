//
//  SocketIPCServerAppDelegate.m
//  SocketIPCServer
//
//  Created by Manuel Binna on 29.04.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//

#import "SocketIPCServerAppDelegate.h"
#import "SocketIPCServerViewController.h"


@implementation SocketIPCServerAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    
    [super dealloc];
}

@end
