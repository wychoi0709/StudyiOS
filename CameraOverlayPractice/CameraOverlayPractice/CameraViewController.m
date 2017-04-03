//
//  CameraViewController.m
//  CameraOverlayPractice
//
//  Created by 최원영 on 2017. 3. 9..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate> {
    
    
    UIImagePickerController *imagePicker;
    UIPopoverController *popoverController;
    NSData *imageData;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // assign action to button
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myButton.frame = CGRectMake(0, 0, 200, 60);
    myButton.center = self.view.center;
    [myButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [myButton setTitle:@"Image Picker" forState:UIControlStateNormal];
    
    [self.view addSubview:myButton];
}

- (void)buttonPress:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        // alert the user that the camera can't be accessed
        UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Unable to access the camera!" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
        [noCameraAlert show];
        
    } else {
        
        // prepare imagePicker view
        imagePicker = [[UIImagePickerController alloc] init];
        
        
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        imagePicker.delegate = self;
        
        
        
        
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        imagePicker.navigationBarHidden = YES;
        imagePicker.toolbarHidden = YES;
        imagePicker.extendedLayoutIncludesOpaqueBars = YES;
        
        
        // create view for overlay
        CGRect overlayRect = CGRectMake(0, 0, imagePicker.view.frame.size.width, imagePicker.view.frame.size.height-50);
        UIView *overlayView = [[UIView alloc] initWithFrame:overlayRect];
        
        // prepare the image to overlay
        UIImageView *overlayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wig"]];
        overlayImage.center = overlayView.center;
        //overlayImage.alpha = 0.5;
        
        
        
        
        [overlayView addSubview:overlayImage];
        
        // add the image as the overlay
        [imagePicker setCameraOverlayView:overlayView];
        
        
        [self presentViewController:imagePicker animated:YES completion:nil];

        // display imagePicker
//        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIBarButton Selectors

- (void)takePictureButtonPressed:(id)sender {
    NSLog(@"takePictureButtonPressed...");
    // TODO: take picture!
    
    [self presentViewController:imagePicker animated:YES
                     completion:^ {
                         [imagePicker takePicture];
                     }];
    
}

- (void)startStopButtonPressed:(id)sender {
    NSLog(@"startStopButtonPressed...");
    // TODO: make this do something
}

- (void)timedButtonPressed:(id)sender {
    NSLog(@"timedButtonPressed...");
    // TODO: implement timer before calling takePictureButtonPressed
}

- (void)cancelButtonPressed:(id)sender {
    NSLog(@"cancelButtonPressed");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)editingInfo {
    
    
    
    
    
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [popoverController dismissPopoverAnimated: YES];
    
    NSData *image1 =   UIImageJPEGRepresentation([editingInfo valueForKey:UIImagePickerControllerOriginalImage],1.0);
    
    
    
    UIImage *Imgg = [self addOverlayToBaseImage:[editingInfo valueForKey:UIImagePickerControllerOriginalImage]];
    
    image1 = UIImageJPEGRepresentation(Imgg,1.0);
    imageData   =   image1;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",@"cached"]];
    
    NSLog((@"pre writing to file"));
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setValue:imagePath forKey:@"imagePath"];
        NSLog(@"the cachedImagedPath is %@",imagePath);
    }
    
    
    [self.imageView setImage:Imgg];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIImage*)addOverlayToBaseImage:(UIImage*)baseImage{
    
    UIImage *overlayImage = [UIImage imageNamed:@"wig.png"];
    CGPoint topCorner = CGPointMake(0, 0);
    CGSize targetSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    CGRect scaledRect = CGRectZero;
    
    CGFloat scaledX = self.view.frame.size.height * baseImage.size.width / baseImage.size.height;
    CGFloat offsetX = (scaledX - self.view.frame.size.width) / -2;
    
    scaledRect.origin = CGPointMake(offsetX, 0.0);
    scaledRect.size.width  = scaledX;
    scaledRect.size.height = self.view.frame.size.height;
    
    UIGraphicsBeginImageContext(targetSize);
    [baseImage drawInRect:scaledRect];
    [overlayImage drawAtPoint:topCorner];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    
    return result;  
}

@end
