//
//  CameraKeyboard.m
//  TCU Exchange
//
//  Created by Mark Villa on 2/7/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "CameraKeyboard.h"

@interface CameraKeyboard()
@end

@implementation CameraKeyboard

- (id)initWithDelegate:(id<CameraKeyboardDelegate>)delegate {
    self = [self init];
    self.delegate = delegate;
    return self;
}

- (id)init {
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self = [self initWithEffect:blurEffect];
    return self;
}

- (id)initWithEffect:(UIVisualEffect *)effect {
    if(self) {
        CGRect screen = [[UIScreen mainScreen] bounds];
        self = [super initWithEffect:effect];
        self.frame = CGRectMake(0,0, CGRectGetWidth(screen), 35);

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
        self.backgroundColor = [UIColor colorWithRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:0.0f];

        self.textView = [[UITextView alloc] init];
        self.textView.translatesAutoresizingMaskIntoConstraints = false;
        self.textView.backgroundColor = [UIColor colorWithRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.0f];
        self.textView.layer.cornerRadius = 8.0;
        [self.textView setFont:lRegularFont];
        self.textView.delegate = self;
        self.textView.scrollEnabled = true;
        [self addSubview:self.textView];

        self.openCameraButton = [[UIButton alloc] init];
        self.openCameraButton.translatesAutoresizingMaskIntoConstraints = false;
        self.openCameraButton.backgroundColor = [UIColor clearColor];
        self.openCameraButton.layer.cornerRadius = 2.0;
        [self.openCameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.openCameraButton addTarget:self action:@selector(openCameraButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [self.openCameraButton addTarget:self action:@selector(openCameraButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self.openCameraButton addTarget:self action:@selector(openCameraButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *cameraIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Camera.png"]];
        cameraIcon.image = [cameraIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        cameraIcon.backgroundColor = [UIColor clearColor];
        [cameraIcon setTintColor:[UIColor whiteColor]];
        cameraIcon.translatesAutoresizingMaskIntoConstraints = false;
        [self.openCameraButton addSubview:cameraIcon];
        [self addSubview:self.openCameraButton];

        self.uploadButton = [[UIButton alloc] init];
        self.uploadButton.translatesAutoresizingMaskIntoConstraints = false;
        self.uploadButton.backgroundColor = [UIColor clearColor];
        self.uploadButton.layer.cornerRadius = 2.0;
        [self.uploadButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.uploadButton addTarget:self action:@selector(uploadButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [self.uploadButton addTarget:self action:@selector(uploadButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self.uploadButton addTarget:self action:@selector(uploadButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.uploadButton];

        NSDictionary *views = @{ @"self" : self, @"textView" : self.textView, @"openCameraButton" : self.openCameraButton, @"cameraIcon" : cameraIcon, @"uploadButton" : self.uploadButton};
        NSArray *keyboardConstraints;
        keyboardConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[textView]-3-|" options:0 metrics:nil views:views];
        [self addConstraints:keyboardConstraints];
        keyboardConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[openCameraButton(35)]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:keyboardConstraints];
        keyboardConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[cameraIcon]-5-|" options:0 metrics:nil views:views];
        [self.openCameraButton addConstraints:keyboardConstraints];
        keyboardConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[cameraIcon]-5-|" options:0 metrics:nil views:views];
        [self.openCameraButton addConstraints:keyboardConstraints];
        keyboardConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[uploadButton(35)]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:keyboardConstraints];
        keyboardConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[openCameraButton(35)]-5-[textView]-5-[uploadButton(70)]-1-|" options:0 metrics:nil views:views];
        [self addConstraints:keyboardConstraints];
    }
    return self;

}

- (void)keyboardWillShow{
    NSLog(@"keyboardWillShow");
}

- (void)keyboardWillHide{
    NSLog(@"keyboardWillHide");
}

- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"%@",textView.text);
    CGFloat width = textView.bounds.size.width - 2.0 * textView.textContainer.lineFragmentPadding;
    CGSize maximumLabelSize = CGSizeMake(width, MAXFLOAT);
    CGRect textRect = [textView.text boundingRectWithSize:maximumLabelSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName:lRegularFont}
                                                  context:nil];
    CGFloat realheight = textRect.size.height + textView.textContainerInset.top + textView.textContainerInset.bottom;
    //CGFloat minheight = textView.font.lineHeight * 1 + textView.textContainerInset.top + textView.textContainerInset.bottom + 5;
    CGFloat minheight = 35;
    //CGFloat maxheight = textView.font.lineHeight * 4 + textView.textContainerInset.top + textView.textContainerInset.bottom + 5;
    CGFloat maxheight = 80;
    NSLog(@"%f and %f and %f and %@", minheight, maxheight, realheight, NSStringFromCGSize(textRect.size));
    if ((realheight > minheight) && (realheight < maxheight)){
        NSLog(@"first");
        CGRect newViewRect = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), realheight);
        self.frame = newViewRect;
    }
    else if (realheight <= minheight){
        NSLog(@"second");
        CGRect newViewRect = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), minheight);
        self.frame = newViewRect;
    }
    else if (realheight >= maxheight){
        NSLog(@"third");
        CGRect newViewRect = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), maxheight);
        self.frame = newViewRect;
    }
    [self.textView reloadInputViews];
}

- (void) openCameraButtonTouchDown{
    self.openCameraButton.backgroundColor = overBackgroundGray;
}

- (void) openCameraButtonTouchUpOutside{
    self.openCameraButton.backgroundColor = [UIColor clearColor];
}

- (void) openCameraButtonTouchUpInside{
    self.openCameraButton.backgroundColor = [UIColor clearColor];
    [self.delegate CameraKeyboard:self openCamera:self.textView.text];
    self.textView.text = @"";
}

- (void) uploadButtonTouchDown {
    self.uploadButton.backgroundColor = overBackgroundGray;
}

- (void) uploadButtonTouchUpOutside{
    self.uploadButton.backgroundColor = [UIColor clearColor];
}

- (void) uploadButtonTouchUpInside{
    self.uploadButton.backgroundColor = [UIColor clearColor];
    [self.delegate CameraKeyboard:self uploadMedia:self.textView.text];
    self.textView.text = @"";
}

@end
