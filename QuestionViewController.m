//
//  QuestionViewController.m
//  TCUExchange
//
//  Created by Mark Villa on 3/11/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "QuestionViewController.h"

@interface QuestionViewController ()
@property (nonatomic, strong) Coordinates *proximity;
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) NSMutableArray *wallpaper;


@property (nonatomic, strong) UIImageView *tempImageView;
@property (nonatomic, strong) NSNumber *celltag;
@property (nonatomic, strong) UIView *voteOption;
@property (nonatomic, strong) UIView *reportOption;
@property (nonatomic, strong) CAShapeLayer *circleLayer1;
@property (nonatomic, strong) CAShapeLayer *circleLayer2;
@property (nonatomic, strong) UIImageView *circleLayer1Icon;
@property (nonatomic, strong) UIImageView *circleLayer2Icon;

@property UIView *maskViewBackground;
@property UILabel *optionMenuText;

@property CGPoint voteOptionLocation;
@property CGPoint reportOptionLocation;

@property CGPoint initialTouch;
@property CGRect initialGuideFrame;
@property CGRect finalGuideFrame;

@end

@implementation QuestionViewController
//need to make image dynamic to columns
static NSString * const reuseIdentifier1 = @"Cell";
#define VOTEOPTION_COLOR [UIColor redColor]
#define REPORTOPTION_COLOR [UIColor redColor]

static const int ICON_HEIGHT = 15;
static const int OPTIONMENU_HEIGHT = 25;
static const int VOTEICON_HEIGHT = 25;
static const int IMAGE_HEIGHT = 250;
static const int MIN_NONIMAGECELLHEIGHT = 200;
static const int MIN_IMAGECELLHEIGHT = 450;
static int OPTION_MENU_DIVISION = 3;
static int OPTION_VIEW_WIDTH = 55;
static int OPTION_VIEW_HALFWIDTH = 0;
static int OPTION_MENU_RADIUS = 125;
static int OPTION_MENU_INSET = 6;

- (id)initWithArray:(NSMutableArray *) passedmysqlArray initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    NSLog(@"question init");
    self = [super initWithCollectionViewLayout:layout];
    self.mysqlArray = [[NSMutableArray alloc] initWithArray:passedmysqlArray];
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    //self.themeColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.6f];
    self.themeColor = [UIColor lightGrayColor];

    OPTION_VIEW_HALFWIDTH = OPTION_VIEW_WIDTH/2;

    self.voteOption = [[UIView alloc] init];
    self.reportOption = [[UIView alloc] init];
    self.voteOption.backgroundColor = [UIColor clearColor];
    self.reportOption.backgroundColor = [UIColor clearColor];

    self.circleLayer1 = [CAShapeLayer layer];
    [self.circleLayer1 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer1 setFillColor:[[UIColor whiteColor] CGColor]];
    [[self.voteOption layer] addSublayer:self.circleLayer1];

    self.circleLayer1Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Like.png"]];
    self.circleLayer1Icon.image = [self.circleLayer1Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer1Icon setTintColor:overBackgroundGray];
    self.circleLayer1Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.voteOption addSubview:self.circleLayer1Icon];


    self.circleLayer2 = [CAShapeLayer layer];
    [self.circleLayer2 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer2 setFillColor:[[UIColor whiteColor] CGColor]];
    [[self.reportOption layer] addSublayer:self.circleLayer2];
    self.circleLayer2Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ReportOption.png"]];
    self.circleLayer2Icon.image = [self.circleLayer2Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer2Icon setTintColor:overBackgroundGray];
    self.circleLayer2Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.reportOption addSubview:self.circleLayer2Icon];


    NSDictionary *views = @{@"circleLayer1Icon" : self.circleLayer1Icon, @"circleLayer2Icon" : self.circleLayer2Icon,};
    NSArray *cellConstraints;

    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer1Icon]-5-|" options:0 metrics:nil views:views];
    [self.voteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer1Icon]-5-|" options:0 metrics:nil views:views];
    [self.voteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer2Icon]-5-|" options:0 metrics:nil views:views];
    [self.reportOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer2Icon]-5-|" options:0 metrics:nil views:views];
    [self.reportOption addConstraints:cellConstraints];

    return (self);
}

- (void)viewDidLoad {
    NSLog(@"question viewdidload");
    [super viewDidLoad];
    UIImage *backgroundImage = [UIImage imageNamed:@"frog_background"];
    UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
    background.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    background.backgroundColor = backgroundGray;
    UIView *backgroundOverlay = [[UIView alloc] initWithFrame:[background frame]];
    UIImageView *backgroundOverlayMask = [[UIImageView alloc] initWithImage:backgroundImage];
    [backgroundOverlayMask setFrame:[backgroundOverlay bounds]];
    [[backgroundOverlay layer] setMask:[backgroundOverlayMask layer]];
    [backgroundOverlay setBackgroundColor:self.themeColor];
    [background addSubview:backgroundOverlay];

    self.collectionView.backgroundView = background;
    //self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.collectionView setCollectionViewLayout:[[QuestionViewLayout alloc] initWithView:self.view]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier2];
    [self.collectionView reloadData];

    self.tempImageView = [[UIImageView alloc] initWithFrame:self.view.frame];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTouchView)];
    recognizer.cancelsTouchesInView = NO;
    [self.collectionView addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"question viewWillAppear");
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:self.themeColor];
    self.navigationController.hidesBarsOnSwipe = YES;
    [self exchangeData];
    [self proximityProcess];
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"question viewDidAppear");
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [self exchangeData];
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)walpaperData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/wallpaper.php"
       parameters:@{}
          success:^(NSURLSessionDataTask *task, id responseObject) {
              self.wallpaper = responseObject;
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

#pragma mark -  Proximity
// Method for starting coordinate location
- (void)proximityProcess {
    self.proximity = [[Coordinates alloc] init];
    [self.proximity startLocationManager];
}

#pragma - inputAccessoryView methods
// Override canBecomeFirstResponder to allow self to be a responder.
- (bool)canBecomeFirstResponder {
    return true;
}

#pragma - UITapGestureRecognizer method
// Dissmiss the keyboard on "self" touches by making the view the first responder
- (void)didTouchView {
    [self becomeFirstResponder];
}

// Override inputAccessoryView to use KeyboardBar
- (UIView *)inputAccessoryView {
    if(!_inputAccessoryView) {
        _inputAccessoryView = [[KeyboardBar alloc] initWithDelegate:self];
    }
    return _inputAccessoryView;
}

#pragma - KeyboardBarDelegate
- (void)keyboardBar:(KeyboardBar *)keyboardBar sendText:(NSString *)text {
    [self becomeFirstResponder];
    NSDictionary *submitDataDictionary = @{@"submitData":text, @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
    NSDictionary *parameterDictionary = @{@"process": @"submitQuestions", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/service.php"
       parameters:parameterDictionary
          success:^(NSURLSessionDataTask *task, id responseObject) {
              [self exchangeData];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)keyboardBar:(KeyboardBar *)keyboardBar openCamera:(NSString *)text {
    NSLog(@"openCamera");
    CameraViewController *cameraViewController = [[CameraViewController alloc] initWithArray:self.mysqlArray];
    cameraViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:cameraViewController animated:YES];
}

#pragma mark - private methods
- (void)exchangeData {
    NSDictionary *parameterDictionary = @{@"process": self.mysqlArray[0], @"submitData": self.mysqlArray[1], @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/service.php"
       parameters:parameterDictionary
          success:^(NSURLSessionDataTask *task, id responseObject) {
              self.responseArray = (NSMutableArray *)responseObject;
              [self.collectionView reloadData];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.responseArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIView *dateView = [[UIView alloc] init];
    UILabel *dateLabel = [[UILabel alloc] init];
    UIView *locationView = [[UIView alloc] init];
    UILabel *locationLabel = [[UILabel alloc] init];
    UILabel *viewsLabel = [[UILabel alloc] init];
    UIView *viewsView = [[UIView alloc] init];
    UILabel *commentCountLabel = [[UILabel alloc] init];
    UIView *commentCountView = [[UIView alloc] init];
    UILabel *cellLabel = [[UILabel alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    UIView *seperator = [[UIView alloc] init];
    UIView *voteView = [[UIView alloc] init];
    UILabel *voteLabel = [[UILabel alloc] init];
    UIView *optionsView = [[UIView alloc] init];

    //add reuseable cells in the future
    UICollectionViewCell *cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier1 forIndexPath:indexPath];
    [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 0;
    cell.layer.masksToBounds = true;
    cell.tag = [self.responseArray[indexPath.row][0] integerValue];

    dateView.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:dateView];
    UIImageView *dateIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Date.png"]];
    dateIcon.image = [dateIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [dateIcon setTintColor:descriptionGray];
    dateIcon.translatesAutoresizingMaskIntoConstraints = false;
    [dateView addSubview:dateIcon];

    dateLabel.font = sRegularFont;
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = descriptionGray;
    dateLabel.numberOfLines = 0;
    dateLabel.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:dateLabel];

    locationView.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:locationView];
    UIImageView *locationIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Location.png"]];
    locationIcon.image = [locationIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [locationIcon setTintColor:descriptionGray];
    locationIcon.translatesAutoresizingMaskIntoConstraints = false;
    [locationView addSubview:locationIcon];

    locationLabel.font = sRegularFont;
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.textColor = descriptionGray;
    locationLabel.numberOfLines = 0;
    locationLabel.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:locationLabel];

    viewsLabel.font = sRegularFont;
    viewsLabel.backgroundColor = [UIColor clearColor];
    viewsLabel.textColor = descriptionGray;
    viewsLabel.numberOfLines = 0;
    viewsLabel.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:viewsLabel];

    viewsView.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:viewsView];
    UIImageView *viewsIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Views.png"]];
    viewsIcon.image = [viewsIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [viewsIcon setTintColor:descriptionGray];
    viewsIcon.translatesAutoresizingMaskIntoConstraints = false;
    [viewsView addSubview:viewsIcon];

    commentCountLabel.font = sRegularFont;
    commentCountLabel.backgroundColor = [UIColor clearColor];
    commentCountLabel.textColor = descriptionGray;
    commentCountLabel.numberOfLines = 0;
    commentCountLabel.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:commentCountLabel];

    commentCountView.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:commentCountView];
    UIImageView *commentCountIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Comments.png"]];
    commentCountIcon.image = [commentCountIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [commentCountIcon setTintColor:descriptionGray];
    commentCountIcon.translatesAutoresizingMaskIntoConstraints = false;
    [commentCountView addSubview:commentCountIcon];

    imageView.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:imageView];

    cellLabel.font = mRegularFont;
    cellLabel.backgroundColor = [UIColor whiteColor];
    cellLabel.textColor = [UIColor blackColor];
    cellLabel.numberOfLines = 0;
    cellLabel.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:cellLabel];

    seperator.backgroundColor = backgroundGray;
    seperator.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:seperator];

    voteView.tag = indexPath.row;
    voteView.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:voteView];
    UIImageView *voteIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Like.png"]];
    voteIcon.image = [voteIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [voteIcon setTintColor:descriptionGray];
    voteIcon.translatesAutoresizingMaskIntoConstraints = false;
    [voteView addSubview:voteIcon];

    voteLabel.font = sRegularFont;
    voteLabel.backgroundColor = [UIColor whiteColor];
    voteLabel.textColor = descriptionGray;
    voteLabel.numberOfLines = 0;
    voteLabel.tag = indexPath.row;
    voteLabel.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:voteLabel];

    optionsView.translatesAutoresizingMaskIntoConstraints = false;
    [cell.contentView addSubview:optionsView];
    UIImageView *optionsIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Options.png"]];
    optionsIcon.image = [optionsIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [optionsIcon setTintColor:descriptionGray];
    optionsIcon.translatesAutoresizingMaskIntoConstraints = false;
    [optionsView addSubview:optionsIcon];


    NSDictionary *views = NSDictionaryOfVariableBindings(cell, dateView, dateIcon, dateLabel, locationView, locationIcon, locationLabel, viewsLabel, viewsView, viewsIcon, commentCountLabel, commentCountView, commentCountIcon, imageView, cellLabel, seperator, optionsView, optionsIcon, voteView, voteIcon, voteLabel);
    NSArray *cellConstraints;
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[dateView(%d)]-0-[dateLabel]", ICON_HEIGHT] options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[dateIcon]-0-|" options:0 metrics:nil views:views];
    [dateView addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[dateIcon]-0-|" options:0 metrics:nil views:views];
    [dateView addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[locationView(%d)]-0-[locationLabel]", ICON_HEIGHT] options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[locationIcon]-0-|" options:0 metrics:nil views:views];
    [locationView addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[locationIcon]-0-|" options:0 metrics:nil views:views];
    [locationView addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[viewsLabel]-0-[viewsView(%d)]-0-|", ICON_HEIGHT] options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[viewsIcon]-0-|" options:0 metrics:nil views:views];
    [viewsView addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[viewsIcon]-0-|" options:0 metrics:nil views:views];
    [viewsView addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[commentCountLabel]-0-[commentCountView(%d)]-0-|", ICON_HEIGHT] options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[commentCountIcon]-0-|" options:0 metrics:nil views:views];
    [commentCountView addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[commentCountIcon]-0-|" options:0 metrics:nil views:views];
    [commentCountView addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cellLabel(cell)]-0-|" options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[seperator]-5-|" options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[voteView(%d)]-0-[voteLabel]", VOTEICON_HEIGHT] options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[voteIcon]-0-|" options:0 metrics:nil views:views];
    [voteView addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[voteIcon]-0-|" options:0 metrics:nil views:views];
    [voteView addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[optionsView(%d)]-0-|", OPTIONMENU_HEIGHT] options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[optionsIcon]-0-|" options:0 metrics:nil views:views];
    [optionsView addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[optionsIcon]-0-|" options:0 metrics:nil views:views];
    [optionsView addConstraints:cellConstraints];

    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[dateLabel(%d)]-0-[locationLabel(%d)]", ICON_HEIGHT, ICON_HEIGHT] options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[viewsLabel(%d)]-0-[commentCountLabel(%d)]", ICON_HEIGHT, ICON_HEIGHT] options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[viewsView(%d)]-0-[commentCountView(%d)]", ICON_HEIGHT, ICON_HEIGHT] options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[voteView(%d)]-0-|", VOTEICON_HEIGHT] options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[voteLabel(25)]-0-|" options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[optionsView(%d)]-0-|", OPTIONMENU_HEIGHT] options:0 metrics:nil views:views];
    [cell addConstraints:cellConstraints];

    if ([[self.responseArray objectAtIndex:indexPath.row] count] == 8){
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.responseArray[indexPath.row][7]]]
                         placeholderImage:nil
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                      imageView.image = image;
                                  }
                                  failure:nil];
        UITapGestureRecognizer *imageViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewGestureRecHandler:)];
        imageViewGestureRec.numberOfTapsRequired = 1;
        [imageView.viewForFirstBaselineLayout addGestureRecognizer:imageViewGestureRec];
        imageView.userInteractionEnabled = true;

        NSString *constraint = [NSString stringWithFormat:@"V:|-0-[dateView(%d)]-0-[locationView(%d)]-0-[imageView(%d)]-0-[cellLabel]-0-[seperator(1)]-0-[voteView(%d)]-0-|", ICON_HEIGHT, ICON_HEIGHT, IMAGE_HEIGHT, VOTEICON_HEIGHT];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
    }
    else{
        NSString *constraint = [NSString stringWithFormat:@"V:|-0-[dateView(%d)]-0-[locationView(%d)]-0-[imageView(0)]-0-[cellLabel]-0-[seperator(1)]-0-[voteView(%d)]-0-|", ICON_HEIGHT, ICON_HEIGHT, VOTEICON_HEIGHT];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
    }
    dateLabel.text = self.responseArray[indexPath.row][2];
    locationLabel.text = [NSString stringWithFormat:@"%.f Kilometers away from TCU", roundf([self.responseArray[indexPath.row][4] floatValue])];
    viewsLabel.text = self.responseArray[indexPath.row][3];
    commentCountLabel.text = self.responseArray[indexPath.row][6];
    cellLabel.text = self.responseArray[indexPath.row][1];
    voteLabel.text = self.responseArray[indexPath.row][5];

    TouchDownGestureRecognizer *optionsViewGestureRec = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(optionsViewGestureRecHandler:)];
    [optionsView addGestureRecognizer:optionsViewGestureRec];
    UITapGestureRecognizer *voteViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voteViewGestureRecHandler:)];
    voteViewGestureRec.numberOfTapsRequired = 1;
    [voteView.viewForFirstBaselineLayout addGestureRecognizer:voteViewGestureRec];
    voteView.userInteractionEnabled = YES;
    return cell;
}

#pragma mark - UICollectionViewLayoutDelegate
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath {
    NSString *currentlabeltext = self.responseArray[indexPath.row][1];
    CGSize maximumLabelSize = CGSizeMake(self.view.bounds.size.width,MAXFLOAT);
    CGRect textRect = [currentlabeltext boundingRectWithSize:maximumLabelSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                  attributes:@{NSFontAttributeName:lRegularFont}
                                                     context:nil];
    CGSize size = textRect.size;
    if ([[self.responseArray objectAtIndex:indexPath.row] count] == 8){
        if(size.height > MIN_IMAGECELLHEIGHT){
            return size.height;
        }
        else{
            return + MIN_IMAGECELLHEIGHT;
        }
    }
    else{
        if(size.height > MIN_NONIMAGECELLHEIGHT){
            return size.height;
        }
        else{
            return MIN_NONIMAGECELLHEIGHT;
        }
    }
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSNumber *tempIdHolder = self.mysqlArray[2];
    [self.mysqlArray replaceObjectAtIndex:0 withObject:@"messages"];
    [self.mysqlArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:cell.tag]];
    MessageViewController* messageViewController = [[MessageViewController alloc] initWithArray:self.mysqlArray initWithCollectionViewLayout:[[MessageViewLayout alloc] init]];
    [self.mysqlArray replaceObjectAtIndex:2 withObject:tempIdHolder];
    [self.mysqlArray replaceObjectAtIndex:0 withObject:@"questions"];
    messageViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:messageViewController animated:YES];
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

#pragma mark - private methods
- (void)optionsViewGestureRecHandler:(TouchDownGestureRecognizer *)recognizer{
    CGPoint viewTouchLocation = [recognizer locationInView:self.view];
    CGPoint collectionViewTouchLocation = [recognizer locationInView:self.collectionView];
    NSIndexPath *collectionViewIndexPath = [self.collectionView indexPathForItemAtPoint:collectionViewTouchLocation];
    if(recognizer.state == 1) {
        self.celltag = [NSNumber numberWithInteger:[self.collectionView cellForItemAtIndexPath:collectionViewIndexPath].tag];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:collectionViewIndexPath];
        self.maskViewBackground = [[UIView alloc] initWithFrame:self.view.frame];
        self.maskViewBackground.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.8];

        CAShapeLayer *maskShape = [CAShapeLayer layer];
        UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:self.view.frame];
        CGPoint cOrigin = cell.frame.origin;
        CGSize cSize = cell.frame.size;
        CGRect transparentPathFrame = CGRectMake(cOrigin.x, cOrigin.y-self.collectionView.contentOffset.y, cSize.width, cSize.height);
        UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRect:transparentPathFrame];

        CGPoint omLabelOrigin;
        if(cell.frame.origin.y - self.collectionView.contentOffset.y > OPTION_MENU_LABEL_HEIGHT + NAVIGATION_TAB_HEIGHT + STATUSBAR_HEIGHT){
            omLabelOrigin = CGPointMake(self.view.bounds.size.width/2 - OPTION_MENU_LABEL_WIDTH/2, NAVIGATION_TAB_HEIGHT + STATUSBAR_HEIGHT);
        }
        else{
            omLabelOrigin = CGPointMake(self.view.bounds.size.width/2 - OPTION_MENU_LABEL_WIDTH/2, self.view.bounds.size.height - KEYBOARD_HEIGHT - OPTION_MENU_LABEL_HEIGHT);
        }
        CGSize omtSize = CGSizeMake(OPTION_MENU_LABEL_WIDTH, OPTION_MENU_LABEL_HEIGHT);
        self.optionMenuText = [[UILabel alloc] initWithFrame:CGRectMake(omLabelOrigin.x, omLabelOrigin.y, omtSize.width, omtSize.height)];
        self.optionMenuText.text = @"";
        self.optionMenuText.textAlignment = UITextAlignmentCenter;
        [self.optionMenuText setTextColor:[UIColor whiteColor]];
        [self.optionMenuText setBackgroundColor:[UIColor clearColor]];
        [self.optionMenuText setFont:optionMenuFont];
        [self.maskViewBackground addSubview:self.optionMenuText];

        [overlayPath appendPath:transparentPath];
        [overlayPath setUsesEvenOddFillRule:YES];
        maskShape.path = overlayPath.CGPath;
        maskShape.fillRule = kCAFillRuleEvenOdd;
        maskShape.fillColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1].CGColor;
        self.maskViewBackground.layer.mask = maskShape;
        [self.view addSubview:self.maskViewBackground];

        self.initialTouch = CGPointMake(viewTouchLocation.x, viewTouchLocation.y);

        self.voteOptionLocation = [self optionMenuLocationForItemNumber:1 whenTouchLocationIs:self.initialTouch];
        self.reportOptionLocation = [self optionMenuLocationForItemNumber:2 whenTouchLocationIs:self.initialTouch];


        self.voteOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.reportOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);

        [self.view addSubview:self.voteOption];
        [self.view addSubview:self.reportOption];

        [UIView animateWithDuration:.1
                              delay:0.0
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             [self.voteOption setFrame:CGRectMake(self.voteOptionLocation.x,self.voteOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.reportOption setFrame:CGRectMake(self.reportOptionLocation.x,self.reportOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                         }completion:^(BOOL finished){
                         }];
    }
    else if(recognizer.state == 2) {
        if([self touchDistanceFrom:self.voteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: VOTEOPTION_COLOR.CGColor];
            [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer2Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: VOTEOPTION_COLOR.CGColor];
            [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"Like";
        }
        else if([self touchDistanceFrom:self.reportOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer2 setStrokeColor: REPORTOPTION_COLOR.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer2Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer2 setFillColor: REPORTOPTION_COLOR.CGColor];
            self.optionMenuText.text = @"Report";
        }
        else{
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer2Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"";
        }
    }
    else if(recognizer.state == 3) {
        if([self touchDistanceFrom:self.voteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self voteAnimation:recognizer];
            NSDictionary *submitDataDictionary = @{@"celltag":self.celltag, @"vote": [NSNumber numberWithInteger:1], @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
            NSDictionary *parameterDictionary = @{@"process": @"submitQuestionVotes", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:@"http://www.tcuexchange.com/service.php"
               parameters:parameterDictionary
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      [self exchangeData];
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
        }
        else if([self touchDistanceFrom:self.reportOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            NSDictionary *parameterDictionary = @{@"process": @"report", @"submitData": self.mysqlArray[0], @"selectedId": self.celltag, @"userId": self.mysqlArray[3]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:@"http://www.tcuexchange.com/service.php"
               parameters:parameterDictionary
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      [self exchangeData];
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
        }
        [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
        [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
        [self.circleLayer1Icon setTintColor:overBackgroundGray];
        [self.circleLayer2Icon setTintColor:overBackgroundGray];
        [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
        [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
        self.optionMenuText.text = @"";
        [self.voteOption removeFromSuperview];
        [self.reportOption removeFromSuperview];
        [self.maskViewBackground removeFromSuperview];
    }
}

- (int)touchDistanceFrom:(CGPoint)objectLocation withRespectTo:(CGPoint)touch {
    int touchDist =  sqrt(pow((objectLocation.x+OPTION_VIEW_HALFWIDTH)-touch.x,2) + pow((objectLocation.y+OPTION_VIEW_HALFWIDTH)-touch.y,2));
    return touchDist;
}

- (CGPoint)optionMenuLocationForItemNumber:(int)itemNumber whenTouchLocationIs:(CGPoint)touchLocation {
    if(touchLocation.y-(OPTION_MENU_RADIUS*cos(-(OPTION_MENU_DIVISION-1)*M_PI/OPTION_MENU_DIVISION))+OPTION_VIEW_HALFWIDTH > (self.view.bounds.size.height - KEYBOARD_HEIGHT)){
        return CGPointMake(touchLocation.x-(4*OPTION_MENU_INSET+OPTION_VIEW_WIDTH), touchLocation.y-(OPTION_MENU_DIVISION-itemNumber)*(2*OPTION_MENU_INSET+OPTION_VIEW_WIDTH));
    }
    else if(touchLocation.y-(OPTION_MENU_RADIUS*cos(-M_PI/OPTION_MENU_DIVISION))-OPTION_VIEW_HALFWIDTH<STATUSBAR_HEIGHT){
        return CGPointMake(touchLocation.x-(4*OPTION_MENU_INSET+OPTION_VIEW_WIDTH), touchLocation.y+2*OPTION_MENU_INSET+(itemNumber-1)*(OPTION_VIEW_WIDTH+2*OPTION_MENU_INSET));
    }
    else{
        return CGPointMake(touchLocation.x+(OPTION_MENU_RADIUS*sin(-itemNumber*M_PI/(OPTION_MENU_DIVISION))-OPTION_VIEW_HALFWIDTH),touchLocation.y-(OPTION_MENU_RADIUS*cos(-itemNumber*M_PI/OPTION_MENU_DIVISION))-OPTION_VIEW_HALFWIDTH);
    }
}

- (void)voteViewGestureRecHandler:(UIGestureRecognizer *)gestureRecognizer  {
    [self voteAnimation:gestureRecognizer];
    CGPoint collectionViewTouchLocation = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *collectionViewIndexPath = [self.collectionView indexPathForItemAtPoint:collectionViewTouchLocation];
    NSNumber *celltag = [NSNumber numberWithInteger:[self.collectionView cellForItemAtIndexPath:collectionViewIndexPath].tag];
    NSDictionary *submitDataDictionary = @{@"celltag":celltag, @"vote": [NSNumber numberWithInteger:1], @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
    NSDictionary *parameterDictionary = @{@"process": @"submitQuestionVotes", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/service.php"
       parameters:parameterDictionary
          success:^(NSURLSessionDataTask *task, id responseObject) {
              [self exchangeData];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)voteAnimation:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint viewTouchLocation = [gestureRecognizer locationInView:self.view];
    UIImage *image = [UIImage imageNamed:@"Like.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    [imageView setTintColor:color];
    imageView.frame = CGRectMake(viewTouchLocation.x - VOTEICON_HEIGHT/2, viewTouchLocation.y - VOTEICON_HEIGHT/2, VOTEICON_HEIGHT, VOTEICON_HEIGHT);
    [self.view addSubview:imageView];

    [UIView animateWithDuration:.5
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         [imageView setFrame:CGRectMake(viewTouchLocation.x - VOTEICON_HEIGHT/2, 0, VOTEICON_HEIGHT, VOTEICON_HEIGHT)];
                         [imageView setAlpha:0.0f];
                     }completion:^(BOOL finished){
                     }];
}

- (void)imageViewGestureRecHandler:(UIGestureRecognizer *)gestureRecognizer{
    UIImageView *imageView = (UIImageView *)[gestureRecognizer view];
    UITapGestureRecognizer *imageViewSecondGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSecondGestureRecHandler:)];
    imageViewSecondGestureRec.numberOfTapsRequired = 1;
    [self.tempImageView.viewForFirstBaselineLayout addGestureRecognizer:imageViewSecondGestureRec];
    self.tempImageView.userInteractionEnabled = true;
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        self.view.inputAccessoryView.hidden = true;
        self.tempImageView.image = [imageView image];
        [self.view addSubview:self.tempImageView];
    }completion:^(BOOL finished){
    }];
    return;
}

- (void)imageViewSecondGestureRecHandler:(UIGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
        self.view.inputAccessoryView.hidden = false;
        [self.tempImageView removeFromSuperview];
    }completion:^(BOOL finished){
    }];
    return;
}

@end
