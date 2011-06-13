//
//  SocketIPCClientAppDelegate.h
//  SocketIPCClient
//
//  Created by Manuel Binna on 29.04.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//


@class SocketIPCClientViewController;

@interface SocketIPCClientAppDelegate : NSObject <UIApplicationDelegate> 
{

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SocketIPCClientViewController *viewController;

@end
