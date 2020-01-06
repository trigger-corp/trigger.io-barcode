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
	barcode_ViewController *viewController = [[barcode_ViewController alloc] initWithNibName:@"barcode_ViewController" bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"barcode" ofType:@"bundle"]]];
	
	viewController.forgeTask = task;
    viewController.modalPresentationStyle = UIModalPresentationOverFullScreen;

	[[[ForgeApp sharedApp] viewController] presentViewController:viewController animated:TRUE completion:^{}];
}

@end
