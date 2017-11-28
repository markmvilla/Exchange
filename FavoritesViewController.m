//
//  FavoritesViewController.m
//  TCU Exchange
//
//  Created by Mark Villa on 2/15/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "FavoritesViewController.h"

#define FAVLISTCV_HEIGHT 152

@interface FavoritesViewController ()
@property (nonatomic, strong) UICollectionView *favpostCV;
@property (nonatomic, strong) UICollectionView *favlistCV;
@property (nonatomic, strong) NSMutableArray *listcvresponseArray;
@property (nonatomic, strong) NSMutableArray *postcvresponseArray;

@property (nonatomic, strong) Coordinates *proximity;
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;

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

@implementation FavoritesViewController

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

- (id)initWithArray:(NSMutableArray *) passedmysqlArray {
    if (!(self = [super init])) {
        return (nil);
    }
    self.mysqlArray = [[NSMutableArray alloc] initWithArray:passedmysqlArray];
    //self.title = @"Favorites";
    NSLog(@"Favorites init");
    return (self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self favlistexchangeData];
    //[self addGestureRecognizer];
    self.navigationController.navigationBarHidden = true;
    //self.navigationController.hidesBarsOnSwipe = YES;
    [self proximityProcess];
    self.favlistCV.delaysContentTouches = false;
    [self addFavListGR];

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;

    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;

    CGRect favlistCVFrame = CGRectMake(0,0,width,FAVLISTCV_HEIGHT);
    FavoritesListViewLayout *favlistVL = [[FavoritesListViewLayout alloc] initWithView:self.view];
    self.favlistCV = [[UICollectionView alloc] initWithFrame:favlistCVFrame collectionViewLayout:favlistVL];

    self.favlistCV.backgroundColor = [UIColor whiteColor];
    self.favlistCV.tag = 0;
    self.favlistCV.delegate = self;
    self.favlistCV.dataSource = self;
    [self.favlistCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier1];
    //[self.favlistCV reloadData];
    [self.view addSubview:self.favlistCV];

    CGRect favpostCVFrame = CGRectMake(0, self.favlistCV.frame.origin.y+self.favlistCV.frame.size.height, width, height-(self.favlistCV.frame.origin.y+self.favlistCV.frame.size.height+KEYBOARD_HEIGHT));
    FavoritesPostViewLayout *favpostVL = [[FavoritesPostViewLayout alloc] initWithView:self.view];
    self.favpostCV = [[UICollectionView alloc] initWithFrame:favpostCVFrame collectionViewLayout:favpostVL];
    /*
    UIImage *backgroundImage = [UIImage imageNamed:@"frog_background"];
    UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
    background.frame = CGRectMake(0, 0, self.favpostCV.bounds.size.width, self.favpostCV.bounds.size.height);
    background.backgroundColor = backgroundGray;
    UIView *backgroundOverlay = [[UIView alloc] initWithFrame:[background frame]];
    UIImageView *backgroundOverlayMask = [[UIImageView alloc] initWithImage:backgroundImage];
    [backgroundOverlayMask setFrame:[backgroundOverlay bounds]];
    [[backgroundOverlay layer] setMask:[backgroundOverlayMask layer]];
    [backgroundOverlay setBackgroundColor:[UIColor lightGrayColor]];
    [background addSubview:backgroundOverlay];
    */
    //self.favpostCV.backgroundColor = [UIColor clearColor];
    self.favpostCV.backgroundColor = [UIColor lightGrayColor];
    //self.favpostCV.backgroundView = background;
    self.favpostCV.tag = 1;
    self.favpostCV.delegate = self;
    self.favpostCV.dataSource = self;
    [self.favpostCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier1];
    //[self.favpostCV reloadData];
    [self.view addSubview:self.favpostCV];
    [self collectionView:self.favlistCV shouldSelectItemAtIndexPath:0];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.favpostCV addPullToRefreshWithActionHandler:^{
        [self favpostexchangeData];
        //[self collectionView:self.favlistCV shouldSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.mysqlArray[2] inSection:1]];
        [self.favpostCV.pullToRefreshView stopAnimating];
    }];
    self.favpostCV.alwaysBounceVertical = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - private method

- (void)viewGestureRecHandler:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.view];
    NSIndexPath *indexPath = [self.favTV indexPathForRowAtPoint:point];
    UITableViewCell *cell = [self.favTV cellForRowAtIndexPath:indexPath];
    NSLog(@"%ld", (long)cell.tag);
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"http://www.tcuexchange.com/service.php"
           parameters:@{@"process":@"removeFavorites",
                        @"submitData":[NSNumber numberWithInteger:cell.tag],
                        @"selectedId":self.mysqlArray[2],
                        @"userId":self.mysqlArray[3]}
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Class Removed"
                                                                                 message:@"This class has been removed from your favorites list."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                        handler:^(UIAlertAction * action) {[self becomeFirstResponder];}];

                  [alert addAction:defaultAction];
                  [self presentViewController:alert animated:YES completion:nil];

                  [self favlistexchangeData];
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
}
*/

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
              [self favpostexchangeData];
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)keyboardBar:(KeyboardBar *)keyboardBar openCamera:(NSString *)text {
    //NSLog(@"openCamera");
    CameraViewController *cameraViewController = [[CameraViewController alloc] initWithArray:self.mysqlArray];
    cameraViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:cameraViewController animated:YES];
}

#pragma mark - private methods
- (void)favlistexchangeData {
    NSLog(@"@%", self.mysqlArray);
    [self.mysqlArray replaceObjectAtIndex:0 withObject:@"favorites"];
    NSDictionary *parameterDictionary = @{@"process": self.mysqlArray[0], @"submitData": self.mysqlArray[1], @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/service.php"
       parameters:parameterDictionary
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSLog(@"%@", responseObject);
              self.listcvresponseArray = (NSMutableArray *)responseObject;
              [self.favlistCV reloadData];
              NSLog(@"2");
          }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

- (void)favpostexchangeData {
    [self.mysqlArray replaceObjectAtIndex:0 withObject:@"questions"];
    NSDictionary *parameterDictionary = @{@"process": self.mysqlArray[0], @"submitData": self.mysqlArray[1], @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/service.php"
       parameters:parameterDictionary
          success:^(NSURLSessionDataTask *task, id responseObject) {
              self.postcvresponseArray = (NSMutableArray *)responseObject;
              [self.favpostCV reloadData];
}
          failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if(collectionView.tag == 0){
        return 1;
    }
    else{
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView.tag == 0){
        return self.listcvresponseArray.count;
    }
    else{
        return self.postcvresponseArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    //NSLog(@"%ld", (long)collectionView.tag);
    if(collectionView.tag == 0){
        //add reuseable cells in the future
        //UIImageView *imageView = [[UIImageView alloc] init];
        //UIImage *backgroundImage = [UIImage imageNamed:@"1.jpg"];
        //UIImage *backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.listcvresponseArray[indexPath.row][2]]];
        UIImage *backgroundImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.listcvresponseArray[indexPath.row][2]]];
        UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
        //UILabel *favoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height/2, cell.frame.size.width, 50)];
        UILabel *favoriteLabel = [[UILabel alloc] init];
        UILabel *filterLabel = [[UILabel alloc] init];

        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.backgroundColor = [UIColor whiteColor];
        cell.tag = [self.listcvresponseArray[indexPath.row][0] integerValue];
        background.translatesAutoresizingMaskIntoConstraints = false;
        [cell.contentView addSubview:background];

        filterLabel.translatesAutoresizingMaskIntoConstraints = false;
        filterLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:.25];
        [cell.contentView addSubview:filterLabel];

        favoriteLabel.translatesAutoresizingMaskIntoConstraints = false;
        favoriteLabel.font = sRegularFont;
        favoriteLabel.numberOfLines = 0;
        favoriteLabel.textAlignment = UITextAlignmentCenter;
        favoriteLabel.layer.borderWidth = 1;
        favoriteLabel.layer.cornerRadius = 25;
        favoriteLabel.layer.masksToBounds = true;

        //filterLabel.layer.backgroundColor = [UIColor grayColor];
        favoriteLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:.65];
        favoriteLabel.text = self.listcvresponseArray[indexPath.row][1];
        [cell.contentView addSubview:favoriteLabel];

        NSDictionary *views = NSDictionaryOfVariableBindings(cell, background, filterLabel, favoriteLabel);
        NSArray *cellConstraints;
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[background]-0-|" options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[background]-0-|" options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[filterLabel]-0-|" options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[filterLabel]-0-|" options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[favoriteLabel]-0-|" options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
        cellConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-35-[favoriteLabel(80)]" options:0 metrics:nil views:views];
        [cell addConstraints:cellConstraints];
    }
    else{
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
        //UICollectionViewCell *cell = nil;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        [[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.cornerRadius = 0;
        cell.layer.masksToBounds = true;
        cell.tag = [self.postcvresponseArray[indexPath.row][0] integerValue];

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

        if ([[self.postcvresponseArray objectAtIndex:indexPath.row] count] == 8){
            [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.postcvresponseArray[indexPath.row][7]]]
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
        dateLabel.text = self.postcvresponseArray[indexPath.row][2];
        locationLabel.text = [NSString stringWithFormat:@"%.f Kilometers away from TCU", roundf([self.postcvresponseArray[indexPath.row][4] floatValue])];
        viewsLabel.text = self.postcvresponseArray[indexPath.row][3];
        commentCountLabel.text = self.postcvresponseArray[indexPath.row][6];
        cellLabel.text = self.postcvresponseArray[indexPath.row][1];
        voteLabel.text = self.postcvresponseArray[indexPath.row][5];
        TouchDownGestureRecognizer *optionsViewGestureRec = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(optionsViewGestureRecHandler:)];
        [optionsView addGestureRecognizer:optionsViewGestureRec];
        UITapGestureRecognizer *voteViewGestureRec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voteViewGestureRecHandler:)];
        voteViewGestureRec.numberOfTapsRequired = 1;
        [voteView.viewForFirstBaselineLayout addGestureRecognizer:voteViewGestureRec];
        voteView.userInteractionEnabled = YES;
    }
    return cell;
}

#pragma mark - UICollectionViewLayoutDelegate
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath {
    if(collectionView.tag == 0){
        //NSLog(@"0,4");
        return FAVLISTCV_HEIGHT - 2;
    }
    else{
        //NSLog(@"1,4");
        NSString *currentlabeltext = self.postcvresponseArray[indexPath.row][1];
        CGSize maximumLabelSize = CGSizeMake(self.view.bounds.size.width,MAXFLOAT);
        CGRect textRect = [currentlabeltext boundingRectWithSize:maximumLabelSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                      attributes:@{NSFontAttributeName:lRegularFont}
                                                         context:nil];
        CGSize size = textRect.size;
        if ([[self.postcvresponseArray objectAtIndex:indexPath.row] count] == 8){
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

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if(collectionView.tag == 0){
        if (indexPath.row != 0){
            self.view.inputAccessoryView.hidden = false;
            [self.mysqlArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:cell.tag]];
            [self favpostexchangeData];
        }
        else {
            self.view.inputAccessoryView.hidden = true;
            [self.mysqlArray replaceObjectAtIndex:0 withObject:@"allquestions"];
            [self.mysqlArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:cell.tag]];
            NSDictionary *parameterDictionary = @{@"process": self.mysqlArray[0], @"submitData": self.mysqlArray[1], @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager POST:@"http://www.tcuexchange.com/service.php"
               parameters:parameterDictionary
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      self.postcvresponseArray = (NSMutableArray *)responseObject;
                      [self.favpostCV reloadData];
                  }
                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                      NSLog(@"Error: %@", error);
                  }];
        }
    }
    else{
        NSNumber *tempIdHolder = self.mysqlArray[2];
        [self.mysqlArray replaceObjectAtIndex:0 withObject:@"messages"];
        [self.mysqlArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:cell.tag]];
        MessageViewController* messageViewController = [[MessageViewController alloc] initWithArray:self.mysqlArray initWithCollectionViewLayout:[[MessageViewLayout alloc] init]];
        [self.mysqlArray replaceObjectAtIndex:2 withObject:tempIdHolder];
        [self.mysqlArray replaceObjectAtIndex:0 withObject:@"questions"];
        messageViewController.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:messageViewController animated:YES];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

#pragma mark - private methods
- (void)optionsViewGestureRecHandler:(TouchDownGestureRecognizer *)recognizer{
    CGPoint viewTouchLocation = [recognizer locationInView:self.view];
    CGPoint collectionViewTouchLocation = [recognizer locationInView:self.favpostCV];
    NSIndexPath *collectionViewIndexPath = [self.favpostCV indexPathForItemAtPoint:collectionViewTouchLocation];
    if(recognizer.state == 1) {
        NSLog(@"recognizer.state == 1");
        self.celltag = [NSNumber numberWithInteger:[self.favpostCV cellForItemAtIndexPath:collectionViewIndexPath].tag];
        UICollectionViewCell *cell = [self.favpostCV cellForItemAtIndexPath:collectionViewIndexPath];
        self.maskViewBackground = [[UIView alloc] initWithFrame:self.view.frame];
        self.maskViewBackground.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:.8];

        CAShapeLayer *maskShape = [CAShapeLayer layer];
        UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:self.view.frame];
        //CGPoint cOrigin = cell.frame.origin;
        CGPoint cOrigin = CGPointMake(cell.frame.origin.x, cell.frame.origin.y+self.favlistCV.bounds.size.height);
        CGSize cSize = cell.frame.size;
        CGRect transparentPathFrame = CGRectMake(cOrigin.x, cOrigin.y-self.favpostCV.contentOffset.y, cSize.width, cSize.height);
        UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRect:transparentPathFrame];

        CGPoint omLabelOrigin;
        if(cell.frame.origin.y+self.favlistCV.bounds.size.height-self.favpostCV.contentOffset.y > OPTION_MENU_LABEL_HEIGHT + STATUSBAR_HEIGHT){
            omLabelOrigin = CGPointMake(self.view.bounds.size.width/2 - OPTION_MENU_LABEL_WIDTH/2, STATUSBAR_HEIGHT);
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
                             NSLog(@"animateWithDuration");
                             [self.voteOption setFrame:CGRectMake(self.voteOptionLocation.x,self.voteOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                             [self.reportOption setFrame:CGRectMake(self.reportOptionLocation.x,self.reportOptionLocation.y, OPTION_VIEW_WIDTH, OPTION_VIEW_WIDTH)];
                         }completion:^(BOOL finished){
                         }];
    }
    else if(recognizer.state == 2) {
        NSLog(@"recognizer.state == 2");
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
                      [self favpostexchangeData];
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
                      [self favpostexchangeData];
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
    CGPoint collectionViewTouchLocation = [gestureRecognizer locationInView:self.favpostCV];
    NSIndexPath *collectionViewIndexPath = [self.favpostCV indexPathForItemAtPoint:collectionViewTouchLocation];
    NSNumber *celltag = [NSNumber numberWithInteger:[self.favpostCV cellForItemAtIndexPath:collectionViewIndexPath].tag];
    NSDictionary *submitDataDictionary = @{@"celltag":celltag, @"vote": [NSNumber numberWithInteger:1], @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
    NSDictionary *parameterDictionary = @{@"process": @"submitQuestionVotes", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://www.tcuexchange.com/service.php"
       parameters:parameterDictionary
          success:^(NSURLSessionDataTask *task, id responseObject) {
              [self favpostexchangeData];
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

- (void)addFavListGR{
    UILongPressGestureRecognizer *favListGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(favListGRHandler:)];
    favListGR.minimumPressDuration = 1.0;
    favListGR.delegate = self;
    [self.view addGestureRecognizer:favListGR];
}

- (void)favListGRHandler:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self.favlistCV];
    NSIndexPath *indexPath = [self.favlistCV indexPathForItemAtPoint:point];
    UICollectionViewCell *cell = [self.favlistCV cellForItemAtIndexPath:indexPath];

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSDictionary *parameterDictionary = @{@"process": @"removeFavorites", @"submitData": [NSNumber numberWithInteger:cell.tag], @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"http://www.tcuexchange.com/service.php"
           parameters:parameterDictionary
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Class Removed"
                                                                                 message:@"This class has been removed from your favorites list."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                        handler:^(UIAlertAction * action) {[self becomeFirstResponder];}];

                  [alert addAction:defaultAction];
                  [self presentViewController:alert animated:YES completion:nil];

                  [self favlistexchangeData];
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"Error: %@", error);
              }];
    }
}

@end
