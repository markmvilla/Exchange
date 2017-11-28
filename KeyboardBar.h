//
//  KeyboardBar.h
//  TCU Exchange
//
//  Created by Mark Villa on 1/17/16.
//  Copyright © 2016 Exchange. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ApplicationStyles.h"
#import <CoreImage/CoreImage.h>

@class KeyboardBar;

@protocol KeyboardBarDelegate <NSObject>

- (void)keyboardBar:(KeyboardBar *)keyboardBar sendText:(NSString *)text;
- (void)keyboardBar:(KeyboardBar *)keyboardBar openCamera:(NSString *)text;
@end

@interface KeyboardBar : UIVisualEffectView <UITextViewDelegate>

- (id)initWithDelegate:(id<KeyboardBarDelegate>)delegate;
@property (weak, nonatomic) id<KeyboardBarDelegate> delegate;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *openCameraButton;
@property (strong, nonatomic) UIButton *sendButton;
@end
