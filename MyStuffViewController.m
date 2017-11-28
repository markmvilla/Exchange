//
//  MyStuffViewController.m
//  TCUExchange
//
//  Created by Mark Villa on 3/5/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "MyStuffViewController.h"

//#define SUBJECT_TAG 1

@interface MyStuffViewController ()
@property (nonatomic, strong) Coordinates *proximity;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MyStuffViewLayout *myStuffViewLayout;
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) UIButton *questionsTab;
@property (nonatomic, strong) UIButton *messagesTab;
@property int responseArrayFullLength;
@property (nonatomic, strong) UIView *tabLine;

@property (nonatomic, strong) UIImageView *tempImageView;
@property (nonatomic, strong) NSNumber *celltag;
@property (nonatomic, strong) UIView *contextOption;
@property (nonatomic, strong) UIView *voteOption;
@property (nonatomic, strong) UIView *upvoteOption;
@property (nonatomic, strong) UIView *downvoteOption;
@property (nonatomic, strong) UIView *editOption;
@property (nonatomic, strong) UIView *deleteOption;
@property (nonatomic, strong) UIView *reportOption;
@property (nonatomic, strong) CAShapeLayer *circleLayer1;
@property (nonatomic, strong) CAShapeLayer *circleLayer2;
@property (nonatomic, strong) CAShapeLayer *circleLayer3;
@property (nonatomic, strong) CAShapeLayer *circleLayer4;
@property (nonatomic, strong) CAShapeLayer *circleLayer5;
@property (nonatomic, strong) CAShapeLayer *circleLayer6;
@property (nonatomic, strong) CAShapeLayer *circleLayer7;
@property (nonatomic, strong) UIImageView *circleLayer1Icon;
@property (nonatomic, strong) UIImageView *circleLayer2Icon;
@property (nonatomic, strong) UIImageView *circleLayer3Icon;
@property (nonatomic, strong) UIImageView *circleLayer4Icon;
@property (nonatomic, strong) UIImageView *circleLayer5Icon;
@property (nonatomic, strong) UIImageView *circleLayer6Icon;
@property (nonatomic, strong) UIImageView *circleLayer7Icon;

@property UIView *maskViewBackground;
@property UILabel *optionMenuText;

@property CGPoint contextOptionLocation;
@property CGPoint voteOptionLocation;
@property CGPoint upvoteOptionLocation;
@property CGPoint downvoteOptionLocation;
@property CGPoint editOptionLocation;
@property CGPoint deleteOptionLocation;
@property CGPoint reportOptionLocation;

@property  CGPoint initialTouch;
@property CGRect initialGuideFrame;
@property CGRect finalGuideFrame;

@end

@implementation MyStuffViewController
//need to make image dynamic to columns
#define CONTEXTOPTION_COLOR [UIColor blueColor]
#define VOTEOPTION_COLOR [UIColor redColor]
#define UPVOTEOPTION_COLOR [UIColor greenColor]
#define DOWNVOTEOPTION_COLOR [UIColor redColor]
#define EDITOPTION_COLOR [UIColor yellowColor]
#define DELETEOPTION_COLOR [UIColor redColor]
#define REPORTOPTION_COLOR [UIColor redColor]

static NSString * const reuseIdentifier1 = @"Cell";
static const int TABBAR_HEIGHT = 49;
static const int ICON_HEIGHT = 15;
static const int OPTIONMENU_HEIGHT = 25;
static const int VOTEICON_HEIGHT = 25;
static const int IMAGE_HEIGHT = 250;
static const int MIN_NONIMAGECELLHEIGHT = 200;
static const int MIN_IMAGECELLHEIGHT = 450;
static const int MYSTUFFTAB_HEIGHT = 40;
static int OPTION_MENU_DIVISION = 6;
static int OPTION_VIEW_WIDTH = 55;
static int OPTION_VIEW_HALFWIDTH = 0;
static int OPTION_MENU_RADIUS = 135;
static int OPTION_MENU_INSET = 6;

- (id)initWithArray:(NSMutableArray *) passedmysqlArray {
    NSLog(@"MyStuff init");
    if (!(self = [super init])) {
        return (nil);
    }
    self.mysqlArray = [[NSMutableArray alloc] initWithArray:passedmysqlArray];
    [self.mysqlArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"myquestions"]];
    self.title = @"My Stuff";
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    //self.themeColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.6f];
    self.themeColor = [UIColor lightGrayColor];

    OPTION_VIEW_HALFWIDTH = OPTION_VIEW_WIDTH/2;

    self.contextOption = [[UIView alloc] init];
    self.voteOption = [[UIView alloc] init];
    self.upvoteOption = [[UIView alloc] init];
    self.upvoteOption.tag = 1;
    self.downvoteOption = [[UIView alloc] init];
    self.downvoteOption.tag = -1;
    self.editOption = [[UIView alloc] init];
    self.deleteOption = [[UIView alloc] init];
    self.reportOption = [[UIView alloc] init];
    self.contextOption.backgroundColor = [UIColor clearColor];
    self.voteOption.backgroundColor = [UIColor clearColor];
    self.upvoteOption.backgroundColor = [UIColor clearColor];
    self.downvoteOption.backgroundColor = [UIColor clearColor];
    self.editOption.backgroundColor = [UIColor clearColor];
    self.deleteOption.backgroundColor = [UIColor clearColor];
    self.reportOption.backgroundColor = [UIColor clearColor];


    self.circleLayer1 = [CAShapeLayer layer];
    [self.circleLayer1 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer1 setFillColor:[[UIColor clearColor] CGColor]];
    self.circleLayer1.shadowRadius = 5.0;
    [[self.contextOption layer] addSublayer:self.circleLayer1];
    self.circleLayer1Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ContextOption.png"]];
    self.circleLayer1Icon.image = [self.circleLayer1Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer1Icon setTintColor:overBackgroundGray];
    self.circleLayer1Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.contextOption addSubview:self.circleLayer1Icon];

    self.circleLayer2 = [CAShapeLayer layer];
    [self.circleLayer2 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer2 setFillColor:[[UIColor clearColor] CGColor]];
    [[self.voteOption layer] addSublayer:self.circleLayer2];
    self.circleLayer2Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Like.png"]];
    self.circleLayer2Icon.image = [self.circleLayer2Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer2Icon setTintColor:overBackgroundGray];
    self.circleLayer2Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.voteOption addSubview:self.circleLayer2Icon];

    self.circleLayer3 = [CAShapeLayer layer];
    [self.circleLayer3 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer3 setFillColor:[[UIColor clearColor] CGColor]];
    [[self.upvoteOption layer] addSublayer:self.circleLayer3];
    self.circleLayer3Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UpArrow.png"]];
    self.circleLayer3Icon.image = [self.circleLayer3Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer3Icon setTintColor:overBackgroundGray];
    self.circleLayer3Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.upvoteOption addSubview:self.circleLayer3Icon];

    self.circleLayer4 = [CAShapeLayer layer];
    [self.circleLayer4 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer4 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer4 setFillColor:[[UIColor clearColor] CGColor]];
    [[self.downvoteOption layer] addSublayer:self.circleLayer4];
    self.circleLayer4Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DownArrow.png"]];
    self.circleLayer4Icon.image = [self.circleLayer4Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer4Icon setTintColor:overBackgroundGray];
    self.circleLayer4Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.downvoteOption addSubview:self.circleLayer4Icon];

    self.circleLayer5 = [CAShapeLayer layer];
    [self.circleLayer5 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer5 setFillColor:[[UIColor clearColor] CGColor]];
    [[self.editOption layer] addSublayer:self.circleLayer5];
    self.circleLayer5Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"EditOption.png"]];
    self.circleLayer5Icon.image = [self.circleLayer5Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer5Icon setTintColor:overBackgroundGray];
    self.circleLayer5Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.editOption addSubview:self.circleLayer5Icon];

    self.circleLayer6 = [CAShapeLayer layer];
    [self.circleLayer6 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer6 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer6 setFillColor:[[UIColor clearColor] CGColor]];
    [[self.deleteOption layer] addSublayer:self.circleLayer6];
    self.circleLayer6Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DeleteOption.png"]];
    self.circleLayer6Icon.image = [self.circleLayer6Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer6Icon setTintColor:overBackgroundGray];
    self.circleLayer6Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.deleteOption addSubview:self.circleLayer6Icon];

    self.circleLayer7 = [CAShapeLayer layer];
    [self.circleLayer7 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)] CGPath]];
    [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
    [self.circleLayer7 setFillColor:[[UIColor clearColor] CGColor]];
    [[self.reportOption layer] addSublayer:self.circleLayer7];
    self.circleLayer7Icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ReportOption.png"]];
    self.circleLayer7Icon.image = [self.circleLayer7Icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.circleLayer7Icon setTintColor:overBackgroundGray];
    self.circleLayer7Icon.translatesAutoresizingMaskIntoConstraints = false;
    [self.reportOption addSubview:self.circleLayer7Icon];


    NSDictionary *views = @{@"circleLayer1Icon" : self.circleLayer1Icon, @"circleLayer2Icon" : self.circleLayer2Icon, @"circleLayer3Icon" : self.circleLayer3Icon, @"circleLayer4Icon" : self.circleLayer4Icon, @"circleLayer5Icon" : self.circleLayer5Icon, @"circleLayer6Icon" : self.circleLayer6Icon, @"circleLayer7Icon" : self.circleLayer7Icon};
    NSArray *cellConstraints;

    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer1Icon]-5-|" options:0 metrics:nil views:views];
    [self.contextOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer1Icon]-5-|" options:0 metrics:nil views:views];
    [self.contextOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer2Icon]-5-|" options:0 metrics:nil views:views];
    [self.voteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer2Icon]-5-|" options:0 metrics:nil views:views];
    [self.voteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer3Icon]-5-|" options:0 metrics:nil views:views];
    [self.upvoteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer3Icon]-5-|" options:0 metrics:nil views:views];
    [self.upvoteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer4Icon]-5-|" options:0 metrics:nil views:views];
    [self.downvoteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer4Icon]-5-|" options:0 metrics:nil views:views];
    [self.downvoteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer5Icon]-5-|" options:0 metrics:nil views:views];
    [self.editOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer5Icon]-5-|" options:0 metrics:nil views:views];
    [self.editOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer6Icon]-5-|" options:0 metrics:nil views:views];
    [self.deleteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer6Icon]-5-|" options:0 metrics:nil views:views];
    [self.deleteOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[circleLayer7Icon]-5-|" options:0 metrics:nil views:views];
    [self.reportOption addConstraints:cellConstraints];
    cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[circleLayer7Icon]-5-|" options:0 metrics:nil views:views];
    [self.reportOption addConstraints:cellConstraints];
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect collectionViewFrame = CGRectMake(0, MYSTUFFTAB_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height-MYSTUFFTAB_HEIGHT);
    self.myStuffViewLayout = [[MyStuffViewLayout alloc] initWithView:self.view];
    self.collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:self.myStuffViewLayout];
    /*
    UIImage *backgroundImage = [UIImage imageNamed:@"frog_background"];
    UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
    background.frame = CGRectMake(0, 0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
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
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier1];
    [self.collectionView reloadData];
    [self.view addSubview:self.collectionView];

    self.tempImageView = [[UIImageView alloc] initWithFrame:self.view.frame];

    UIView *tabBackgroundwhite = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , self.view.bounds.size.width, MYSTUFFTAB_HEIGHT + STATUSBAR_HEIGHT)];
    tabBackgroundwhite.backgroundColor = appleNavBarGray;
    [self.view addSubview:tabBackgroundwhite];

    UIView *tabBackgroundgray = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * .05, MYSTUFFTAB_HEIGHT* .1 + STATUSBAR_HEIGHT, self.view.bounds.size.width * .9, MYSTUFFTAB_HEIGHT * .8)];
    tabBackgroundgray.backgroundColor = overBackgroundGray;
    tabBackgroundgray.layer.cornerRadius = 5.0;
    [tabBackgroundwhite addSubview:tabBackgroundgray];

    self.tabLine = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * .05, MYSTUFFTAB_HEIGHT* .1 + STATUSBAR_HEIGHT, (self.view.bounds.size.width * .9)/2, MYSTUFFTAB_HEIGHT * .8)];
    self.tabLine.backgroundColor = [UIColor whiteColor];
    self.tabLine.layer.cornerRadius = 5.0;
    self.tabLine.layer.borderWidth = 1.0;
    self.tabLine.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [tabBackgroundwhite addSubview:self.tabLine];

    self.questionsTab = [[UIButton alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, self.view.bounds.size.width/2, MYSTUFFTAB_HEIGHT)];
    self.questionsTab.backgroundColor = [UIColor clearColor];
    [self.questionsTab setTitle:@"My Questions" forState:UIControlStateNormal];
    [self.questionsTab setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.questionsTab addTarget:self action:@selector(questionsTabTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.questionsTab];

    self.messagesTab = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, STATUSBAR_HEIGHT, self.view.bounds.size.width/2, MYSTUFFTAB_HEIGHT)];
    self.messagesTab.backgroundColor = [UIColor clearColor];
    [self.messagesTab setTitle:@"My Messages" forState:UIControlStateNormal];
    [self.messagesTab setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.messagesTab addTarget:self action:@selector(messagesTabTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.messagesTab];

    [self questionsTabTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:self.themeColor];
    self.navigationController.navigationBarHidden = true;
    self.collectionView.alwaysBounceVertical = true;
    [self proximityProcess];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.collectionView addPullToRefreshWithActionHandler:^{
        if([self.mysqlArray[0] isEqualToString:@"myquestions"]){
            [self questionsTabTouchUpInside];
        }
        else if([self.mysqlArray[0] isEqualToString:@"mymessages"]){
            [self messagesTabTouchUpInside];
        }
        [self.collectionView.pullToRefreshView stopAnimating];
    }];
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Proximity
// Method for starting coordinate location
- (void)proximityProcess {
    self.proximity = [[Coordinates alloc] init];
    [self.proximity startLocationManager];
}

- (void)questionsTabTouchUpInside{
    if ([self.mysqlArray[0] isEqualToString:@"mymessages"]){
        [self.collectionView setContentOffset:CGPointMake(0,0) animated:YES];
    }
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         [self.tabLine setFrame:CGRectMake(self.view.bounds.size.width * .05, MYSTUFFTAB_HEIGHT* .1 + STATUSBAR_HEIGHT, (self.view.bounds.size.width * .9)/2, MYSTUFFTAB_HEIGHT * .8)];
                     }completion:^(BOOL finished){
                     }];
    [self.mysqlArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"myquestions"]];
    self.responseArrayFullLength = 9;
    OPTION_MENU_DIVISION = 6;
    OPTION_MENU_RADIUS = 135;
    NSDictionary *parameterDictionary = @{@"process": @"fetchmyquestions", @"submitData": self.mysqlArray[1], @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/service.php"
       parameters:parameterDictionary
          success:^(NSURLSessionDataTask *task, id responseObject) {
              self.responseArray = (NSMutableArray *)responseObject;
              //[self.collectionView setCollectionViewLayout:self.myStuffViewLayout];
              [self.collectionView reloadData];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)messagesTabTouchUpInside{
    if([self.mysqlArray[0] isEqualToString:@"myquestions"]){
        [self.collectionView setContentOffset:CGPointMake(0,0) animated:YES];
    }

    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         [self.tabLine setFrame:CGRectMake(self.view.bounds.size.width * .5, MYSTUFFTAB_HEIGHT* .1 + STATUSBAR_HEIGHT, (self.view.bounds.size.width * .9)/2, MYSTUFFTAB_HEIGHT * .8)];
                     }completion:^(BOOL finished){
                     }];
    [self.mysqlArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"mymessages"]];
    self.responseArrayFullLength = 6;
    OPTION_MENU_DIVISION = 7;
    OPTION_MENU_RADIUS = 150;
    NSDictionary *parameterDictionary = @{@"process": @"fetchmymessages", @"submitData": self.mysqlArray[1], @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/service.php"
       parameters:parameterDictionary
          success:^(NSURLSessionDataTask *task, id responseObject) {
              self.responseArray = (NSMutableArray *)responseObject;
              //[self.collectionView setCollectionViewLayout:self.myStuffViewLayout];
              [self.collectionView reloadData];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.responseArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //add reuseable cells in the future
    UICollectionViewCell *cell = nil;
    if([self.mysqlArray[0] isEqualToString:@"myquestions"]){
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

        optionsView.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:optionsView];
        UIImageView *optionsIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Options.png"]];
        optionsIcon.image = [optionsIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [optionsIcon setTintColor:descriptionGray];
        optionsIcon.translatesAutoresizingMaskIntoConstraints = false;
        [optionsView addSubview:optionsIcon];

        NSDictionary *views = NSDictionaryOfVariableBindings(cell, dateView, dateIcon, dateLabel, locationView, locationIcon, locationLabel, viewsLabel, viewsView, viewsIcon, commentCountLabel, commentCountView, commentCountIcon, imageView, cellLabel, seperator, classLabel, optionsView, optionsIcon, voteView, voteIcon, voteLabel);
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
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[classLabel]-0-|" options:0 metrics:nil views:views];
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

        if ([[self.responseArray objectAtIndex:indexPath.row] count] == self.responseArrayFullLength){
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.responseArray[indexPath.row][8]]]
                             placeholderImage:nil
                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                          imageView.image = image;
                                      }
                                      failure:nil];

            UITapGestureRecognizer *imageViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewGestureRecHandler:)];
            imageViewGestureRec.numberOfTapsRequired = 1;
            [imageView.viewForFirstBaselineLayout addGestureRecognizer:imageViewGestureRec];
            imageView.userInteractionEnabled = true;

            NSString *constraint = [NSString stringWithFormat:@"V:|-0-[dateView(%d)]-0-[locationView(%d)]-0-[imageView(%d)]-0-[cellLabel]-0-[seperator(1)]-0-[classLabel(%d)]-0-[voteView(%d)]-0-|", ICON_HEIGHT, ICON_HEIGHT, IMAGE_HEIGHT, ICON_HEIGHT, VOTEICON_HEIGHT];
            cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views];
            [cell addConstraints:cellConstraints];
        }
        else{
            NSString *constraint = [NSString stringWithFormat:@"V:|-0-[dateView(%d)]-0-[locationView(%d)]-0-[imageView(0)]-0-[cellLabel]-0-[seperator(1)]-0-[classLabel(%d)]-0-[voteView(%d)]-0-|", ICON_HEIGHT, ICON_HEIGHT, ICON_HEIGHT, VOTEICON_HEIGHT];
            cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views];
            [cell addConstraints:cellConstraints];
        }
        dateLabel.text = self.responseArray[indexPath.row][2];
        locationLabel.text = [NSString stringWithFormat:@"%.f Kilometers away from TCU", roundf([self.responseArray[indexPath.row][4] floatValue])];
        viewsLabel.text = self.responseArray[indexPath.row][3];
        commentCountLabel.text = self.responseArray[indexPath.row][7];
        cellLabel.text = self.responseArray[indexPath.row][1];
        classLabel.text = [NSString stringWithFormat:@"From %@", self.responseArray[indexPath.row][6]];
        voteLabel.text = self.responseArray[indexPath.row][5];

        TouchDownGestureRecognizer *optionsViewGestureRec = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(optionsViewGestureRecHandler:)];
        [optionsView addGestureRecognizer:optionsViewGestureRec];
        UITapGestureRecognizer *voteViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voteViewGestureRecHandler:)];
        voteViewGestureRec.numberOfTapsRequired = 1;
        [voteView.viewForFirstBaselineLayout addGestureRecognizer:voteViewGestureRec];
        voteView.userInteractionEnabled = YES;

    }
    else if([self.mysqlArray[0] isEqualToString:@"mymessages"]){
        UIView *dateView = [[UIView alloc] init];
        UILabel *dateLabel = [[UILabel alloc] init];
        UIView *locationView = [[UIView alloc] init];
        UILabel *locationLabel = [[UILabel alloc] init];
        UILabel *cellLabel = [[UILabel alloc] init];
        UIImageView *imageView = [[UIImageView alloc] init];
        UIView *seperator = [[UIView alloc] init];
        UIView *upvoteView = [[UIView alloc] init];
        UILabel *voteLabel = [[UILabel alloc] init];
        UIView *downvoteView = [[UIView alloc] init];
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

        upvoteView.tag = 1;
        upvoteView.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:upvoteView];
        UIImageView *upvoteIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UpArrow.png"]];
        upvoteIcon.image = [upvoteIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [upvoteIcon setTintColor:descriptionGray];
        upvoteIcon.translatesAutoresizingMaskIntoConstraints = false;
        [upvoteView addSubview:upvoteIcon];

        voteLabel.font = lBRegularFont;
        voteLabel.backgroundColor = [UIColor whiteColor];
        voteLabel.textColor = descriptionGray;
        voteLabel.textAlignment = NSTextAlignmentCenter;
        voteLabel.numberOfLines = 0;
        voteLabel.tag = indexPath.row;
        voteLabel.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:voteLabel];

        downvoteView.tag = -1;
        downvoteView.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:downvoteView];
        UIImageView *downvoteIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"DownArrow.png"]];
        downvoteIcon.image = [downvoteIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [downvoteIcon setTintColor:descriptionGray];
        downvoteIcon.translatesAutoresizingMaskIntoConstraints = false;
        [downvoteView addSubview:downvoteIcon];

        optionsView.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:optionsView];
        UIImageView *optionsIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Options.png"]];
        optionsIcon.image = [optionsIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [optionsIcon setTintColor:descriptionGray];
        optionsIcon.translatesAutoresizingMaskIntoConstraints = false;
        [optionsView addSubview:optionsIcon];

        NSDictionary *views = NSDictionaryOfVariableBindings(cell, dateView, dateIcon, dateLabel, locationView, locationIcon, locationLabel, imageView, cellLabel, seperator, optionsView, optionsIcon, upvoteView, upvoteIcon, voteLabel, downvoteView, downvoteIcon);
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
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[upvoteView(%D)]", VOTEICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[upvoteIcon]-0-|" options:0 metrics:nil views:views];
        [upvoteView addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[upvoteIcon]-0-|" options:0 metrics:nil views:views];
        [upvoteView addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[voteLabel(%d)]", VOTEICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-0-[downvoteView(%D)]", VOTEICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[downvoteIcon]-0-|" options:0 metrics:nil views:views];
        [downvoteView addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[downvoteIcon]-0-|" options:0 metrics:nil views:views];
        [downvoteView addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[optionsView(%d)]-0-|", OPTIONMENU_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[optionsIcon]-0-|" options:0 metrics:nil views:views];
        [optionsView addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[optionsIcon]-0-|" options:0 metrics:nil views:views];
        [optionsView addConstraints:cellConstraints];

        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[dateLabel(%d)]-0-[locationLabel(%d)]", ICON_HEIGHT, ICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[upvoteView(%d)]-0-[voteLabel(25)]-0-[downvoteView(%d)]-0-|", VOTEICON_HEIGHT, VOTEICON_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[optionsView(%d)]-0-|", OPTIONMENU_HEIGHT] options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];

        if ([[self.responseArray objectAtIndex:indexPath.row] count] == self.responseArrayFullLength){
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

            NSString *constraint = [NSString stringWithFormat:@"V:|-0-[dateView(%d)]-0-[locationView(%d)]-0-[imageView(%d)]-0-[cellLabel]-0-[seperator(1)]-0-[upvoteView(%d)]-0-[voteLabel(25)]-0-[downvoteView(%d)]-0-|", ICON_HEIGHT, ICON_HEIGHT, IMAGE_HEIGHT, VOTEICON_HEIGHT, VOTEICON_HEIGHT];
            cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views];
            [cell addConstraints:cellConstraints];
        }
        else{
            NSString *constraint = [NSString stringWithFormat:@"V:|-0-[dateView(%d)]-0-[locationView(%d)]-0-[imageView(0)]-0-[cellLabel]-0-[seperator(1)]-0-[upvoteView(%d)]-0-[voteLabel(25)]-0-[downvoteView(%d)]-0-|", ICON_HEIGHT, ICON_HEIGHT, VOTEICON_HEIGHT, VOTEICON_HEIGHT];
            cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views];
            [cell addConstraints:cellConstraints];
        }
        dateLabel.text = self.responseArray[indexPath.row][2];
        locationLabel.text = [NSString stringWithFormat:@"%.f Kilometers away from TCU", roundf([self.responseArray[indexPath.row][3] floatValue])];
        cellLabel.text = self.responseArray[indexPath.row][1];
        voteLabel.text = self.responseArray[indexPath.row][4];

        TouchDownGestureRecognizer *optionsViewGestureRec = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(optionsViewGestureRecHandler:)];
        [optionsView addGestureRecognizer:optionsViewGestureRec];

        UITapGestureRecognizer *upvoteViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upvoteViewGestureRecHandler:)];
        upvoteViewGestureRec.numberOfTapsRequired = 1;
        [upvoteView.viewForFirstBaselineLayout addGestureRecognizer:upvoteViewGestureRec];
        upvoteView.userInteractionEnabled = YES;

        UITapGestureRecognizer *novoteOptionViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(novoteOptionViewGestureRecHandler:)];
        novoteOptionViewGestureRec.numberOfTapsRequired = 1;
        [voteLabel.viewForFirstBaselineLayout addGestureRecognizer:novoteOptionViewGestureRec];
        voteLabel.userInteractionEnabled = YES;

        UITapGestureRecognizer *downvoteViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downvoteViewGestureRecHandler:)];
        downvoteViewGestureRec.numberOfTapsRequired = 1;
        [downvoteView.viewForFirstBaselineLayout addGestureRecognizer:downvoteViewGestureRec];
        downvoteView.userInteractionEnabled = YES;
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
    if ([[self.responseArray objectAtIndex:indexPath.row] count] == self.responseArrayFullLength){
        if(size.height > MIN_IMAGECELLHEIGHT){
            return size.height;
        }
        else{
            return MIN_IMAGECELLHEIGHT;
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

#pragma mark - private methods
- (void)optionsViewGestureRecHandler:(TouchDownGestureRecognizer *)recognizer{
    if([self.mysqlArray[0] isEqualToString:@"myquestions"]) {
        [self questionOptionMenu:recognizer];
    }
    else if([self.mysqlArray[0] isEqualToString:@"mymessages"]) {
        [self messageOptionMenu:recognizer];
    }
}

- (void)questionOptionMenu:(TouchDownGestureRecognizer *)recognizer {
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
        CGPoint cOrigin = CGPointMake(cell.frame.origin.x,cell.frame.origin.y + MYSTUFFTAB_HEIGHT);
        CGSize cSize = cell.frame.size;
        CGRect transparentPathFrame = CGRectMake(cOrigin.x, cOrigin.y-self.collectionView.contentOffset.y, cSize.width, cSize.height);
        UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRect:transparentPathFrame];

        CGPoint omLabelOrigin;
        if(cell.frame.origin.y - self.collectionView.contentOffset.y > OPTION_MENU_LABEL_HEIGHT + MYSTUFFTAB_HEIGHT + STATUSBAR_HEIGHT){
            omLabelOrigin = CGPointMake(self.view.bounds.size.width/2 - OPTION_MENU_LABEL_WIDTH/2, MYSTUFFTAB_HEIGHT + STATUSBAR_HEIGHT);
        }
        else{
            omLabelOrigin = CGPointMake(self.view.bounds.size.width/2 - OPTION_MENU_LABEL_WIDTH/2, self.view.bounds.size.height - TABBAR_HEIGHT - OPTION_MENU_LABEL_HEIGHT);
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

        self.contextOptionLocation = [self optionMenuLocationForItemNumber:1 whenTouchLocationIs:self.initialTouch];
        self.voteOptionLocation = [self optionMenuLocationForItemNumber:2 whenTouchLocationIs:self.initialTouch];
        self.editOptionLocation = [self optionMenuLocationForItemNumber:3 whenTouchLocationIs:self.initialTouch];
        self.deleteOptionLocation = [self optionMenuLocationForItemNumber:4 whenTouchLocationIs:self.initialTouch];
        self.reportOptionLocation = [self optionMenuLocationForItemNumber:5 whenTouchLocationIs:self.initialTouch];

        self.contextOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.voteOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.editOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.deleteOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.reportOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);

        [self.view addSubview:self.contextOption];
        [self.view addSubview:self.voteOption];
        [self.view addSubview:self.editOption];
        [self.view addSubview:self.deleteOption];
        [self.view addSubview:self.reportOption];

        [UIView animateWithDuration:.1
                              delay:0.0
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             [self.contextOption setFrame:CGRectMake(self.contextOptionLocation.x,self.contextOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.voteOption setFrame:CGRectMake(self.voteOptionLocation.x,self.voteOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.editOption setFrame:CGRectMake(self.editOptionLocation.x,self.editOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.deleteOption setFrame:CGRectMake(self.deleteOptionLocation.x,self.deleteOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.reportOption setFrame:CGRectMake(self.reportOptionLocation.x,self.reportOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                         }completion:^(BOOL finished){
                         }];
    }
    else if(recognizer.state == 2) {
        if([self touchDistanceFrom:self.contextOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: CONTEXTOPTION_COLOR.CGColor];
            [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer6 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer2Icon setTintColor:overBackgroundGray];
            [self.circleLayer5Icon setTintColor:overBackgroundGray];
            [self.circleLayer6Icon setTintColor:overBackgroundGray];
            [self.circleLayer7Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: CONTEXTOPTION_COLOR.CGColor];
            [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer5 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer6 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer7 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"Context";
        }
        else if([self touchDistanceFrom:self.voteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer2 setStrokeColor: VOTEOPTION_COLOR.CGColor];
            [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer6 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer2Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer5Icon setTintColor:overBackgroundGray];
            [self.circleLayer6Icon setTintColor:overBackgroundGray];
            [self.circleLayer7Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer2 setFillColor: VOTEOPTION_COLOR.CGColor];
            [self.circleLayer5 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer6 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer7 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"Like";
        }
        else if([self touchDistanceFrom:self.editOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer5 setStrokeColor: EDITOPTION_COLOR.CGColor];
            [self.circleLayer6 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer2Icon setTintColor:overBackgroundGray];
            [self.circleLayer5Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer6Icon setTintColor:overBackgroundGray];
            [self.circleLayer7Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer5 setFillColor: EDITOPTION_COLOR.CGColor];
            [self.circleLayer6 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer7 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"Edit";
        }
        else if([self touchDistanceFrom:self.deleteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer6 setStrokeColor: DELETEOPTION_COLOR.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer2Icon setTintColor:overBackgroundGray];
            [self.circleLayer5Icon setTintColor:overBackgroundGray];
            [self.circleLayer6Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer7Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer5 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer6 setFillColor: DELETEOPTION_COLOR.CGColor];
            [self.circleLayer7 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"Delete";
        }
        else if([self touchDistanceFrom:self.reportOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer6 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer7 setStrokeColor: REPORTOPTION_COLOR.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer2Icon setTintColor:overBackgroundGray];
            [self.circleLayer5Icon setTintColor:overBackgroundGray];
            [self.circleLayer6Icon setTintColor:overBackgroundGray];
            [self.circleLayer7Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer5 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer6 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer7 setFillColor: REPORTOPTION_COLOR.CGColor];
            self.optionMenuText.text = @"Report";
        }
        else{
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer2 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer6 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer2Icon setTintColor:overBackgroundGray];
            [self.circleLayer5Icon setTintColor:overBackgroundGray];
            [self.circleLayer6Icon setTintColor:overBackgroundGray];
            [self.circleLayer7Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer2 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer5 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer6 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer7 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"";
        }
    }
    else if(recognizer.state == 3) {
        if([self touchDistanceFrom:self.contextOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            NSString *tempIdHolder0 = self.mysqlArray[0];
            NSNumber *tempIdHolder2 = self.mysqlArray[2];
            [self.mysqlArray replaceObjectAtIndex:0 withObject:@"messages"];
            [self.mysqlArray replaceObjectAtIndex:2 withObject:self.celltag];
            MessageViewController* messageViewController = [[MessageViewController alloc] initWithArray:self.mysqlArray initWithCollectionViewLayout:[[MessageViewLayout alloc] init]];
            [self.mysqlArray replaceObjectAtIndex:0 withObject:tempIdHolder0];
            [self.mysqlArray replaceObjectAtIndex:2 withObject:tempIdHolder2];
            messageViewController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:messageViewController animated:YES];
        }
        else if([self touchDistanceFrom:self.voteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self voteAnimation:recognizer];
            NSDictionary *submitDataDictionary = @{@"celltag":self.celltag, @"vote": [NSNumber numberWithInteger:1], @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
            NSDictionary *parameterDictionary = @{@"process": @"submitQuestionVotes", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:@"http://www.tcuexchange.com/service.php"
               parameters:parameterDictionary
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      [self questionsTabTouchUpInside];
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
        }
        else if([self touchDistanceFrom:self.editOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            //NSString *tempIdHolder0 = self.mysqlArray[0];
            NSNumber *tempIdHolder2 = self.mysqlArray[2];
            //[self.mysqlArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:self.mysqlArray[0]];
            [self.mysqlArray replaceObjectAtIndex:2 withObject:self.celltag];
            MyStuffEditViewController *myStuffEditController = [[MyStuffEditViewController alloc] initWithArray:self.mysqlArray];
            //[self.mysqlArray replaceObjectAtIndex:0 withObject:tempIdHolder0];
            [self.mysqlArray replaceObjectAtIndex:2 withObject:tempIdHolder2];
            myStuffEditController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:myStuffEditController animated:YES];
        }
        else if([self touchDistanceFrom:self.deleteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH){
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Delete Question"
                                                  message:@"Would you like to delete this question?"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *deleteAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"Delete", @"Delete action")
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSDictionary *parameterDictionary = @{@"process": @"deletequestion", @"submitData": self.mysqlArray[1], @"selectedId": self.celltag, @"userId": self.mysqlArray[3]};
                                               AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                               [manager POST:@"http://www.tcuexchange.com/service.php"
                                                  parameters:parameterDictionary
                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                                             [self questionsTabTouchUpInside];
                                                     }
                                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                         NSLog(@"Error: %@", error);
                                                     }];
                                           }];
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                           }];
            [alertController addAction:deleteAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if([self touchDistanceFrom:self.reportOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH){
            NSDictionary *parameterDictionary = @{@"process": @"report", @"submitData": self.mysqlArray[0], @"selectedId": self.celltag, @"userId": self.mysqlArray[3]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:@"http://www.tcuexchange.com/service.php"
               parameters:parameterDictionary
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
        }
        [self.contextOption removeFromSuperview];
        [self.voteOption removeFromSuperview];
        [self.editOption removeFromSuperview];
        [self.deleteOption removeFromSuperview];
        [self.reportOption removeFromSuperview];
        [self.maskViewBackground removeFromSuperview];
        self.optionMenuText.text = @"";
    }
}

- (void)messageOptionMenu:(TouchDownGestureRecognizer *)recognizer{
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
        CGPoint cOrigin = CGPointMake(cell.frame.origin.x,cell.frame.origin.y + MYSTUFFTAB_HEIGHT);
        CGSize cSize = cell.frame.size;
        CGRect transparentPathFrame = CGRectMake(cOrigin.x, cOrigin.y-self.collectionView.contentOffset.y, cSize.width, cSize.height);
        UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRect:transparentPathFrame];


        CGPoint omLabelOrigin;
        if(cell.frame.origin.y - self.collectionView.contentOffset.y > OPTION_MENU_LABEL_HEIGHT + MYSTUFFTAB_HEIGHT + STATUSBAR_HEIGHT){
            omLabelOrigin = CGPointMake(self.view.bounds.size.width/2 - OPTION_MENU_LABEL_WIDTH/2, MYSTUFFTAB_HEIGHT + STATUSBAR_HEIGHT);
        }
        else{
            omLabelOrigin = CGPointMake(self.view.bounds.size.width/2 - OPTION_MENU_LABEL_WIDTH/2, self.view.bounds.size.height - TABBAR_HEIGHT - OPTION_MENU_LABEL_HEIGHT);

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

        self.contextOptionLocation = [self optionMenuLocationForItemNumber:1 whenTouchLocationIs:self.initialTouch];
        self.upvoteOptionLocation = [self optionMenuLocationForItemNumber:2 whenTouchLocationIs:self.initialTouch];
        self.downvoteOptionLocation = [self optionMenuLocationForItemNumber:3 whenTouchLocationIs:self.initialTouch];
        self.editOptionLocation = [self optionMenuLocationForItemNumber:4 whenTouchLocationIs:self.initialTouch];
        self.deleteOptionLocation = [self optionMenuLocationForItemNumber:5 whenTouchLocationIs:self.initialTouch];
        self.reportOptionLocation = [self optionMenuLocationForItemNumber:6 whenTouchLocationIs:self.initialTouch];

        self.contextOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.upvoteOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.downvoteOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.editOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.deleteOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);
        self.reportOption.frame = CGRectMake(viewTouchLocation.x, viewTouchLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH);

        [self.view addSubview:self.contextOption];
        [self.view addSubview:self.upvoteOption];
        [self.view addSubview:self.downvoteOption];
        [self.view addSubview:self.editOption];
        [self.view addSubview:self.deleteOption];
        [self.view addSubview:self.reportOption];

        [UIView animateWithDuration:.1
                              delay:0.0
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             [self.contextOption setFrame:CGRectMake(self.contextOptionLocation.x,self.contextOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.upvoteOption setFrame:CGRectMake(self.upvoteOptionLocation.x,self.upvoteOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.downvoteOption setFrame:CGRectMake(self.downvoteOptionLocation.x,self.downvoteOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.editOption setFrame:CGRectMake(self.editOptionLocation.x,self.editOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.deleteOption setFrame:CGRectMake(self.deleteOptionLocation.x,self.deleteOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.reportOption setFrame:CGRectMake(self.reportOptionLocation.x,self.reportOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                         }completion:^(BOOL finished){
                         }];
    }
    else if(recognizer.state == 2) {
        if([self touchDistanceFrom:self.contextOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: CONTEXTOPTION_COLOR.CGColor];
            [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer4 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer6 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer3Icon setTintColor:overBackgroundGray];
            [self.circleLayer4Icon setTintColor:overBackgroundGray];
            [self.circleLayer5Icon setTintColor:overBackgroundGray];
            [self.circleLayer6Icon setTintColor:overBackgroundGray];
            [self.circleLayer7Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: CONTEXTOPTION_COLOR.CGColor];
            [self.circleLayer3 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer4 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer5 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer6 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer7 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"Context";
        }
        else if([self touchDistanceFrom:self.upvoteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer3 setStrokeColor: UPVOTEOPTION_COLOR.CGColor];
            [self.circleLayer4 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer6 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer3Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer4Icon setTintColor:overBackgroundGray];
            [self.circleLayer5Icon setTintColor:overBackgroundGray];
            [self.circleLayer6Icon setTintColor:overBackgroundGray];
            [self.circleLayer7Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer3 setFillColor: UPVOTEOPTION_COLOR.CGColor];
            [self.circleLayer4 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer5 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer6 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer7 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"UpVote";
        }
        else if([self touchDistanceFrom:self.downvoteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer4 setStrokeColor: DOWNVOTEOPTION_COLOR.CGColor];
            [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer6 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer3Icon setTintColor:overBackgroundGray];
            [self.circleLayer4Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer5Icon setTintColor:overBackgroundGray];
            [self.circleLayer6Icon setTintColor:overBackgroundGray];
            [self.circleLayer7Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer3 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer4 setFillColor: DOWNVOTEOPTION_COLOR.CGColor];
            [self.circleLayer5 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer6 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer7 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"DownVote";
        }
        else if([self touchDistanceFrom:self.editOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer4 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer5 setStrokeColor: EDITOPTION_COLOR.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer3Icon setTintColor:overBackgroundGray];
            [self.circleLayer4Icon setTintColor:overBackgroundGray];
            [self.circleLayer5Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer6Icon setTintColor:overBackgroundGray];
            [self.circleLayer7Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer3 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer4 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer5 setFillColor: EDITOPTION_COLOR.CGColor];
            [self.circleLayer6 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer7 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"Edit";
        }
        else if([self touchDistanceFrom:self.deleteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer4 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer6 setStrokeColor: DELETEOPTION_COLOR.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer3Icon setTintColor:overBackgroundGray];
            [self.circleLayer4Icon setTintColor:overBackgroundGray];
            [self.circleLayer5Icon setTintColor:overBackgroundGray];
            [self.circleLayer6Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer7Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer3 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer4 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer5 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer6 setFillColor: DELETEOPTION_COLOR.CGColor];
            [self.circleLayer7 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"Delete";
        }
        else if([self touchDistanceFrom:self.reportOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH*1.75){
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer4 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer6 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer7 setStrokeColor: REPORTOPTION_COLOR.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer3Icon setTintColor:overBackgroundGray];
            [self.circleLayer4Icon setTintColor:overBackgroundGray];
            [self.circleLayer5Icon setTintColor:overBackgroundGray];
            [self.circleLayer6Icon setTintColor:overBackgroundGray];
            [self.circleLayer7Icon setTintColor:[UIColor whiteColor]];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer3 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer4 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer5 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer6 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer7 setFillColor: REPORTOPTION_COLOR.CGColor];
            self.optionMenuText.text = @"Report";
        }
        else{
            [self.circleLayer1 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer3 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer4 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer5 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer6 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer7 setStrokeColor: overBackgroundGray.CGColor];
            [self.circleLayer1Icon setTintColor:overBackgroundGray];
            [self.circleLayer3Icon setTintColor:overBackgroundGray];
            [self.circleLayer4Icon setTintColor:overBackgroundGray];
            [self.circleLayer5Icon setTintColor:overBackgroundGray];
            [self.circleLayer6Icon setTintColor:overBackgroundGray];
            [self.circleLayer7Icon setTintColor:overBackgroundGray];
            [self.circleLayer1 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer3 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer4 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer5 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer6 setFillColor: [UIColor whiteColor].CGColor];
            [self.circleLayer7 setFillColor: [UIColor whiteColor].CGColor];
            self.optionMenuText.text = @"";
        }
    }
    else if(recognizer.state == 3) {
        if([self touchDistanceFrom:self.contextOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH){
            NSDictionary *parameterDictionary = @{@"process": @"messagecontext", @"submitData": self.mysqlArray[1], @"selectedId": self.celltag, @"userId": self.mysqlArray[3]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:@"http://www.tcuexchange.com/service.php"
               parameters:parameterDictionary
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      NSString *tempIdHolder0 = self.mysqlArray[0];
                      NSNumber *tempIdHolder2 = self.mysqlArray[2];
                      [self.mysqlArray replaceObjectAtIndex:0 withObject:@"messages"];
                      [self.mysqlArray replaceObjectAtIndex:2 withObject:responseObject[0][0]];
                      MessageViewController* messageViewController = [[MessageViewController alloc] initWithArray:self.mysqlArray initWithCollectionViewLayout:[[MessageViewLayout alloc] init]];
                      [self.mysqlArray replaceObjectAtIndex:0 withObject:tempIdHolder0];
                      [self.mysqlArray replaceObjectAtIndex:2 withObject:tempIdHolder2];
                      messageViewController.hidesBottomBarWhenPushed = true;
                      [self.navigationController pushViewController:messageViewController animated:YES];
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
            }
        else if([self touchDistanceFrom:self.upvoteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH){
            [self voteAnimation:recognizer];
            NSDictionary *submitDataDictionary = @{@"celltag":self.celltag, @"vote": [NSNumber numberWithInteger:1], @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
            NSDictionary *parameterDictionary = @{@"process": @"submitMessageVotes", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:@"http://www.tcuexchange.com/service.php"
               parameters:parameterDictionary
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      [self messagesTabTouchUpInside];
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
        }
        else if([self touchDistanceFrom:self.downvoteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH){
            [self voteAnimation:recognizer];
            NSDictionary *submitDataDictionary = @{@"celltag":self.celltag, @"vote": [NSNumber numberWithInteger:-1], @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
            NSDictionary *parameterDictionary = @{@"process": @"submitMessageVotes", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:@"http://www.tcuexchange.com/service.php"
               parameters:parameterDictionary
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      [self messagesTabTouchUpInside];
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
        }
        else if([self touchDistanceFrom:self.editOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH){
            //NSString *tempIdHolder0 = self.mysqlArray[0];
            NSNumber *tempIdHolder2 = self.mysqlArray[2];
            //[self.mysqlArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"edit@%",self.mysqlArray[0]]];
            [self.mysqlArray replaceObjectAtIndex:2 withObject:self.celltag];
            MyStuffEditViewController *myStuffEditController = [[MyStuffEditViewController alloc] initWithArray:self.mysqlArray];
            //[self.mysqlArray replaceObjectAtIndex:0 withObject:tempIdHolder0];
            [self.mysqlArray replaceObjectAtIndex:2 withObject:tempIdHolder2];
            myStuffEditController.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:myStuffEditController animated:YES];
        }
        else if([self touchDistanceFrom:self.deleteOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH){
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Delete Message"
                                                  message:@"Would you like to delete this message?"
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *deleteAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"Delete", @"Delete action")
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSDictionary *parameterDictionary = @{@"process": @"deletemessage", @"submitData": self.mysqlArray[1], @"selectedId": self.celltag, @"userId": self.mysqlArray[3]};
                                               AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                                               [manager POST:@"http://www.tcuexchange.com/service.php"
                                                  parameters:parameterDictionary
                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                                             [self messagesTabTouchUpInside];
                                                     }
                                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                         NSLog(@"Error: %@", error);
                                                     }];
                                           }];
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction *action)
                                           {
                                           }];
            [alertController addAction:deleteAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else if([self touchDistanceFrom:self.reportOptionLocation withRespectTo:viewTouchLocation]<OPTION_VIEW_HALFWIDTH){
            NSDictionary *parameterDictionary = @{@"process": @"report", @"submitData": self.mysqlArray[0], @"selectedId": self.celltag, @"userId": self.mysqlArray[3]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:@"http://www.tcuexchange.com/service.php"
               parameters:parameterDictionary
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
        }
        [self.contextOption removeFromSuperview];
        [self.upvoteOption removeFromSuperview];
        [self.downvoteOption removeFromSuperview];
        [self.editOption removeFromSuperview];
        [self.deleteOption removeFromSuperview];
        [self.reportOption removeFromSuperview];
        [self.maskViewBackground removeFromSuperview];
        self.optionMenuText.text = @"";
    }
}

- (int)touchDistanceFrom:(CGPoint)objectLocation withRespectTo:(CGPoint)touch {
    int touchDist =  sqrt(pow((objectLocation.x+OPTION_VIEW_HALFWIDTH)-touch.x,2) + pow((objectLocation.y+OPTION_VIEW_HALFWIDTH)-touch.y,2));
    return touchDist;
}

- (CGPoint)optionMenuLocationForItemNumber:(int)itemNumber whenTouchLocationIs:(CGPoint)touchLocation {
    if(touchLocation.y-(OPTION_MENU_RADIUS*cos(-(OPTION_MENU_DIVISION-1)*M_PI/OPTION_MENU_DIVISION))+OPTION_VIEW_HALFWIDTH > (self.view.bounds.size.height - TABBAR_HEIGHT)){
        return CGPointMake(touchLocation.x-(4*OPTION_MENU_INSET+OPTION_VIEW_WIDTH), touchLocation.y-(OPTION_MENU_DIVISION-itemNumber)*(2*OPTION_MENU_INSET+OPTION_VIEW_WIDTH));
    }
    else if(touchLocation.y-(OPTION_MENU_RADIUS*cos(-M_PI/OPTION_MENU_DIVISION))-OPTION_VIEW_HALFWIDTH < MYSTUFFTAB_HEIGHT+STATUSBAR_HEIGHT){
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
              [self questionsTabTouchUpInside];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)upvoteViewGestureRecHandler:(UIGestureRecognizer *)gestureRecognizer  {
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
                [self messagesTabTouchUpInside];
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
              [self messagesTabTouchUpInside];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)downvoteViewGestureRecHandler:(UIGestureRecognizer *)gestureRecognizer  {
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
                [self messagesTabTouchUpInside];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)voteAnimation:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint viewTouchLocation = [gestureRecognizer locationInView:self.view];
    CGPoint collectionViewTouchLocation = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *collectionViewIndexPath = [self.collectionView indexPathForItemAtPoint:collectionViewTouchLocation];
    if(gestureRecognizer.view.tag==1){
        UIImage *image;
        if([self.mysqlArray[0] isEqualToString:@"myquestions"]) {
            image = [UIImage imageNamed:@"Like.png"];
        }
        else if([self.mysqlArray[0] isEqualToString:@"mymessages"]) {
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
