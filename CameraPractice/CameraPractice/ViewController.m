//
//  ViewController.m
//  CameraPractice
//
//  Created by 최원영 on 2017. 2. 10..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *targetImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cameraBtnTouched:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"사진 선택"
                                                                   message:@"사진을 선택해주세요."
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* albumAction = [UIAlertAction actionWithTitle:@"앨범" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {
                                                                [self doSomethingAfterAlbum];
                                                            }];
    [alert addAction:albumAction];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"카메라" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                [self doSomethingAfterCamera];
                                                            }];
        [alert addAction:cameraAction];
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)doSomethingAfterAlbum {
    NSLog(@"doSomethingAfterAlbum");
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
     
        NSLog(@"앨범이 있으니, 있다고 설정하고 알람을 띄움");
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;

        [self presentViewController:picker animated:YES completion:nil];

    } else {
        NSLog(@"앨범이 없음(오류)");
    }
}

- (void)doSomethingAfterCamera {
    NSLog(@"doSomethingAfterCamera");
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        NSLog(@"카메라가 있으니 카메라를 띄움");
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        NSLog(@"카메라가 없음");
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.targetImageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
