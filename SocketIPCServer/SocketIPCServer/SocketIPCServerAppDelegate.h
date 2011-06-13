//
//  SocketIPCServerAppDelegate.h
//  SocketIPCServer
//
//  Created by Manuel Binna on 29.04.11.
//  Copyright 2011 Manuel Binna. All rights reserved.
//


@class SocketIPCServerViewController;

@interface SocketIPCServerAppDelegate : NSObject <UIApplicationDelegate> 
{

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SocketIPCServerViewController *viewController;

@end
