//
//  TDWebViewController.m
//  Three20-Demo
//
//  Created by haoyu on 13-1-15.
//  Copyright (c) 2013年 haoyu. All rights reserved.
//

#import "TDWebViewController.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation.h"

@interface TDWebViewController ()
{
    UIWebView *_webView;
    UIActivityIndicatorView * _activityIndicator;
    UIView *_opaqueview;
}
@end

@implementation TDWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


-(void)loadView
{
    [super loadView];
    if (_webView ==nil)
    {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
        _webView.delegate = self;
    }
    if (_opaqueview==nil)
    {
        _opaqueview = [[ UIView   alloc]  initWithFrame: CGRectMake(320/2-50,460/2-50,100,100)];
    }
    if (_activityIndicator==nil)
    {
//        _activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}


- (BOOL)skipCertCheck:(NSString *)url
{
    NSError *err;
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&err];
    if (err) {
        NSLog(@"Cer Check Error: %@",err);
    }
    return theConnection?YES:NO;
}

- (void)jsonDemoWithAFNetwoking
{
    NSURL *url = [NSURL URLWithString:@"http://httpbin.org/ip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
    } failure:nil];
    
    [operation start];
}

- (void)httpsDeomWithAFNetwoking
{
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
}

- (void)deomWithAFNetwoking
{
    [self httpsDeomWithAFNetwoking];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	if ([self skipCertCheck:@"https://dynamic.12306.cn/otsweb"])
    {
        NSLog(@"Skip Cert Check Success!");
    }else
    {
        NSLog(@"Skip Cert Check Fail!");
    }
    

//    [self deomWithAFNetwoking];
    
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc]initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(Login)];
    self.navigationItem.rightBarButtonItem = loginButton;
    NSString *urlStr = @"https://passport.csdn.net/account/login";
    urlStr = @"https://dynamic.12306.cn/otsweb/order/querySingleAction.do?method=init";
    urlStr = @"https://dynamic.12306.cn/otsweb";

    [_webView setUserInteractionEnabled:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];

    [_webView loadRequest:request];
    [_activityIndicator setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
    
//    [_activityIndicator startAnimating];
    [_opaqueview setBackgroundColor:[UIColor blackColor]];
    [_opaqueview setAlpha:0.6f];

    [self.view addSubview:_activityIndicator];
//    [_opaqueview addSubview:_activityIndicator];    
}

- (void)Login
{
//    if ([_webView isLoading])
//    {
//        TTAlert(@"正在加载中，请稍后再试!");
//        return;
//    }
    NSString *url = [[[_webView request]URL]absoluteString];
    if ([url rangeOfString:@"csdn.net"].location!= NSNotFound) {
        [_webView stringByEvaluatingJavaScriptFromString: [self autoLoginCsdnJs]];
    }
    if ([url rangeOfString:@"12306.cn"].location!= NSNotFound) {
        [_webView stringByEvaluatingJavaScriptFromString: [self autoLogin12306Js]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) autoLoginCsdnJs
{
    NSString *savedUsername = @"hjue";
    NSString *savedPassword = @"";
    NSString *loadJs;
    if (savedUsername.length != 0 && savedPassword.length != 0) {
        //create js strings
        
        loadJs = [NSString stringWithFormat:@"var doc=document.querySelector(\"#logfrm\").contentDocument;"
                            @"doc.querySelector(\"#u\").value=\"%@\";"
                            @"doc.querySelector(\"#p\").value=\"%@\";"
                            @"doc.querySelector(\"#chkRemember\").checked=\"checked\";"
                            @"doc.querySelector(\"#aLogin\").click();"
                            ,savedUsername,savedPassword];
    }
    return loadJs;
    
}

- (NSString *) autoLogin12306Js
{
    NSString *savedUsername = @"haojue@gmail.com";
    NSString *savedPassword = @"";
    NSString *loadJs;
    if (savedUsername.length != 0 && savedPassword.length != 0) {

        loadJs = [NSString stringWithFormat:@"var doc =document.querySelector(\"#main\").contentDocument;"
                  @"doc.querySelector(\"input[name='loginUser.user_name']\").value=\"%@\";"
                  @"doc.querySelector(\"input[name='user.password']\").value=\"%@\";"
                  @"doc.querySelector(\".button_a\").click();"
                  ,savedUsername,savedPassword];
    }
    return loadJs;
    
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_activityIndicator startAnimating];
    [_opaqueview setHidden:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.loading)
    {
        return;
    }
    [_activityIndicator stopAnimating];
    [_opaqueview setHidden:YES];
    NSLog(@"didFinish: %@; stillLoading:%@", [[[webView request]URL]absoluteString],
          (webView.loading?@"YES":@"NO"));
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Webview error:%@",error);
}


#pragma mark -
#pragma mark NSConnection delegate
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    BOOL isAllow;
    isAllow = [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    return isAllow;
}



- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
//    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
}
@end
