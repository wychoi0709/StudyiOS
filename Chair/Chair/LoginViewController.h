//
//  LoginViewController.h
//  Chair
//
//  Created by 최원영 on 2016. 12. 10..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleSignIn;

@interface LoginViewController : UIViewController <UITextFieldDelegate, GIDSignInUIDelegate, GIDSignInDelegate>

@end
