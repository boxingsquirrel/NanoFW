//
//  NanoFWAppDelegate.h
//  NanoFW
//
//  Created by boxingsquirrel on 1/1/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NanoFWAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
