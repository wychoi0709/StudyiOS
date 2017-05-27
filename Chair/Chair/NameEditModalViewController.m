//
//  NameEditModalViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 4. 22..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "NameEditModalViewController.h"
#import "BasicButton.h"
#import "ColorValue.h"

@interface NameEditModalViewController ()

@property (weak, nonatomic) IBOutlet BasicButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *textLengthLebel;
@property (weak, nonatomic) IBOutlet UITextField *nameEditTextField;

@end

@implementation NameEditModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameEditTextField.delegate = self;
    _nameEditTextField.text = _name;
    NSInteger textLenth = _name.length;
    _textLengthLebel.text = [NSString stringWithFormat: @"%ld", (long)textLenth];
    
    _confirmButton.layer.borderColor = (__bridge CGColorRef _Nullable)([ ColorValue getColorValueObject].brownColorChair);
    
    //화면 텝하면 키보드 없애는 코드
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (IBAction)confrimButtonTouched:(BasicButton *)sender {
    
    NSDictionary *resultData = [NSDictionary dictionaryWithObject:(_nameEditTextField.text) forKey:@"editedName"];
    
    //결과를 NSNotificationCenter로 보낸다.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nameEdited" object:self userInfo:resultData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  키보드 날리는 함수
 */
-(void)dismissKeyboard { [_nameEditTextField resignFirstResponder]; }


/**
 *  텍스트 필드의 리턴 버튼 눌렀을 때 메소드
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_nameEditTextField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSLog(@"Todo: 텍스트를 빠르게 입력하면, 길이가 넘어가도 입력됨");
    if (textField.text.length >= 10 && range.length == 0) {
        return NO; // return NO to not change text
    } else {
        NSInteger textLenth = textField.text.length;
        _textLengthLebel.text = [NSString stringWithFormat: @"%ld", (long)textLenth];
        return YES;
    }
}

@end
