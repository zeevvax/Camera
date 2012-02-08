//
//  ViewController.m
//  Camera
//
//  Created by Zeev Vax on 12/13/11.
//  Copyright (c) 2011 Hoppaa. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ViewController() 
static UIImage *shrinkImage(UIImage *original, CGSize size);
-(void) updateDisplay;
-(void) getMediaFromSource:(UIImagePickerControllerSourceType) sourceType;
@end

@implementation ViewController
@synthesize image,imageView, TakePictureButton,moviePlayerController,movieUrl,lastChosenMediaType;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.TakePictureButton.alpha = 0.0;
    }
    imageFrame = imageView.frame;
    self.moviePlayerController = [[MPMoviePlayerController alloc] init];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateDisplay];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(IBAction)shootPictureIrVideo:(id)sender{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

-(IBAction)selectExisitingPictureOrVideo:(id)sender{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark UIImagePickerController delegate methods
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *sharkenImage = shrinkImage(chosenImage, imageFrame.size);
        self.image = sharkenImage;
    }
    else if ([lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
        self.movieUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
static UIImage *shrinkImage(UIImage *original, CGSize size){
    CGFloat scale = [UIScreen mainScreen].scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, size.width *scale, size.height *scale, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width *scale, size.height *scale), original.CGImage);
    CGImageRef shrunken = CGBitmapContextCreateImage(context);
    UIImage *final = [UIImage imageWithCGImage:shrunken];
    CGContextRelease(context);
    CGImageRelease(shrunken);
    return final;
}

-(void) updateDisplay{
    if ([lastChosenMediaType isEqual:(NSString *) kUTTypeImage]) {
        imageView.image = image;
        imageView.hidden = NO;
        moviePlayerController.view.hidden = YES;
    }
    else if ([lastChosenMediaType isEqual:(NSString *) kUTTypeMovie]){
        //[self.moviePlayerController.view removeFromSuperview];
        //self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
        //moviePlayerController.view.frame = imageFrame;
        self.moviePlayerController.contentURL = movieUrl;
        [moviePlayerController.view setFrame:imageView.bounds];
        moviePlayerController.view.clipsToBounds = YES;
        [self.view addSubview:moviePlayerController.view];
        imageView.hidden = YES;
        moviePlayerController.view.hidden = NO;
        [moviePlayerController play];
    }
}

-(void) getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && mediaTypes > 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error accesing Media" message:@"device doesn't support that media source" delegate:nil cancelButtonTitle:@"Dart" otherButtonTitles:nil];
        [alert show];
    }
}
  
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
