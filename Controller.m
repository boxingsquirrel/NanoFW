//
//  Controller.m
//  NanoFW
//
//  Created by boxingsquirrel on 11/18/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "Controller.h"
#import "ZipArchive.h"
#include "Apple8723Container.h"

NSString *ipsw_fname=@"/Users/boxingsquirrel/Downloads/iPod2,1_4.0_8A293_Restore.ipsw";
NSString *outdir_fname=@"/Users/boxingsquirrel/Desktop/dump";
NSString *fw_fname=@"osos.fw";
double val=0.0;

@implementation Controller
-(IBAction)chooseIPSW:(id)sender {
	NSOpenPanel *choose=[NSOpenPanel openPanel];
	[choose setCanChooseFiles:YES];
	[choose setCanChooseDirectories:NO];
	[choose setTitle:@"Browse for IPSW..."];
	if ([choose runModalForTypes:[NSArray arrayWithObject:@"ipsw"]] == NSOKButton)
	{
		NSArray *f=[choose filenames];
		ipsw_fname=[f objectAtIndex:0];
		[ipsw_fname retain];
	}
}

-(IBAction)chooseOutDir:(id)sender {
	NSOpenPanel *choose=[NSOpenPanel openPanel];
	[choose setCanChooseFiles:NO];
	[choose setCanChooseDirectories:YES];
	[choose setTitle:@"Browse for Output Directory..."];
	if ([choose runModalForDirectory:nil file:nil] == NSOKButton)
	{
		NSArray *f=[choose filenames];
		outdir_fname=[f objectAtIndex:0];
		[outdir_fname retain];
	}	
}

-(IBAction)decrypt:(id)sender {
	/*NSBeep();
	NSString *filePath = [[NSBundle mainBundle] bundlePath];
	FILE *file=fopen("/tmp/bundle_loc.txt", "w");
	fprintf(file, "%s", [filePath UTF8String]);
	fclose(file);
	[filePath retain];
	//[ipsw_fname writeToFile:@"/tmp/ipsw.txt"];
	//[outdir_fname writeToFile:@"/tmp/out.txt"];
	//ipsw=(const char *)[ipsw_fname UTF8String];
	//out_dir=[outdir_fname UTF8String];
	ipsw_extract_all([ipsw_fname UTF8String], [outdir_fname UTF8String], [filePath UTF8String], 0, NULL, NULL);*/
	[pBar setUsesThreadedAnimation:YES];
	[pBar displayIfNeeded];
	[pBar setDoubleValue:10.0];
	ZipArchive *za=[[ZipArchive alloc] init];
	[za UnzipOpenFile:ipsw_fname];
	[za UnzipFileTo:outdir_fname overWrite:YES];
	[za release];
	[pBar setDoubleValue:65.0];
	char cmd[2048];
	snprintf(cmd, 2048, "cd %s && /Users/boxingsquirrel/Documents/iOS-Utils/Nano/extract2g/extract2g -A -4 %s/Firmware.MSE", [outdir_fname UTF8String], [outdir_fname UTF8String]);
	system(cmd);
	[pBar setDoubleValue:85.0];
	snprintf(cmd, 2048, "dd if=%s/rsrc.fw of=%s/rsrc.img iseek=2 count=284672", [outdir_fname UTF8String], [outdir_fname UTF8String]);
	system(cmd);
	[pBar setDoubleValue:100.0];
	NSAlert *a=[[NSAlert alloc] init];
	[a addButtonWithTitle:@"OK"];
	[a setMessageText:@"Done!"];
	[a setInformativeText:@"The IPSW was extracted!"];
	[a setAlertStyle:NSWarningAlertStyle];
	[a beginSheetModalForWindow:win modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

-(IBAction)fwfileinfo:(id)sender {
	NSOpenPanel *choose=[NSOpenPanel openPanel];
	[choose setCanChooseFiles:YES];
	[choose setCanChooseDirectories:NO];
	[choose setTitle:@"Browse for IPSW..."];
	if ([choose runModalForTypes:[NSArray arrayWithObject:@"fw"]] == NSOKButton)
	{
		NSArray *f=[choose filenames];
		fw_fname=[f objectAtIndex:0];
		[fw_fname retain];
		Apple8723Header head;
		FILE *file=fopen([fw_fname UTF8String], "rb");
		fread((void *)&head, LEN_STRUCTURE, sizeof(char), file);
		printf("Version: %s\n", head.version);
		char mag[5];
		snprintf(mag, 5, "%c%c%c%c", head.magic[0], head.magic[1], head.magic[2], head.magic[3]);
		[magicLabel setStringValue:[NSString stringWithCString:mag]];
		[versionLabel setStringValue:[NSString stringWithCString:head.version]];

		char format[16];
		if (head.format==0x3) {
			snprintf(format, 16, "0x%x (Encrypted)", head.format);
		}
		else if (head.format==0x4) {
			snprintf(format, 16, "0x%x (Plaintext)", head.format);
		}
		else {
			snprintf(format, 16, "0x%x (Unknown)", head.format);
		}
		[formatLabel setStringValue:[NSString stringWithCString:format]];
		[unknown1Label setIntValue:(int)head.unknown1];
		[sizeLabel setIntValue:(int)head.sizeOfData];
		[footerLabel1 setIntValue:(int)head.footerSignatureOffset];
		[footerLabel2 setIntValue:(int)head.footerCertificateOffset];
		[footerLabel3 setIntValue:(int)head.footerCertificateLength];
		[saltLabel setStringValue:[NSString stringWithCString:head.salt]];
		[unknown2Label setIntValue:(int)head.unknown2];
		[epochLabel setIntValue:(int)head.epoch];
		
		char headSig[256]="";
		for (int i=0; head.headerSignature[i]!='\0'; i++) {
			snprintf(headSig, 256, "%s%02x", headSig, head.headerSignature[i]);
		}
		[headSigLabel setStringValue:[NSString stringWithCString:headSig]];

		char pad[256]="";
		for (int i=0; head.padding[i]!='\0'; i++) {
			snprintf(pad, 256, "%s%02x", pad, head.padding[i]);
		}
		[paddingLabel setStringValue:[NSString stringWithCString:pad]];
	}
}

@end
