//
//  StyleWebViewController.m
//  Chair
//
//  Created by 최원영 on 2017. 5. 18..
//  Copyright © 2017년 최원영. All rights reserved.
//

#import "StyleWebViewController.h"

@interface StyleWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webViewForStylePage;
@property (weak, nonatomic) IBOutlet UILabel *nameOfDesigner;

@end

@implementation StyleWebViewController


/**
 *  페이지가 로딩되면, 넘겨 받은 url을 웹뷰에 띄워준다.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //상단 네비바에 디자이너 이름을 넣는다.
    _nameOfDesigner.text = _nameStringOfDesigner;
    
    //받은 url로 웹뷰를 로딩한다.
    NSURL *nsUrl = [NSURL URLWithString:_urlForStylePage];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [_webViewForStylePage loadRequest:request];
}


- (IBAction)backBtnTouched:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

@end
