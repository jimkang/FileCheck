//
//  FCAppDelegate.h
//  FileCheck
//
//  Created by James Kang on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileEventsController.h"

@interface FCAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic, retain) FileEventsController *fileEventsController;
//@property (nonatomic, retain) NSString *statusMessage;
@property (assign) BOOL fileLastReportedToExist; 

@end
