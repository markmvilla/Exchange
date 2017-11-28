//
//  LayoutViewController.m
//  TCUExchange
//
//  Created by Mark Villa on 8/17/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "LayoutViewController.h"

@interface LayoutViewController ()
@property (nonatomic, retain) NSMutableArray *mysqlArray;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) FavoritesViewController *favorites;
@property (strong, nonatomic) SearchViewController *search;
@property (strong, nonatomic) MyStuffViewController *mystuff;
@property (strong, nonatomic) MoreViewController *more;
@property (nonatomic, strong) UIView *leftSV;
@property (nonatomic, strong) UIView *rightSV;

@property CGRect leftSF;
@property CGRect rightSF;

@property Boolean leftBool;
@property Boolean rightBool;
@end

@implementation LayoutViewController

- (id)initWithArray:(NSMutableArray *) passedmysqlArray {
    if (!(self = [super init])) {
        return (nil);
    }
    self.mysqlArray = [[NSMutableArray alloc] initWithArray:passedmysqlArray];
    //self.title = @"Favorites";
    [self prefersStatusBarHidden];
    self.leftBool = true;
    self.rightBool = true;
    return (self);
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;

    DataClass *data=[DataClass getInstance];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(width*4, height*1);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delaysContentTouches = false;
    self.scrollView.bounces = false;
    self.scrollView.alwaysBounceVertical = false;
    self.scrollView.alwaysBounceHorizontal = false;
    self.scrollView.backgroundColor = appleNavBarGray;
    [self.view addSubview:self.scrollView];

    [self.mysqlArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"courses"]];
    [self.mysqlArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:1]];
    self.search = [[SearchViewController alloc] initWithArray:self.mysqlArray];
    UINavigationController *searchNavCon = [[UINavigationController alloc] initWithRootViewController:self.search];
    searchNavCon.view.frame = CGRectMake(width*0, height*0+STATUSBAR_HEIGHT, width, height);
    [self addChildViewController:searchNavCon];
    [self.scrollView addSubview:searchNavCon.view];
    [self.search didMoveToParentViewController:self];

    [self.mysqlArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"favorites"]];
    [self.mysqlArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:0]];
    self.favorites = [[FavoritesViewController alloc] initWithArray:self.mysqlArray];
    UINavigationController *favoritesNavCon = [[UINavigationController alloc] initWithRootViewController:self.favorites];
    favoritesNavCon.view.frame = CGRectMake(width*1, height*0, width, height);
    [self addChildViewController:favoritesNavCon];
    [self.scrollView addSubview:favoritesNavCon.view];
    [self.favorites didMoveToParentViewController:self];

    [self.mysqlArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"my stuff"]];
    [self.mysqlArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:1]];
    self.mystuff = [[MyStuffViewController alloc] initWithArray:self.mysqlArray];
    UINavigationController *mystuffNavCon = [[UINavigationController alloc] initWithRootViewController:self.mystuff];
    mystuffNavCon.view.frame = CGRectMake(width*2, height*0+STATUSBAR_HEIGHT, width, height);
    [self addChildViewController:mystuffNavCon];
    [self.scrollView addSubview:mystuffNavCon.view];
    [self.mystuff didMoveToParentViewController:self];

    [self.mysqlArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"menu"]];
    [self.mysqlArray replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:1]];
    self.more = [[MoreViewController alloc] initWithArray:self.mysqlArray];
    UINavigationController *moreNavCon = [[UINavigationController alloc] initWithRootViewController:self.more];
    moreNavCon.view.frame = CGRectMake(width*3, height*0+STATUSBAR_HEIGHT, width, height);
    [self addChildViewController:moreNavCon];
    [self.scrollView addSubview:moreNavCon.view];
    [self.more didMoveToParentViewController:self];

    [self.scrollView setContentOffset:CGPointMake(width, 0)];

    if (self.leftBool && data.initialLaunch){
        self.leftSF = CGRectMake(0, height/2-50+40,75,50+40);

        self.leftSV = [[UIImageView alloc] initWithFrame:self.leftSF];
        self.leftSV.frame = self.leftSF;
        //self.leftSV.layer.borderWidth = 1.0;
        self.leftSV.layer.cornerRadius = 25.0;
        self.leftSV.backgroundColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:.8];
        [self.view addSubview:self.leftSV];

        UIImageView *leftSIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LeftArrow.png"]];
        leftSIV.frame = CGRectMake(0, 0, 75, 50);
        UIView *leftSVL = [[UIView alloc] initWithFrame:CGRectMake(0,0,75,50)];
        [[leftSVL layer] setMask:[leftSIV layer]];
        [leftSVL setBackgroundColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:.8]];
        [self.leftSV addSubview:leftSVL];

        UILabel *leftSL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 75, 40)];
        leftSL.text = @"Swipe Right";
        leftSL.numberOfLines = 0;
        leftSL.font = mBRegularFont;
        leftSL.textAlignment = UITextAlignmentCenter;
        leftSL.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:.8];
        [self.leftSV addSubview:leftSL];
    }
    if (self.rightBool && data.initialLaunch){
        self.rightSF = CGRectMake(width-75, height/2-50+40,75,50+40);

        self.rightSV = [[UIImageView alloc] initWithFrame:self.rightSF];
        self.rightSV.frame = self.rightSF;
        //self.rightSV.layer.borderWidth = 1.0;
        self.rightSV.layer.cornerRadius = 25.0;
        self.rightSV.backgroundColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:.8];
        [self.view addSubview:self.rightSV];

        UIImageView *rightSIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow.png"]];
        rightSIV.frame = CGRectMake(0, 0, 75, 50);
        UIView *rightSVL = [[UIView alloc] initWithFrame:CGRectMake(0,0,75,50)];
        [[rightSVL layer] setMask:[rightSIV layer]];
        [rightSVL setBackgroundColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:.8]];
        [self.rightSV addSubview:rightSVL];

        UILabel *rightSL = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 75, 40)];
        rightSL.text = @"Swipe Left";
        rightSL.numberOfLines = 0;
        rightSL.font = mBRegularFont;
        rightSL.textAlignment = UITextAlignmentCenter;
        rightSL.textColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:.8];
        [self.rightSV addSubview:rightSL];
    }
}

- (BOOL)prefersStatusBarHidden{
    //NSLog(@"1prefersStatusBarHidden");
    if(self.scrollView.contentOffset.x<828&&self.scrollView.contentOffset.x>0){
        return YES;
    }
    else{
        return NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    ///Event handler
    //NSLog(@"scrollViewDidScroll%f", scrollView.contentOffset.x);
    //if (self.scrollView.contentOffset.x==0||self.scrollView.contentOffset.x==828||self.scrollView.contentOffset.x==414){
        //self.prefersStatusBarHidden = true;
        //[self prefersStatusBarHidden];
        //[self setNeedsStatusBarAppearanceUpdate];
    //if(self.scrollView.contentOffset.x==0||self.scrollView.contentOffset.x==828||self.scrollView.contentOffset.x==1242){
    [UIView animateWithDuration:.25
                          delay:0.0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         [self setNeedsStatusBarAppearanceUpdate];
                     }completion:^(BOOL finished){
                     }];
    if(self.scrollView.contentOffset.x==414){
        NSLog(@"%@", self.favorites.mysqlArray);
        if([self.favorites.mysqlArray[2] isEqualToNumber:[NSNumber numberWithInteger:0]]){
            NSLog(@"no");
            self.favorites.view.inputAccessoryView.hidden = true;
        }
        else{
            NSLog(@"yes");
            self.favorites.view.inputAccessoryView.hidden = false;
        }
        [self.favorites favlistexchangeData];
    }
    else if(self.scrollView.contentOffset.x==0){
        [self.leftSV removeFromSuperview];
    }
    else if(self.scrollView.contentOffset.x==3*414){
        [self.rightSV removeFromSuperview];
    }
    else{
        [UIView animateWithDuration:.25
                              delay:0.0
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             self.favorites.view.inputAccessoryView.hidden = true;
                         }completion:^(BOOL finished){
                         }];
    }
    //}
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
