//
//  KeyboardBar.m
//  TCU Exchange
//
//  Created by Mark Villa on 1/17/16.
//  Copyright © 2016 Exchange. All rights reserved.
//


#import "KeyboardBar.h"

//#define MAX_HEIGHT 2000

@interface KeyboardBar()
@end

@implementation KeyboardBar

- (id)initWithDelegate:(id<KeyboardBarDelegate>)delegate {
    self = [self init];
    self.delegate = delegate;
    return self;
}

- (id)init {
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self = [self initWithEffect:blurEffect];
    return self;
}

- (id)initWithEffect:(UIVisualEffect *)effect {
    if(self) {
        CGRect screen = [[UIScreen mainScreen] bounds];
        self = [super initWithEffect:effect];
        self.frame = CGRectMake(0,0, CGRectGetWidth(screen), KEYBOARD_HEIGHT);


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


        self.sendButton = [[UIButton alloc] init];
        self.sendButton.translatesAutoresizingMaskIntoConstraints = false;
        self.sendButton.backgroundColor = [UIColor clearColor];
        self.sendButton.layer.cornerRadius = 2.0;
        [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.sendButton addTarget:self action:@selector(sendButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [self.sendButton addTarget:self action:@selector(sendButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self.sendButton addTarget:self action:@selector(sendButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.sendButton];

        NSDictionary *views = @{ @"self" : self, @"textView" : self.textView, @"sendButton" : self.sendButton};
        NSArray *keyboardConstraints;
        keyboardConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[textView]-3-|" options:0 metrics:nil views:views];
        [self addConstraints:keyboardConstraints];

        keyboardConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[sendButton(35)]-0-|" options:0 metrics:nil views:views];
        [self addConstraints:keyboardConstraints];
        keyboardConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[textView]-5-[sendButton(70)]-1-|" options:0 metrics:nil views:views];
        [self addConstraints:keyboardConstraints];
    }
    return self;
}

- (void)keyboardWillShow{
    //NSLog(@"keyboardWillShow");
    //self.backgroundColor = [UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/255 alpha:.5f];
    //self.textView.backgroundColor = [UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/255 alpha:.8f];
}

- (void)keyboardWillHide{
    //NSLog(@"keyboardWillHide");
    //self.backgroundColor = [UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/255 alpha:.1f];
    //self.textView.backgroundColor = [UIColor colorWithRed:220.f/255 green:220.f/255 blue:220.f/255 alpha:.5f];
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

- (void)sendButtonTouchDown {
    self.sendButton.backgroundColor = overBackgroundGray;
}

- (void)sendButtonTouchUpOutside{
    self.sendButton.backgroundColor = [UIColor clearColor];
    //[self.sendButton setTitleColor:[UIColor colorWithRed:180.f/255 green:180.f/255 blue:180.f/255 alpha:1.f] forState:UIControlStateNormal];
}

- (void)sendButtonTouchUpInside{
    self.sendButton.backgroundColor = [UIColor clearColor];
    //[self.sendButton setTitleColor:[UIColor colorWithRed:180.f/255 green:180.f/255 blue:180.f/255 alpha:1.f] forState:UIControlStateNormal];
    [self.delegate keyboardBar:self sendText:self.textView.text];
    self.textView.text = @"";
}

@end
