//
//  ViewController.h
//  Camera
//
//  Created by Zeev Vax on 12/13/11.
//  Copyright (c) 2011 Hoppaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    CGRect imageFrame;
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIButton *TakePictureButton;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayerController;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSURL *movieUrl;
@property (nonatomic, copy) NSString *lastChosenMediaType;

-(IBAction) shootPictureIrVideo:(id) sender;
-(IBAction)selectExisitingPictureOrVideo:(id)sender;

@end
