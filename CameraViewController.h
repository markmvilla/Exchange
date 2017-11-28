//
//  CameraViewController.h
//  TCU Exchange
//
//  Created by Mark Villa on 2/7/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationStyles.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CameraKeyboard.h"
#import "Coordinates.h"
#import "AFNetworking.h"
//#import "JSON/SBJSON.h"

@interface CameraViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, CameraKeyboardDelegate>
- (id)initWithArray:(NSMutableArray *) passedmysqlArray;
@property (nonatomic, retain) NSMutableArray *mysqlArray;
@property (nonatomic, strong) UIImageView *imagePicked;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) UILabel *pictureLabel;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *openCameraButton;

@end
