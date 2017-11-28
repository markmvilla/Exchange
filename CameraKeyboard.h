//
//  CameraKeyboard.h
//  TCU Exchange
//
//  Created by Mark Villa on 2/7/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationStyles.h"
#import <CoreImage/CoreImage.h>

@class CameraKeyboard;

@protocol CameraKeyboardDelegate <NSObject>
- (void)CameraKeyboard:(CameraKeyboard *)CameraKeyboard openCamera:(NSString *)text;
- (void)CameraKeyboard:(CameraKeyboard *)CameraKeyboard uploadMedia:(NSString *)text;
@end

@interface CameraKeyboard : UIVisualEffectView <UITextViewDelegate>
- (id)initWithDelegate:(id<CameraKeyboardDelegate>)delegate;
@property (strong, nonatomic) id<CameraKeyboardDelegate> delegate;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *openCameraButton;
@property (strong, nonatomic) UIButton *uploadButton;


@end
