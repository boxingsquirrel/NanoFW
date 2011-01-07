//
//  Controller.h
//  FirmExtract-OSX
//
//  Created by boxingsquirrel on 11/18/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Controller : NSObject {
	IBOutlet id win;

	IBOutlet id ipswButton;
	IBOutlet id outDirButton;
	IBOutlet id decButton;

	IBOutlet id pBar;

	IBOutlet id magicLabel;
	IBOutlet id versionLabel;
	IBOutlet id formatLabel;
	IBOutlet id unknown1Label;
	IBOutlet id sizeLabel;
	IBOutlet id footerLabel1;
	IBOutlet id footerLabel2;
	IBOutlet id footerLabel3;
	IBOutlet id saltLabel;
	IBOutlet id unknown2Label;
	IBOutlet id epochLabel;
	IBOutlet id headSigLabel;
	IBOutlet id paddingLabel;
}

-(IBAction)chooseIPSW:(id)sender;
-(IBAction)chooseOutDir:(id)sender;
-(IBAction)decrypt:(id)sender;
-(IBAction)fwfileinfo:(id)sender;
@end
