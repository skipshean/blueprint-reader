//
//  FeedDetailControlleriPad.m
//  ADVNewsFeeder
//
//  Created by Tope on 01/05/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "FeedDetailControlleriPad.h"
#import "AppDelegate.h"

@interface FeedDetailControlleriPad ()

@end

@implementation FeedDetailControlleriPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[AppDelegate instance].theme customizeArticleDetailiPad:self];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = @"Article";
    self.navigationItem.titleView = titleLabel;
    
    [self.articleWebView setDelegate:self];
    [self.articleWebView.scrollView setScrollEnabled:NO];
    [self.articleWebView.scrollView setBounces:NO];
    
    NSString* content = [self addCSSTo:self.article.content];
    [self.articleWebView loadHTMLString:content baseURL:nil];
    
    [self.titleLabel setText:self.article.title];
    [self.dateLabel setText:self.article.dateString];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self didRotateFromInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
}


- (void)dealloc {
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.articleWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.style.width = \"%fpx\";", self.view.frame.size.width - 100]];
    
    [self setupArticleView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview {
   [self setupArticleView];
}


- (void)setupArticleView {
    
    
    CGRect frame = self.articleWebView.frame;
    CGSize fittingSize = [self.articleWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    self.articleWebView.frame = frame;

    CGFloat contentHeight = self.articleWebView.frame.origin.y + self.articleWebView.frame.size.height + 50;
    CGSize contentSize =  CGSizeMake(self.view.bounds.size.width, contentHeight);
    [self.scrollView setContentSize:contentSize];
    
    [self.articleWebView setNeedsLayout];
    
}

-(NSString*)addCSSTo:(NSString*)content
{
    
    CGRect frame = self.view.frame;
    
    int width = frame.size.width - 100;
    NSString* imageCSS = @"img {max-width: 100%; height: auto; border:3px solid #ffffff; box-shadow: 1px 1px 4px #dddddd;} p {margin-bottom:10px;}\n";
    
    NSString* webContent = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {width: %dpx; text-shadow: 0px 1px 0px #fff; color:#4a4a4a; font-family: \"%@\"; font-size: %@; margin-left:\"auto\"; margin-right:\"auto\"} %@\n"
                            "</style> \n"
                            "</head> \n"
                            "<body><div id='ContentDiv'>%@</div></body> \n"
                            "</html>", width, @"Avenir-Book", @18, imageCSS, content
                            ];
    
    return webContent;
}

-(IBAction)close:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
