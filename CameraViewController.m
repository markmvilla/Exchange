//
//  CameraViewController.m
//  TCU Exchange
//
//  Created by Mark Villa on 2/7/16.
//  Copyright © 2016 Exchange. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;
@property (nonatomic, strong) Coordinates *proximity;
@property BOOL isImage;
@property BOOL isVideo;
@end

@implementation CameraViewController

- (id)initWithArray:(NSMutableArray *) passedmysqlArray {
    if (!(self = [super init])) {
        return (nil);
    }
    // Passing in mysqlArray
    self.mysqlArray = [[NSMutableArray alloc] initWithArray:passedmysqlArray];
    //self.title = @"";
    //self.navigationController.navigationBarHidden = true;
    return (self);
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = true;
    [self proximityProcess];
}

-(BOOL)prefersStatusBarHidden {
    return true;
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    [self CameraKeyboard:nil openCamera:nil];
    self.pictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    self.pictureLabel.font = lRegularFont;
    self.pictureLabel.backgroundColor = [UIColor whiteColor];
    self.pictureLabel.textColor = [UIColor blackColor];
    self.pictureLabel.textAlignment = NSTextAlignmentCenter;
    self.pictureLabel.text = [NSString stringWithFormat:@"Upload Your Image"];
    [self.view addSubview:self.pictureLabel];

    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    self.cancelButton.backgroundColor = [UIColor clearColor];
    self.cancelButton.font = lRegularFont;
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTouchView)];
    recognizer.cancelsTouchesInView = NO;
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
}

#pragma mark -  Proximity
// Method for starting coordinate location  and adding observer
-(void)proximityProcess {
    self.proximity = [[Coordinates alloc] init];
    [self.proximity startLocationManager];
}


#pragma mark - gesture delegate
// this allows you to dispatch touches
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

// this enables you to handle multiple recognizers on single view
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Cancel camera and pop viewcontroller
- (void)cancelCameraButton:(id)sender {
    NSLog(@"cancelCameraButton");
    self.navigationController.navigationBarHidden = false;
    [self.navigationController popViewControllerAnimated:true];
}

#pragma UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        self.isImage = false;
        self.isVideo = true;
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[info objectForKey:UIImagePickerControllerMediaURL]];
        self.moviePlayer.view.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-80);
        self.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer play];
    }
    else if([info objectForKey:UIImagePickerControllerOriginalImage] != NULL){
        self.isImage = true;
        self.isVideo = false;
        self.imagePicked = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-80)];
        [self.view addSubview:self.imagePicked];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.imagePicked.image = image;
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma inputAccessoryView methods
// Override canBecomeFirstResponder to allow self to be a responder. The view will reload calling all methods again.
- (bool) canBecomeFirstResponder {
    NSLog(@"canBecomeFirstResponder");
    return true;

}

// Override inputAccessoryView to use an instance of KeyboardBar
- (UIView *)inputAccessoryView {
    NSLog(@"_inputAccessoryView");
    if(!_inputAccessoryView) {
        _inputAccessoryView = [[CameraKeyboard alloc] initWithDelegate:self];
    }
    return _inputAccessoryView;
}

#pragma CameraKeyboardDelegate
// OPEN CAMERA
- (void)CameraKeyboard:(CameraKeyboard *)CameraKeyboard openCamera:(NSString *)text{
    NSLog(@"openCamera");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        picker.allowsEditing = false;
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        //picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
        picker.delegate = self;
        [self presentViewController:picker animated:true completion:nil];
    }
}

// Upload Media
- (void)CameraKeyboard:(CameraKeyboard *)CameraKeyboard uploadMedia:(NSString *)text{
    NSLog(@"uploadMedia%@", self.mysqlArray);
    if (self.isImage && (![text isEqual:@""])) {
        if(self.isImage){
            if ([self.mysqlArray[0] isEqual:@"questions"]) {
                NSDictionary *submitDataDictionary = @{@"submitData":text, @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
                NSDictionary *parameterDictionary = @{@"process": @"submitQuestionsMedia", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager POST:@"http://www.tcuexchange.com/service.php"
                   parameters:parameterDictionary
                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        NSData *imageData = UIImageJPEGRepresentation(self.imagePicked.image, 0.1);
                        [formData appendPartWithFileData:imageData name:@"test" fileName:@"questionimage.jpg" mimeType:@"image/jpeg"];
                    }
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          NSLog(@"%@",responseObject);
                          [self cancelCameraButton:nil];
                      }
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                          NSLog(@"Failure %@, %@", error, [task.response description]);
                      }];
            }
            else if ([self.mysqlArray[0] isEqual:@"messages"]) {
                NSDictionary *submitDataDictionary = @{@"submitData":text, @"latitude": self.proximity.coordinates[0], @"longitude": self.proximity.coordinates[1]};
                NSDictionary *parameterDictionary = @{@"process": @"submitMessagesMedia", @"submitData": submitDataDictionary, @"selectedId": self.mysqlArray[2], @"userId": self.mysqlArray[3]};
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                [manager POST:@"http://www.tcuexchange.com/service.php"
                   parameters:parameterDictionary
                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        NSData *imageData = UIImageJPEGRepresentation(self.imagePicked.image, 0.1);
                        [formData appendPartWithFileData:imageData name:@"test" fileName:@"messageimage.jpg" mimeType:@"image/jpeg"];
                    }
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          NSLog(@"%@",responseObject);
                          [self cancelCameraButton:nil];
                      }
                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                          NSLog(@"Failure %@, %@", error, [task.response description]);
                      }];
            }
        }
        else if(self.isVideo){
            NSLog(@"self.isVideo");
        }
    }
    else {
        if (!self.isImage && self.isVideo){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Video Not Supported...Yet!"
                                                                            message:@"Pictures are the only option. We are working on videos!"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {[self becomeFirstResponder];}];

            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if(!self.isImage){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Picture Required."
                                                                           message:@"A picture is required."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {[self becomeFirstResponder];}];

            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if ([text isEqual: @""]){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Text Required."
                                                                           message:@"A text is required. We are working on non-text pictures!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {[self becomeFirstResponder];}];

            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma UITapGestureRecognizer method
// Dissmiss the keyboard on "self" touches by making the view the first responder
- (void)didTouchView {
    NSLog(@"didTouchView");
    [self becomeFirstResponder];
}

@end
