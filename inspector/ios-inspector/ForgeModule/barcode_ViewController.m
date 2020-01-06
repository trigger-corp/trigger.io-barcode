/*
 * Copyright 2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "barcode_ViewController.h"
#import "ZXCapture.h"
#import "ZXResult.h"

@interface barcode_ViewController ()

@property (nonatomic, retain) ZXCapture* capture;
@property (nonatomic, assign) IBOutlet UILabel* decodedLabel;
@property (nonatomic, assign) IBOutlet UILabel* boxLabel;
@property (nonatomic, assign) IBOutlet UIButton* cancelButton;
@property (nonatomic, assign) IBOutlet UIButton* flashButton;

- (NSString*)displayForResult:(ZXResult*)result;

@end

static barcode_ViewController *me;
static bool haveResult = false;

@implementation barcode_ViewController

@synthesize capture;
@synthesize decodedLabel;
@synthesize forgeTask;

#pragma mark - Creation/Deletion Methods


#pragma mark - View Controller Methods

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    haveResult = false;

	me = self;
	self.capture = [[ZXCapture alloc] init];
	self.capture.delegate = self;
	self.capture.rotation = 90.0f;

	// Use the back camera
	self.capture.camera = self.capture.back;

	self.capture.layer.frame = self.view.bounds;
	[self.view.layer addSublayer:self.capture.layer];

	[self.view bringSubviewToFront:self.boxLabel];
	[self.view bringSubviewToFront:self.decodedLabel];
	[self.view bringSubviewToFront:self.cancelButton];
	[self.view bringSubviewToFront:self.flashButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (!haveResult) {
        [forgeTask error:@"User cancelled" type:@"EXPECTED_FAILURE" subtype:nil];
    }
}


- (void)releaseAfterDelay {
	double delayInSeconds = 5.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		capture.delegate = nil;
		me = nil;
	});
}

- (IBAction)buttonTapped:(UIButton *)button {
	[self dismissViewControllerHelper:^{
		[self releaseAfterDelay];
	}];
}


- (IBAction)flashButtonTapped:(UIButton *)button {
	[self.capture setTorch:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Private Methods

- (NSDictionary*)displayForResult:(ZXResult*)result {
	NSString *formatString;
	switch (result.barcodeFormat) {
		case kBarcodeFormatAztec:
			formatString = @"AZTEC";
			break;

		case kBarcodeFormatCodabar:
			formatString = @"CODABAR";
			break;

		case kBarcodeFormatCode39:
			formatString = @"CODE_39";
			break;

		case kBarcodeFormatCode93:
			formatString = @"CODE_93";
			break;

		case kBarcodeFormatCode128:
			formatString = @"CODE_128";
			break;

		case kBarcodeFormatDataMatrix:
			formatString = @"DATA_MATRIX";
			break;

		case kBarcodeFormatEan8:
			formatString = @"EAN_8";
			break;

		case kBarcodeFormatEan13:
			formatString = @"EAN_13";
			break;

		case kBarcodeFormatITF:
			formatString = @"ITF";
			break;

		case kBarcodeFormatPDF417:
			formatString = @"PDF_417";
			break;

		case kBarcodeFormatQRCode:
			formatString = @"QR_CODE";
			break;

		case kBarcodeFormatRSS14:
			formatString = @"RSS_14";
			break;

		case kBarcodeFormatRSSExpanded:
			formatString = @"RSS_EXPANDED";
			break;

		case kBarcodeFormatUPCA:
			formatString = @"UPC_A";
			break;

		case kBarcodeFormatUPCE:
			formatString = @"UPC_E";
			break;

		case kBarcodeFormatUPCEANExtension:
			formatString = @"UPC_EAN_EXTENSION";
			break;

		default:
			formatString = @"UNKNOWN";
			break;
	}

	return @{@"value": result.text, @"format": formatString};
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture*)capture result:(ZXResult*)result {
	if (result) {
        haveResult = true;
		self.capture.delegate = nil;
		[self dismissViewControllerHelper:^{
			[forgeTask success:[self displayForResult:result]];
			[self releaseAfterDelay];
		}];
	}
}

- (void)captureSize:(ZXCapture*)capture width:(NSNumber*)width height:(NSNumber*)height {
}

-(void)captureCameraIsReady:(ZXCapture *)capture {
	if ([self.capture hasTorch]) {
		[self.flashButton setHidden:NO];
	}
}

@end
