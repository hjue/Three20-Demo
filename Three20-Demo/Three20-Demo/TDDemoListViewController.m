//
//  TDDemoListViewController.m
//  Three20-Demo
//
//  Created by haoyu on 13-1-13.
//  Copyright (c) 2013年 haoyu. All rights reserved.
//

#import "TDDemoListViewController.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPClient.h"
#import "TDBHTTPClient.h"

@interface TDDemoListViewController ()
{
    UITextField* _textField ;
}
@end

@implementation TDDemoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Three20 Demo";
        self.tableViewStyle = UITableViewStylePlain;
        
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(login12306) forControlEvents:UIControlEventTouchUpInside];

        //init 12306 for code
//        NSURL *url = [NSURL URLWithString:@"https://dynamic.12306.cn/otsweb"];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//        [operation setAuthenticationAgainstProtectionSpaceBlock:^BOOL(NSURLConnection *connection, NSURLProtectionSpace *protectionSpace) {
//            return YES;
//        }];
//        [operation setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
//            if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//                [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//            }
//        }];
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"success %@",operation.responseString);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"AFNetworking error: %@",error);
//        }];
//        [operation start];
        
//        [[TTURLCache sharedCache]removeAll:YES];
        UIImage *image = [[TDBHTTPClient sharedClient]validateCodeImage];
        UIButton *validateCode = [UIButton buttonWithType:UIButtonTypeCustom];
        [validateCode setImage:image forState:UIControlStateNormal];
        NSString *imgUrl = @"https://dynamic.12306.cn/otsweb/passCodeAction.do?rand=sjrand";
        /*
        imgUrl = @"https://www.google.com.hk/images/nav_logo117.png";
        NSError *error;

        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]options:nil error:&error];
        NSLog(@"error:%@",error);
        UIImage *img = [UIImage imageWithData:imgData];

        UIButton *code = [UIButton buttonWithType:UIButtonTypeCustom];
        code.imageView.image = img;
         */
        _textField = [[[UITextField alloc] init] autorelease];

        self.dataSource = [TTListDataSource dataSourceWithObjects:
                           [TTTableLink itemWithText:@"Parse HTML" URL:@"tt://html-parser"],
                           [TTTableLink itemWithText:@"Grouped Table" URL:@"tt://grouped-table"],
                           [TTTableLink itemWithText:@"WebView" URL:@"tt://webview"],
                           [TTTableControlItem itemWithCaption:nil control:validateCode],
                           [TTTableControlItem itemWithCaption:@"Code" control:_textField],
                           [TTTableControlItem itemWithCaption:@"Button" control:loginButton],
                            nil];
    }

    
    [self loginDouban];
    return self;
}
- (void) loginCSDN
{
    NSString *basisUrl = @"https://passport.csdn.net";
    
    //    basisUrl =     @"http://httpbin.org/";
    //    basisUrl = @"https://passport.csdn.net/ajax/accounthandler.ashx?t=log&u=hjue&p=&remember=1&f=http%3A%2F%2Fwww.csdn.net%2F&rand=0.44018725701607764";
    NSURL *url = [NSURL URLWithString:basisUrl];
    AFHTTPClient *httpCookieClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSLog(@"URL:%@",[url absoluteString]);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"log", @"t",
                            @"hjue", @"u",
                            @"",@"p",
                            @"1",@"remember",
                            @"http://www.csdn.net/",@"f",
                            @"0.44018725701607764",@"rand",
                            nil];
    NSMutableURLRequest *request = [httpCookieClient requestWithMethod:@"GET" path:@"/ajax/accounthandler.ashx" parameters:params];
    [request setHTTPShouldHandleCookies:YES];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    [operation start];
}

/* login ok" */
- (void) loginDouban
{
 
    NSURL * url = [NSURL URLWithString:@"https://www.douban.com/accounts/login"];
    NSLog(@"base:%@,path:%@",[url baseURL],[url path]);
    
    TDBHTTPClient *httpClient = [[TDBHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://www.douban.com"]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                                               @"index_nav",@"source",
                                                           @"haojue@gmail.com",@"form_email",
                                                        @"",@"form_password",
                                                             @"on",@"remember",
                            nil];
    
    
     [httpClient postPath:[url path] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if ([operation.responseString rangeOfString:@"跑着去兜风"].location == NSNotFound)
         {
             NSLog(@"Douban Login fail");
         }else
         {
             NSLog(@"Douban Login Succ!");
         }
         NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: url];
         for (NSHTTPCookie *cookie in cookies)
         {
             NSLog(@"cookie:%@",cookie);
              [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"error:%@",error);
     }];
    
    
    /*
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[url path] parameters:params];
    [request setHTTPShouldHandleCookies:YES];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        if ([result rangeOfString:@"跑着去兜风"].location == NSNotFound)
        {
            NSLog(@"Douban Login fail");
        }else
        {
            NSLog(@"Douban Login Succ!");
        }
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: url];
        for (NSHTTPCookie *cookie in cookies)
        {
            NSLog(@"cookie:%@",cookie);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    [operation start];
    */
}
- (void) loginCSDN2
{
    NSURL * url = [NSURL URLWithString:@"https://passport.csdn.net/ajax/accounthandler.ashx"];
    NSLog(@"base:%@,path:%@",[url baseURL],[url path]);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://passport.csdn.net"]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"log", @"t",
                            @"hjue", @"u",
                            @"",@"p",
                            @"1",@"remember",
                            @"http://www.csdn.net/",@"f",
                            @"0.0732567512895912",@"rand",
                            nil];
    /*
     [httpClient getPath:@"/ajax/accounthandler.ashx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"Login result:%@",operation.responseString);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"error:%@",error);
     }];
     */
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[url path] parameters:params];
    [request setHTTPShouldHandleCookies:YES];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",[[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:@"https://passport.csdn.net"]];
        for (NSHTTPCookie *cookie in cookies)
        {
            NSLog(@"cookie:%@",cookie);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    [operation start];
    
}
- (void) viewDidLoad
{
    [_textField setDelegate:self];
    _textField.placeholder = @"Code";
}
- (void) login12306
{
    NSLog(@"Text:%@",_textField.text);
    /*
    NSURL *url = [NSURL URLWithString:@"https://dynamic.12306.cn/otsweb"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setAuthenticationAgainstProtectionSpaceBlock:^BOOL(NSURLConnection *connection, NSURLProtectionSpace *protectionSpace) {
        return YES;
    }];
    [operation setAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        }
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success %@",operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"AFNetworking error: %@",error);
    }];
    [operation start];
    */
    /*
    AFHTTPClient *httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://dynamic.12306.cn/"]];
    [httpClient getPath:@"/otsweb" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
     */
    TDBHTTPClient *tdbHttpClient = [TDBHTTPClient sharedClient];
    /*
    [tdbHttpClient getPath:@"/otsweb" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
    
    [tdbHttpClient getPath:@"/otsweb/loginAction.do?method=loginAysnSuggest" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    */
    NSDictionary *para = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"472",@"loginRand",
                          @"N",@"refundLogin",
                          @"Y",@"refundFlag",
                          @"haojue@gmail.com",@"loginUser.user_name",
                          @"",@"nameErrorFocus",
                          @"",@"user.password",
                          @"",@"passwordErrorFocus",
                          _textField.text, @"randCode",
                          @"",@"randErrorFocus",
                          nil];
    [tdbHttpClient postPath:@"/otsweb/loginAction.do?method=init" parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    return YES;
}

@end
