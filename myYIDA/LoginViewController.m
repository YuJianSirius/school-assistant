//
//  LoginViewController.m
//  myYIDA
//
//  Created by xiaojia on 4/3/14.
//  Copyright (c) 2014 sirius. All rights reserved.
//

#import "LoginViewController.h"
#import "WebManager.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "KeychainItemWrapper.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UsercodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton    *LoginButton;

@property (strong, nonatomic)   KeychainItemWrapper *wrapper;
@property (strong, nonatomic)   WebManager  *webmanger;
@property (nonatomic)           Boolean     isLogin;
@end

@implementation LoginViewController
@synthesize wrapper = _wrapper;

-(WebManager *)webmanger
{
    if(!_webmanger){
        NSLog(@"login in");
        _webmanger = [[WebManager alloc] init];
        _isLogin   =  NO;
    }
    return _webmanger;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewdidload");
    //self.isLogin = [self.webmanger ConcWebWithUserCode:@"11080734" Password:@"19922020a"];
    //NSLog(self.isLogin ? @"YES" : @"NO");
    [self saveUserInfo];
}

- (void)saveUserInfo
{
    self.wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"Account Number" accessGroup:@"YOUR_APP_ID_HERE.com.yourcompany.AppIdentifier"];
    
    NSString *savePasswrod = [self.wrapper objectForKey:(__bridge id)kSecValueData];
    NSString *saveUsercode = [self.wrapper objectForKey:(__bridge id)kSecAttrAccount];
    
    if(savePasswrod && saveUsercode){
        self.UsercodeTextField.text = saveUsercode;
        self.passwordTextField.text = savePasswrod;
    }
}


- (IBAction)LoginAction:(UIButton *)sender
{
    NSString *Usercode = [NSString stringWithString:self.UsercodeTextField.text];
    NSString *Passwrod = [NSString stringWithString:self.passwordTextField.text];
   
    [self.UsercodeTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    self.isLogin = [self.webmanger ConcWebWithUserCode:Usercode Password:Passwrod];
    NSLog(self.isLogin ? @"YES" : @"NO");
    //self.isLogin = YES;
    
    if(self.isLogin){
        UIAlertView *SuccAlert = [[UIAlertView alloc] initWithTitle:nil message:@"登录成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [SuccAlert show];
        [self performSegueWithIdentifier:@"Login Success" sender:self];
        [self.wrapper setObject:Usercode forKey:(__bridge id)kSecAttrAccount];
        [self.wrapper setObject:Passwrod forKey:(__bridge id)kSecValueData];
        NSLog(@"mimiimimiimimiim %@",[self.wrapper objectForKey:(__bridge id)kSecValueData]);
    }else{
        UIAlertView *FailAlert= [[UIAlertView alloc] initWithTitle:nil message:@"用户名或密码错误，请重新登录" delegate:nil cancelButtonTitle:@"重试" otherButtonTitles:nil];
        [FailAlert show];
    }
    
    NSLog(@"aciton");
}
@end
