//
//  FCAppDelegate.m
//  FileCheck
//
//  Created by James Kang on 12/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FCAppDelegate.h"
#import "SCEvents.h"
#import "SCEvent.h"

@interface FCAppDelegate (Protected)

- (void)setUpFileWatching;
- (void)updateStatusMenu;

@end

@implementation FCAppDelegate (Protected)

- (void)setUpFileWatching
{
    self.fileEventsController = 
    [[[FileEventsController alloc] init] autorelease];    
    
    // Specify the one path that we'll watch.
    NSString *filePathToWatch = @"/dl/tumblrJSON.zip";
    self.fileEventsController.filePathsToWatch = 
    [NSArray arrayWithObject:filePathToWatch];
    
    // This block runs when the folder contains the file we watch is changed.
    FileExistenceBlock fileExistenceBlock = 
    ^(NSString *filePath, BOOL exists)
    {
        if (exists)
        {
            self.statusMessage = @"File is there.";
        }
        else
        {
            self.statusMessage = @"File's not there.";
        }
        [self updateStatusMenu];
    };
    
    self.fileEventsController.fileExistenceCallbackBlock = 
    [[fileExistenceBlock copy] autorelease];
    
    // Set up initial status.
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    fileExistenceBlock(filePathToWatch, 
                       [fileManager fileExistsAtPath:filePathToWatch]);
    [fileManager release];                       
    
    [self.fileEventsController setupEventListener];   
}

// This method might not be worth having around if this is really all you have 
// to do.
- (void)updateStatusMenu
{
    self.statusItem.title = self.statusMessage;
}

@end


@implementation FCAppDelegate

@synthesize window = _window;
@synthesize statusMenu;
@synthesize statusItem;
@synthesize fileEventsController;
@synthesize statusMessage;

- (void)dealloc
{
    [statusMessage release];
    [fileEventsController release];
    [statusItem release];
    [statusMenu release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application    
    [self setUpFileWatching];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.statusMessage = @"File's not there.";
    
    self.statusItem = 
    [[NSStatusBar systemStatusBar] 
     statusItemWithLength:NSVariableStatusItemLength]; 
    self.statusItem.menu = self.statusMenu;
    self.statusItem.highlightMode = YES;
    [self updateStatusMenu];
//    [statusItem release];
}

@end
