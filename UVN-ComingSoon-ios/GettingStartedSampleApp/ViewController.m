//
//  ViewController.m
//  GettingStartedSampleApp
//
//  Created by Chris Leonavicius on 1/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "OOOoyalaError.h"
#import "OOOoyalaPlayer.h"
#import "OOooyalaPlayerViewController.h"
#import "OOPlayerDomain.h"
#import "OOVideo.h" // You have to import this header, or you will get compiler errors when trying to interact with OOAuthCode.

@interface ViewController()
@property(nonatomic, strong) NSDateFormatter* formatter;
@end

@implementation ViewController

NSString * const EMBED_CODE = @"92YWgybjqtIqp6s9yqAgaHjWqIdVXsJH";
NSString * const PCODE = @"Z5Mm06XeZlcDlfU_1R9v_L2KwYG6";
NSString * const PLAYERDOMAIN = @"http://www.ooyala.com";

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Create Ooyala ViewController
  _ooyalaPlayerViewController = [[OOOoyalaPlayerViewController alloc] initWithPcode:PCODE domain:[[OOPlayerDomain alloc] initWithString:PLAYERDOMAIN]];

  // Attach it to current view
  [self addChildViewController:_ooyalaPlayerViewController];
  [_ooyalaPlayerViewController.view setFrame:_playerView.bounds];
  [self addChildViewController:_ooyalaPlayerViewController];
  [_playerView addSubview:_ooyalaPlayerViewController.view];

  // Setup an UI_textView for dislaying message
  [self.view addSubview:_textView];
  [_textView setText: @"LOG:"];

  // Hide Keyboard by setting the size of keyboard to (0, 0)
  UIView* keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  _textView.inputView = keyboardView;

  // Setup time format
  _formatter = [[NSDateFormatter alloc] init];
  NSTimeZone *zone = [NSTimeZone localTimeZone];
  [_formatter setTimeZone:zone];
  [_formatter setDateFormat:@"\nyyyy-MM-dd HH:mm:ss \n"];

  // Load the video
  [_ooyalaPlayerViewController.player setEmbedCode:EMBED_CODE];
  [[NSNotificationCenter defaultCenter] addObserver: self
                                        selector:@selector(notificationHandler:)
                                        name:nil
                                        object:_ooyalaPlayerViewController.player];

 }

- (void)onPlayerError:(NSNotification*)notification {
  NSLog(@"Error: %@", _ooyalaPlayerViewController.player.error);
}

// This is the method you want to look at if you need to respond to player events.
- (void) notificationHandler:(NSNotification*) notification {

  NSString* name = notification.name;
  if ([name isEqualToString:OOOoyalaPlayerTimeChangedNotification]) {
    return; // do something when we do need the timeChanged notification
  }

    // Check for Authorization Error Codes. Fetch it from the player's current item authCode.
    OOAuthCode errorCode = _ooyalaPlayerViewController.player.currentItem.authCode;
    // In this example, we are catching Before or After flight time errors.
    if (errorCode == OOAuthCodeBeforeFlightTime || errorCode == OOAuthCodeAfterFlightTime) {
        //Display a simple alert with a Coming Soon message.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Box" message:@"Coming Soon" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

  NSDate* timer = [[NSDate alloc] init];
  NSString* timeStamp = [_formatter stringFromDate:timer];
  timeStamp = [timeStamp substringToIndex: [timeStamp length] - 2];
    
  if ([name isEqualToString:OOOoyalaPlayerErrorNotification]) {
    NSString* error = _ooyalaPlayerViewController.player.error.description;
    [_textView insertText:[NSString stringWithFormat:@"%@,%@,%@", timeStamp, @" Error: ", error]];
  } else if ([name isEqualToString:OOOoyalaPlayerStateChangedNotification]) {
    OOOoyalaPlayerState* state = _ooyalaPlayerViewController.player.state;
    NSString* currentState = [OOOoyalaPlayer playerStateToString:state];
    [_textView insertText:[NSString stringWithFormat:@"%@,%@,%@", timeStamp, @" State: ", currentState]];
  } else {
    [_textView insertText:[NSString stringWithFormat:@"%@,%@,%@", timeStamp, @" ", name]];
  }
    
  [_textView insertText:@"\n"];
  [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 0)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

@end
