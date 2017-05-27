//
//  AppDelegate.m
//  Chair
//
//  Created by 최원영 on 2016. 11. 23..
//  Copyright © 2016년 최원영. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginNetworkService.h"
#import "MeasurementHelper.h"
#import "SocialLoginNetworkService.h"

@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FIRApp configure];

    //구글 로그인 인증 관련 코드
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    
    //보통 여기에 기존에 로그인이 되었는지.. 분기를 넣는다.
    
    
    
    return YES;
}

//구글 로그인 인증 관련 코드
- (BOOL)application:(nonnull UIApplication *)application
            openURL:(nonnull NSURL *)url
            options:(nonnull NSDictionary<NSString *, id> *)options {
    
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
}

//구글 로그인 인증 관련 코드
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
    
}

//홈버튼 누르고 엑티브에서 빠져나가기 직전에 불리는 메소드
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//홈버튼을 누르면 백그라운드로 들어감. 들어가고 불리는 메소드
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


//처음 시작될 때는 안뜨고, 백드라운드로 갔다가 다시 돌아올 떄만 뜬다.
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


//처음 시작될 때 뜨고, 백그라운드로 갔다가 다시 오면 또 뜬다. 엑티브될 때마다 불리는 메소드
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



//푸쉬 관련 API를 찾아보면, 푸쉬 눌러서 들어왔을 때의 분기를 처리할 수 이싿.


@end
