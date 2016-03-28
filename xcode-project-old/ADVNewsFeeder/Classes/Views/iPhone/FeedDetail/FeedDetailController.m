//
//  FeedDetailController.m
//  ADVNewsFeeder
//
//  Created by Tope on 10/04/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "FeedDetailController.h"
#import "AppDelegate.h"

@interface FeedDetailController ()

@end

@implementation FeedDetailController

- (void)viewDidLoad {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    [[AppDelegate instance].theme customizeArticleDetail:self];
    
    self.title = @"Article";
    
    [self.shareButtonsContainer setAlpha:0.0f];
    
    [self.mainArticleView removeFromSuperview];
    [self.mainArticleView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    
    [self.articleWebView setDelegate:self];
    [self.articleWebView.scrollView setScrollEnabled:NO];
    [self.articleWebView.scrollView setBounces:NO];
    
    NSString* content = [self addCSSTo:self.article.content];
    [self.articleWebView loadHTMLString:content baseURL:nil];
    
    [self.titleLabel setText:self.article.title];
    [self.dateLabel setText:self.article.dateString];
    if(self.article.image){
        [self setupControllerWithImages:@[self.article.image] andView:self.mainArticleView];
    }
    else {
        [self setupControllerWithImages:[NSArray array] andView:self.mainArticleView];
        if(_article.imageUrl){
            
            dispatch_async(dispatch_get_global_queue(
                                                     DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *imageURL = [NSURL URLWithString:_article.imageUrl];
                
                __block NSData *imageData;
                
                dispatch_sync(dispatch_get_global_queue(
                                                        DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    imageData =[NSData dataWithContentsOfURL:imageURL];
                    
                    _article.image = [UIImage imageWithData:imageData];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self addImages:@[_article.image]];
                    });
                });
            });
        }
    }
    
    [super viewDidLoad];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)shareButtonTapped:(id)sender{
    
    UIButton* button = (UIButton*)sender;
    
    NSString *serviceType = SLServiceTypeFacebook;
    
    if(button.tag == 1){
        
        serviceType = SLServiceTypeTwitter;
    }
    
    if ([SLComposeViewController isAvailableForServiceType:serviceType])
    {   
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        
        NSString *textToShare = self.article.title;
        
        [composeViewController setInitialText:textToShare];
        
        if(self.article.image){
            [composeViewController addImage:self.article.image];
        }
        
        [composeViewController addURL:[NSURL URLWithString:self.article.link]];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    else{
        
        NSString* alertString = @"Please add a Twitter/Facebook account for the network you plan to share to. You can do this in the Settings app";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add account" message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
    }
}


#pragma mark - UIWebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (![[[request URL] scheme] isEqual:@"about"]) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webview {
    [self setupArticleView];    
}

- (void)detectOrientation {
    [self setupArticleView];
}

- (void)setupArticleView {
    
    
    CGRect frame = self.articleWebView.frame;
    CGSize fittingSize = [self.articleWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    self.articleWebView.frame = frame;
    
    CGFloat totalHeight = self.articleWebView.frame.origin.y + self.articleWebView.frame.size.height + 30;   
    
    CGRect articleFrame = self.mainArticleView.frame;
    [self.mainArticleView setFrame:CGRectMake(articleFrame.origin.x, articleFrame.origin.y, self.view.bounds.size.width, totalHeight)];
        
    [self.articleWebView stringByEvaluatingJavaScriptFromString:
     [NSString stringWithFormat:
      @"document.body.style.width = '%dpx'; ",
      (int)self.view.frame.size.width - 40]];
    [self.articleWebView setNeedsLayout];
    
    [self resetHeight];
}

- (void)resetHeight {
    CGRect frame = self.articleWebView.frame;
    frame.size.height = [[self.articleWebView stringByEvaluatingJavaScriptFromString:
                          @"document.getElementById(\"ContentDiv\").offsetHeight"] floatValue] + 20;
    self.articleWebView.frame = frame;
    
    CGFloat totalHeight = self.articleWebView.frame.origin.y + self.articleWebView.frame.size.height + 10;
    
    CGRect shareFrame = self.shareButtonsContainer.frame;
    
    CGRect articleFrame = self.mainArticleView.frame;
    [self.mainArticleView setFrame:CGRectMake(articleFrame.origin.x, articleFrame.origin.y, self.view.bounds.size.width, totalHeight+shareFrame.size.height)];    
    
    shareFrame.origin.y = totalHeight;
    shareFrame.size.width = self.view.bounds.size.width;
    self.shareButtonsContainer.frame = shareFrame;
    
    [self.shareButtonsContainer setAlpha:1.0f];
    [self layoutContent];
    [self viewWillAppear:NO];
}

-(NSString*)addCSSTo:(NSString*)content
{
    
    CGRect frame = self.articleWebView.frame;
    
    int width = frame.size.width;
    NSString* imageCSS = @"img {max-width: 100%; height: auto; border:3px solid #ffffff; box-shadow: 1px 1px 4px #dddddd;} \n";
    
    NSString* webContent = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {width: %dpx; text-shadow: 0px 1px 0px #fff; color:#4a4a4a; font-family: \"%@\"; font-size: %@;} %@\n"
                            "</style> \n"
                            "</head> \n"
                            "<body><div id='ContentDiv'>%@</div></body> \n"
                            "</html>", width, @"Avenir-Book", @14, imageCSS, content
                            ];
    
    return webContent;
}

@end
