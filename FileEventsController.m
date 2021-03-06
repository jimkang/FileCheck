/*
 *  $Id: Controller.m 197 2011-03-20 15:25:16Z stuart $
 *
 *  SCEvents
 *  http://stuconnolly.com/projects/code/
 *
 *  Copyright (c) 2011 Stuart Connolly. All rights reserved.
 *
 *  Permission is hereby granted, free of charge, to any person
 *  obtaining a copy of this software and associated documentation
 *  files (the "Software"), to deal in the Software without
 *  restriction, including without limitation the rights to use,
 *  copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following
 *  conditions:
 *
 *  The above copyright notice and this permission notice shall be
 *  included in all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 *  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *  OTHER DEALINGS IN THE SOFTWARE.
 */

#import "FileEventsController.h"
#import "SCEvents.h"
#import "SCEvent.h"

static NSString *SCEventsDownloadsDirectory = @"Downloads";

@implementation FileEventsController

@synthesize fileExistenceCallbackBlock;
@synthesize filePathsToWatch;

/**
 * Sets up the event listener using SCEvents and sets its delegate to this controller.
 * The event stream is started by calling startWatchingPaths: while passing the paths
 * to be watched.
 */
- (void)setupEventListener
{
	if (_events) return;
	
    _events = [[SCEvents alloc] init];
    
    [_events setDelegate:self];
    
//    NSMutableArray *paths = [NSMutableArray arrayWithObject:NSHomeDirectory()];
//    NSMutableArray *excludePaths = 
//    [NSMutableArray 
//     arrayWithObject:
//     [NSHomeDirectory() stringByAppendingPathComponent:SCEventsDownloadsDirectory]];
    
	// Set the paths to be excluded
//	[_events setExcludedPaths:excludePaths];
	
    // Directories for files to watch.
    // Assumes filePathsToWatch are files, not directories.
    NSMutableArray *dirPaths = 
    [NSMutableArray arrayWithCapacity:self.filePathsToWatch.count];
    for (NSString *filePath in self.filePathsToWatch)
    {
        [dirPaths addObject:[filePath stringByDeletingLastPathComponent]];
    }
                             
	// Start receiving events    
	[_events startWatchingPaths:dirPaths];

	// Display a description of the stream
	NSLog(@"%@", [_events streamDescription]);	
}

/**
 * This is the only method to be implemented to conform to the SCEventListenerProtocol.
 * As this is only an example the event received is simply printed to the console.
 *
 * @param pathwatcher The SCEvents instance that received the event
 * @param event       The actual event
 */
- (void)pathWatcher:(SCEvents *)pathWatcher eventOccurred:(SCEvent *)event
{
    NSLog(@"%@", event);
    if (self.fileExistenceCallbackBlock)
    {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        for (NSString *filePath in self.filePathsToWatch)
        {
            NSRange rangeOfSubpath = [filePath rangeOfString:event.eventPath];
            if (rangeOfSubpath.location != NSNotFound)
            {
                self.fileExistenceCallbackBlock(filePath, 
                                                [fileManager 
                                                 fileExistsAtPath:filePath]);
            }
        }
        [fileManager release];
    }
}

#pragma mark -

- (void)dealloc
{
    [filePathsToWatch release];
    [fileExistenceCallbackBlock release];
	[_events release], _events = nil;
	
	[super dealloc];
}

@end
