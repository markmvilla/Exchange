//
//  MessageViewController.m
//  TCUExchange
//
//  Created by Mark Villa on 3/11/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()
@property (nonatomic, strong) Coordinates *proximity;
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;
@property (nonatomic, strong) UIColor *themeColor;

@property (nonatomic, strong) UIImageView *tempImageView;
@property (nonatomic, strong) NSNumber *celltag;
@property (nonatomic, strong) UIView *upvoteOption;
@property (nonatomic, strong) UIView *downvoteOption;
@property (nonatomic, strong) UIView *report;
@property (nonatomic, strong) CAShapeLayer *circleLayer1;
@property (nonatomic, strong) CAShapeLayer *circleLayer2;
@property (nonatomic, strong) CAShapeLayer *circleLayer3;
@property (nonatomic, strong) UIImageView *circleLayer1Icon;
@property (nonatomic, strong) UIImageView *circleLayer2Icon;
@property (nonatomic, strong) UIImageView *circleLayer3Icon;

@property UIView *maskViewBackground;
@property UILabel *optionMenuText;

@property CGPoint upvoteOptionLocation;
@property CGPoint downvoteOptionLocation;
@property CGPoint reportLocation;

@property  CGPoint initialTouch;
@property CGRect initialGuideFrame;
@property CGRect finalGuideFrame;

@end

@implementation MessageViewController
//need to make image dynamic to columns
static NSString * const reuseIdentifier1 = @"Cell";
#define UPVOTEOPTION_COLOR [UIColor greenColor]
#define DOWNVOTEOPTION_COLOR [UIColor redColor]
#define REPORTOPTION_COLOR [UIColor redColor]

static const int ICON_HEIGHT = 15;
static const int OPTIONMENU_HEIGHT = 25;
static const int VOTEICON_HEIGHT = 25;
static const int IMAGE_HEIGHT = 250;
static const int MIN_NONIMAGECELLHEIGHT = 200;
static const int MIN_IMAGECELLHEIGHT = 450;
static int OPTION_MENU_DIVISION = 4;
static int OPTION_VIEW_WIDTH = 55;
static int OPTION_VIEW_HALFWIDTH = 0;
static int OPTION_MENU_RADIUS = 125;
static int OPTION_MENU_INSET = 6;

- (id)initWithArray:(NSMutableArray *) passedmysqlArray initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    self.mysqlArray = [[NSMutableArray alloc] initWithArray:passedmysqlArray];
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    //self.themeColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.6f];
    self.themeColor = [UIColor lightGrayColor];

    OPTION_VIEW_HALFWIDTH = OPTION_VIEW_WIDTH/2;

    self.upvoteOption = [[UIView alloc] init];
    self.upvoteOption.tag = 1;
    self.downvoteOption = [[UIView alloc] init];
    self.downvoteOption.tag = -1;
    self.report = [[UIView alloc] init];
    self.upvoteOption.backgroundColor = [UIColor clearColor];
    self.downvoteOption.backgroundColor = [UIColor clearColor];
    self.report.backgroundColor = [UIColor clearColor];

    self.circleLayer1 = [CAShapeLayer layer];
    [self.circleLayer1 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer1 setFillColor:[[UIColor whiteColor] CGColor]];
    [[self.upvoteOption layer] addSublayer:self.circleLayer1];
    self.circleLayer1Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UpArrow.png"]];
    self.circleLayer1Icon.image = [self.circleLayer1Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer1Icon setTintColor:overBackgroundGray];
    self.circleLayer1Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.upvoteOption addSubview:self.circleLayer1Icon];

    self.circleLayer2 = [CAShapeLayer layer];
    [self.circleLayer2 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer2 setFillColor:[[UIColor whiteColor] CGColor]];
    [[self.downvoteOption layer] addSublayer:self.circleLayer2];
    self.circleLayer2Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DownArrow.png"]];
    self.circleLayer2Icon.image = [self.circleLayer2Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer2Icon setTintColor:overBackgroundGray];
    self.circleLayer2Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.downvoteOption addSubview:self.circleLayer2Icon];

    self.circleLayer3 = [CAShapeLayer layer];
    [self.circleLayer3 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer3 setFillColor:[[UIColor whiteColor] CGColor]];
    [[self.report layer] addSublayer:self.circleLayer3];
    self.circleLayer3Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ReportOption.png"]];
    self.circleLayer3Icon.image = [self.circleLayer3Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer3Icon setTintColor:overBackgroundGray];
    self.circleLayer3Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.report addSubview:self.circleLayer3Icon];


    NSDictionary *views = @{@"circleLayer1Icon" : self.circleLayer1Icon, @"circleLayer2Icon" : self.circleLayer2Icon, @"circleLayer3Icon" : self.circleLayer3Icon};
    NSArray *cellConstraints;

    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer1Icon]-5-|" options:0 metrics:nil views:views];
    [self.upvoteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer1Icon]-5-|" options:0 metrics:nil views:views];
    [self.upvoteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer2Icon]-5-|" options:0 metrics:nil views:views];
    [self.downvoteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer2Icon]-5-|" options:0 metrics:nil views:views];
    [self.downvoteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer3Icon]-5-|" options:0 metrics:nil views:views];
    [self.report addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer3Icon]-5-|" options:0 metrics:nil views:views];
    [self.report addConstraints:cellConstraints];

    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
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
    */
    //self.collectionView.backgroundView = background;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.collectionView setCollectionViewLayout:[[MessageViewLayout alloc] initWithView:self.view]];
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
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:self.themeColor];
    self.navigationController.hidesBarsOnSwipe = YES;
    [self exchangeData];
    [self proximityProcess];
}

-(void)viewDidAppear:(BOOL)animated{
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

#pragma mark -  Proximity
// Method for starting coordinate location  and adding observer
-(void)proximityProcess {
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
    NSDictionary *parameterDictionary = @{@"process": @"submitMessages", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
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
    //add reuseable cells in the future
    UICollectionViewCell *cell = nil;
    if(indexPath.row == 0){
        UILabel *originalPostLabel = [[UILabel alloc] init];
        UIView *originalPostSeperator = [[UIView alloc] init];
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
        UILabel *classLabel = [[UILabel alloc] init];
        UIView *voteView = [[UIView alloc] init];
        UILabel *voteLabel = [[UILabel alloc] init];

        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.cornerRadius = 0;
        cell.layer.masksToBounds = true;
        cell.tag = [self.responseArray[indexPath.row][0] integerValue];

        originalPostLabel.font = sBRegularFont;
        originalPostLabel.backgroundColor = [UIColor clearColor];
        originalPostLabel.textColor = overBackgroundGray;
        originalPostLabel.text = @"Original Post";
        originalPostLabel.numberOfLines = 0;
        originalPostLabel.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:originalPostLabel];

        originalPostSeperator.backgroundColor = overBackgroundGray;
        originalPostSeperator.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:originalPostSeperator];

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

        classLabel.font = sRegularFont;
        classLabel.backgroundColor = [UIColor clearColor];
        classLabel.textColor = [UIColor colorWithRed:180.f/255 green:180.f/255 blue:180.f/255 alpha:1.f];
        classLabel.numberOfLines = 0;
        classLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:classLabel];

        voteView.tag = 1;
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


        NSDictionary *views = NSDictionaryOfVariableBindings(cell, originalPostLabel, originalPostSeperator, dateView, dateIcon, dateLabel, locationView, locationIcon, locationLabel, viewsLabel, viewsView, viewsIcon, commentCountLabel, commentCountView, commentCountIcon, imageView, cellLabel, seperator, classLabel, voteView, voteIcon, voteLabel);
        NSArray *cellConstraints;
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[originalPostLabel]"] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[originalPostSeperator]-0-|" options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
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
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[classLabel]-0-|" options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[voteView(%d)]-0-[voteLabel]", VOTEICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[voteIcon]-0-|" options:0 metrics:nil views:views];
        [voteView addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[voteIcon]-0-|" options:0 metrics:nil views:views];
        [voteView addConstraints:cellConstraints];

        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[originalPostSeperator(1)]-2-[dateLabel(%d)]-0-[locationLabel(%d)]", ICON_HEIGHT, ICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[originalPostSeperator(1)]-2-[viewsLabel(%d)]-0-[commentCountLabel(%d)]", ICON_HEIGHT, ICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[originalPostSeperator(1)]-2-[viewsView(%d)]-0-[commentCountView(%d)]", ICON_HEIGHT, ICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[voteView(%d)]-0-|", VOTEICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[voteLabel(25)]-0-|" options:0 metrics:nil views:views];
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

            NSString *constraint = [NSString stringWithFormat:@"V:|-0-[originalPostLabel(%d)]-2-[originalPostSeperator(2)]-2-[dateView(%d)]-0-[locationView(%d)]-0-[imageView(%d)]-0-[cellLabel]-0-[seperator(1)]-0-[classLabel(25)]-0-[voteView(%d)]-0-|", ICON_HEIGHT, ICON_HEIGHT, ICON_HEIGHT, IMAGE_HEIGHT, VOTEICON_HEIGHT];
            cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views];
            [cell addConstraints:cellConstraints];
        }
        else{
            NSString *constraint = [NSString stringWithFormat:@"V:|-0-[originalPostLabel(%d)]-2-[originalPostSeperator(2)]-2-[dateView(%d)]-0-[locationView(%d)]-0-[imageView(0)]-0-[cellLabel]-0-[seperator(1)]-0-[classLabel(25)]-0-[voteView(%d)]-0-|", ICON_HEIGHT, ICON_HEIGHT, ICON_HEIGHT, VOTEICON_HEIGHT];
            cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views];
            [cell addConstraints:cellConstraints];
        }
        dateLabel.text = self.responseArray[indexPath.row][2];
        locationLabel.text = [NSString stringWithFormat:@"%.f Kilometers away from TCU", roundf([self.responseArray[indexPath.row][4] floatValue])];
        viewsLabel.text = self.responseArray[indexPath.row][3];
        commentCountLabel.text = self.responseArray[indexPath.row][6];
        cellLabel.text = self.responseArray[indexPath.row][1];
        voteLabel.text = self.responseArray[indexPath.row][5];

        UITapGestureRecognizer *voteViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voteViewGestureRecHandler:)];
        voteViewGestureRec.numberOfTapsRequired = 1;
        [voteView.viewForFirstBaselineLayout addGestureRecognizer:voteViewGestureRec];
        voteView.userInteractionEnabled = YES;
    }
    else{
        UIView *dateView = [[UIView alloc] init];
        UILabel *dateLabel = [[UILabel alloc] init];
        UIView *locationView = [[UIView alloc] init];
        UILabel *locationLabel = [[UILabel alloc] init];
        UILabel *cellLabel = [[UILabel alloc] init];
        UIImageView *imageView = [[UIImageView alloc] init];
        UIView *seperator = [[UIView alloc] init];
        UIView *upvoteOptionView = [[UIView alloc] init];
        UILabel *voteLabel = [[UILabel alloc] init];
        UIView *downvoteOptionView = [[UIView alloc] init];
        UIView *optionsView = [[UIView alloc] init];

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

        upvoteOptionView.tag = 1;
        upvoteOptionView.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:upvoteOptionView];
        UIImageView *upvoteOptionIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UpArrow.png"]];
        upvoteOptionIcon.image = [upvoteOptionIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [upvoteOptionIcon setTintColor:descriptionGray];
        upvoteOptionIcon.translatesAutoresizingMaskIntoConstraints = false;
        [upvoteOptionView addSubview:upvoteOptionIcon];

        voteLabel.font = lBRegularFont;
        voteLabel.backgroundColor = [UIColor clearColor];
        voteLabel.textColor = descriptionGray;
        voteLabel.textAlignment = NSTextAlignmentCenter;
        voteLabel.numberOfLines = 0;
        voteLabel.tag = indexPath.row;
        voteLabel.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:voteLabel];

        downvoteOptionView.tag = -1;
        downvoteOptionView.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:downvoteOptionView];
        UIImageView *downvoteOptionIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DownArrow.png"]];
        downvoteOptionIcon.image = [downvoteOptionIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [downvoteOptionIcon setTintColor:descriptionGray];
        downvoteOptionIcon.translatesAutoresizingMaskIntoConstraints = false;
        [downvoteOptionView addSubview:downvoteOptionIcon];

        optionsView.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:optionsView];
        UIImageView *optionsIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Options.png"]];
        optionsIcon.image = [optionsIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [optionsIcon setTintColor:descriptionGray];
        optionsIcon.translatesAutoresizingMaskIntoConstraints = false;
        [optionsView addSubview:optionsIcon];

        NSDictionary *views = NSDictionaryOfVariableBindings(cell, dateView, dateIcon, dateLabel, locationView, locationIcon, locationLabel, imageView, cellLabel, seperator, optionsView, optionsIcon, upvoteOptionView, upvoteOptionIcon, voteLabel, downvoteOptionView, downvoteOptionIcon);
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
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cellLabel(cell)]-0-|" options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[seperator]-5-|" options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[upvoteOptionView(%D)]", VOTEICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[upvoteOptionIcon]-0-|" options:0 metrics:nil views:views];
        [upvoteOptionView addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[upvoteOptionIcon]-0-|" options:0 metrics:nil views:views];
        [upvoteOptionView addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[voteLabel(%d)]", VOTEICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[downvoteOptionView(%D)]", VOTEICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[downvoteOptionIcon]-0-|" options:0 metrics:nil views:views];
        [downvoteOptionView addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[downvoteOptionIcon]-0-|" options:0 metrics:nil views:views];
        [downvoteOptionView addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[optionsView(%d)]-0-|", OPTIONMENU_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[optionsIcon]-0-|" options:0 metrics:nil views:views];
        [optionsView addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[optionsIcon]-0-|" options:0 metrics:nil views:views];
        [optionsView addConstraints:cellConstraints];

        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[dateLabel(%d)]-0-[locationLabel(%d)]", ICON_HEIGHT, ICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[upvoteOptionView(%d)]-0-[voteLabel(25)]-0-[downvoteOptionView(%d)]-0-|", VOTEICON_HEIGHT, VOTEICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[optionsView(%d)]-0-|", OPTIONMENU_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];

        if ([[self.responseArray objectAtIndex:indexPath.row] count] == 6){
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.responseArray[indexPath.row][5]]]
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          imageView.image = image;
                                      }
                                      failure:nil];

            UITapGestureRecognizer *imageViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewGestureRecHandler:)];
            imageViewGestureRec.numberOfTapsRequired = 1;
            [imageView.viewForFirstBaselineLayout addGestureRecognizer:imageViewGestureRec];
            imageView.userInteractionEnabled = true;

            NSString *constraint = [NSString stringWithFormat:@"V:|-0-[dateView(%d)]-0-[locationView(%d)]-0-[imageView(%d)]-0-[cellLabel]-0-[seperator(1)]-0-[upvoteOptionView(%d)]-0-[voteLabel(25)]-0-[downvoteOptionView(%d)]-0-|", ICON_HEIGHT, ICON_HEIGHT, IMAGE_HEIGHT, VOTEICON_HEIGHT, VOTEICON_HEIGHT];
            cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views];
            [cell addConstraints:cellConstraints];
        }
        else{
            NSString *constraint = [NSString stringWithFormat:@"V:|-0-[dateView(%d)]-0-[locationView(%d)]-0-[imageView(0)]-0-[cellLabel]-0-[seperator(1)]-0-[upvoteOptionView(%d)]-0-[voteLabel(25)]-0-[downvoteOptionView(%d)]-0-|", ICON_HEIGHT, ICON_HEIGHT, VOTEICON_HEIGHT, VOTEICON_HEIGHT];
            cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views];
            [cell addConstraints:cellConstraints];
        }
        dateLabel.text = self.responseArray[indexPath.row][2];
        locationLabel.text = [NSString stringWithFormat:@"%.f Kilometers away from TCU", roundf([self.responseArray[indexPath.row][3] floatValue])];
        cellLabel.text = self.responseArray[indexPath.row][1];
        voteLabel.text = self.responseArray[indexPath.row][4];

        TouchDownGestureRecognizer *optionsViewGestureRec = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(optionsViewGestureRecHandler:)];
        [optionsView addGestureRecognizer:optionsViewGestureRec];

        UITapGestureRecognizer *upvoteOptionViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upvoteOptionViewGestureRecHandler:)];
        upvoteOptionViewGestureRec.numberOfTapsRequired = 1;
        [upvoteOptionView.viewForFirstBaselineLayout addGestureRecognizer:upvoteOptionViewGestureRec];
        upvoteOptionView.userInteractionEnabled = YES;

        UITapGestureRecognizer *novoteOptionViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(novoteOptionViewGestureRecHandler:)];
        novoteOptionViewGestureRec.numberOfTapsRequired = 1;
        [voteLabel.viewForFirstBaselineLayout addGestureRecognizer:novoteOptionViewGestureRec];
        voteLabel.userInteractionEnabled = YES;

        UITapGestureRecognizer *downvoteOptionViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downvoteOptionViewGestureRecHandler:)];
        downvoteOptionViewGestureRec.numberOfTapsRequired = 1;
        [downvoteOptionView.viewForFirstBaselineLayout addGestureRecognizer:downvoteOptionViewGestureRec];
        downvoteOptionView.userInteractionEnabled = YES;
    }
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
    if(indexPath.row ==0){
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
    else{
        if ([[self.responseArray objectAtIndex:indexPath.row] count] == 6){
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

        self.upvoteOptionLocation = [self optionMenuLocationForItemNumber:1 whenTouchLocationIs:self.initialTouch];
        self.downvoteOptionLocation = [self optionMenuLocationForItemNumber:2 whenTouchLocationIs:self.initialTouch];
        self.reportLocation = [self optionMenuLocationForItemNumber:3 whenTouchLocationIs:self.initialTouch];


        self.upvoteOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.downvoteOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.report.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);

        [self.view addSubview:self.upvoteOption];
        [self.view addSubview:self.downvoteOption];
        [self.view addSubview:self.report];

        [UIView animateWithDuration:.1
                              delay:0.0
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             [self.upvoteOption setFrame:CGRectMake(self.upvoteOptionLocation.x,self.upvoteOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.downvoteOption setFrame:CGRectMake(self.downvoteOptionLocation.x,self.downvoteOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.report setFrame:CGRectMake(self.reportLocation.x,self.reportLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                         }completion:^(BOOL finished){
                         }];
    }
    else if(recognizer.state == 2) {
        if([self touchDistanceFrom:self.upvoteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: UPVOTEOPTION_COLOR.CGColor];
            [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer2Icon setTintColor:overBackgroundGray];
            [self.circleLayer3Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: UPVOTEOPTION_COLOR.CGColor];
            [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer3 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"Upvote";
        }
        else if([self touchDistanceFrom:self.downvoteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer2 setStrokeColor: DOWNVOTEOPTION_COLOR.CGColor];
            [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer2Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer3Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer2 setFillColor: DOWNVOTEOPTION_COLOR.CGColor];
            [self.circleLayer3 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"Downvote";
        }
        else if([self touchDistanceFrom:self.reportLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer3 setStrokeColor: REPORTOPTION_COLOR.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer2Icon setTintColor:overBackgroundGray];
            [self.circleLayer3Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer3 setFillColor: REPORTOPTION_COLOR.CGColor];
            self.optionMenuText.text = @"Report";
        }
        else{
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer2Icon setTintColor:overBackgroundGray];
            [self.circleLayer3Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer3 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"";
        }
    }
    else if(recognizer.state == 3) {
        if([self touchDistanceFrom:self.upvoteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self voteAnimation:recognizer];
            NSDictionary *submitDataDictionary = @{@"celltag":self.celltag, @"vote": [NSNumber numberWithInteger:1], @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
            NSDictionary *parameterDictionary = @{@"process": @"submitMessageVotes", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
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
        else if([self touchDistanceFrom:self.downvoteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self voteAnimation:recognizer];
            NSDictionary *submitDataDictionary = @{@"celltag":self.celltag, @"vote": [NSNumber numberWithInteger:-1], @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
            NSDictionary *parameterDictionary = @{@"process": @"submitMessageVotes", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
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
        else if([self touchDistanceFrom:self.reportLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
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
        [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
        [self.circleLayer1Icon setTintColor:overBackgroundGray];
        [self.circleLayer2Icon setTintColor:overBackgroundGray];
        [self.circleLayer3Icon setTintColor:overBackgroundGray];
        [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
        [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
        [self.circleLayer3 setFillColor: [UIColor whiteColor].CGColor];
        self.optionMenuText.text = @"";
        [self.upvoteOption removeFromSuperview];
        [self.downvoteOption removeFromSuperview];
        [self.report removeFromSuperview];
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

- (void)upvoteOptionViewGestureRecHandler:(UIGestureRecognizer *)gestureRecognizer  {
    [self voteAnimation:gestureRecognizer];
    CGPoint collectionViewTouchLocation = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *collectionViewIndexPath = [self.collectionView indexPathForItemAtPoint:collectionViewTouchLocation];
    NSNumber *celltag = [NSNumber numberWithInteger:[self.collectionView cellForItemAtIndexPath:collectionViewIndexPath].tag];
    NSDictionary *submitDataDictionary = @{@"celltag":celltag, @"vote": [NSNumber numberWithInteger:1], @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
    NSDictionary *parameterDictionary = @{@"process": @"submitMessageVotes", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
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

- (void)novoteOptionViewGestureRecHandler:(UIGestureRecognizer *)gestureRecognizer  {
    CGPoint collectionViewTouchLocation = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *collectionViewIndexPath = [self.collectionView indexPathForItemAtPoint:collectionViewTouchLocation];
    NSNumber *celltag = [NSNumber numberWithInteger:[self.collectionView cellForItemAtIndexPath:collectionViewIndexPath].tag];
    NSDictionary *submitDataDictionary = @{@"celltag":celltag, @"vote": [NSNumber numberWithInteger:0], @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
    NSDictionary *parameterDictionary = @{@"process": @"submitMessageVotes", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
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

- (void)downvoteOptionViewGestureRecHandler:(UIGestureRecognizer *)gestureRecognizer  {
    [self voteAnimation:gestureRecognizer];
    CGPoint collectionViewTouchLocation = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *collectionViewIndexPath = [self.collectionView indexPathForItemAtPoint:collectionViewTouchLocation];
    NSNumber *celltag = [NSNumber numberWithInteger:[self.collectionView cellForItemAtIndexPath:collectionViewIndexPath].tag];
    NSDictionary *submitDataDictionary = @{@"celltag":celltag, @"vote": [NSNumber numberWithInteger:-1], @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
    NSDictionary *parameterDictionary = @{@"process": @"submitMessageVotes", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
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

-(void) voteAnimation:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint viewTouchLocation = [gestureRecognizer locationInView:self.view];
    CGPoint collectionViewTouchLocation = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *collectionViewIndexPath = [self.collectionView indexPathForItemAtPoint:collectionViewTouchLocation];
    if(gestureRecognizer.view.tag==1){
        UIImage *image;
        if(collectionViewIndexPath.row == 0){
            image = [UIImage imageNamed:@"Like.png"];
        }
        else{
            image = [UIImage imageNamed:@"UpArrow.png"];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [imageView setTintColor:color];
        imageView.frame = CGRectMake(viewTouchLocation.x-VOTEICON_HEIGHT/2, viewTouchLocation.y - VOTEICON_HEIGHT/2, VOTEICON_HEIGHT, VOTEICON_HEIGHT);
        [self.view addSubview:imageView];

        [UIView animateWithDuration:.5
                              delay:0.0
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             [imageView setFrame:CGRectMake(viewTouchLocation.x-VOTEICON_HEIGHT/2, 0, VOTEICON_HEIGHT, VOTEICON_HEIGHT)];
                             [imageView setAlpha:0.0f];
                         }completion:^(BOOL finished){
                         }];
    }
    else if(gestureRecognizer.view.tag==-1){
        UIImage *image = [UIImage imageNamed:@"DownArrow.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

        CGFloat hue = ( arc4random() % 256 / 256.0 );
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [imageView setTintColor:color];
        imageView.frame = CGRectMake(viewTouchLocation.x-VOTEICON_HEIGHT/2, viewTouchLocation.y-VOTEICON_HEIGHT/2, VOTEICON_HEIGHT, VOTEICON_HEIGHT);
        [self.view addSubview:imageView];

        [UIView animateWithDuration:.5
                              delay:0.0
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             [imageView setFrame:CGRectMake(viewTouchLocation.x-VOTEICON_HEIGHT/2, self.view.frame.size.height, VOTEICON_HEIGHT, VOTEICON_HEIGHT)];
                             [imageView setAlpha:0.0f];
                         }completion:^(BOOL finished){
                         }];

    }
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
