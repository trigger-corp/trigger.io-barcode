//
//  barcode_API.m
//  ForgeModule
//
//  Created by Connor Dunn on 05/04/2013.
//  Copyright (c) 2013 Trigger Corp. All rights reserved.
//

#import "barcode_API.h"
#import "barcode_ViewController.h"

@implementation barcode_API

+ (void) scan:(ForgeTask*)task {
	barcode_ViewController *view = [[barcode_ViewController alloc] initWithNibName:@"barcode_ViewController" bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"barcode" ofType:@"bundle"]]];
	
	view.forgeTask = task;
	
	[[[ForgeApp sharedApp] viewController] presentModalViewController:view animated:YES];
}

@end
