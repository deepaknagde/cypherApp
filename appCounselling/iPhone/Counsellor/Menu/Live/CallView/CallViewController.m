#import "CallViewController.h"
#import "CallViewController+UI.h"
#import <Sinch/SINUIView+Fullscreen.h>

// Usage of gesture recognizers to toggle between front- and back-camera and fullscreen.
//
// * Double tap the local preview view to switch between front- and back-camera.
// * Single tap the local video stream view to make it go full screen.
//     Tap again to go back to normal size.
// * Single tap the remote video stream view to make it go full screen.
//     Tap again to go back to normal size.

@interface CallViewController () <SINCallDelegate>
@property (weak, nonatomic) IBOutlet UIGestureRecognizer *remoteVideoFullscreenGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIGestureRecognizer *localVideoFullscreenGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIGestureRecognizer *switchCameraGestureRecognizer;
@end

@implementation CallViewController

@synthesize strUserFirstName;

- (id<SINAudioController>)audioController {
  return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] client] audioController];
}

- (id<SINVideoController>)videoController {
  return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] client] videoController];
}

- (void)setCall:(id<SINCall>)call {
  _call = call;
  _call.delegate = self;
}

#pragma mark - UIViewController Cycle

- (void)viewDidLoad {
  [super viewDidLoad];

    self.Btn_OtletMenu.selected = NO;

  if ([self.call direction] == SINCallDirectionIncoming) {
    [self setCallStatusText:@""];
    [self showButtons:kButtonsAnswerDecline];
    [[self audioController] startPlayingSoundFile:[self pathForSound:@"incoming.wav"] loop:YES];
  } else {
    [self setCallStatusText:@"calling..."];
    [self showButtons:kButtonsHangup];
  }

  if ([self.call.details isVideoOffered]) {
    [self.localVideoView addSubview:[[self videoController] localView]];

    [self.localVideoFullscreenGestureRecognizer requireGestureRecognizerToFail:self.switchCameraGestureRecognizer];
    [[[self videoController] localView] addGestureRecognizer:self.localVideoFullscreenGestureRecognizer];
    [[[self videoController] remoteView] addGestureRecognizer:self.remoteVideoFullscreenGestureRecognizer];
  }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimerText:) name:@"timerOnCall" object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
    
    self.remoteUsername.text = self.strUserFirstName;// @"Young Person";//[self.call remoteUserId];
  [[self audioController] enableSpeaker];
}

- (void)changeTimerText:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"timerOnCall"])
    {
        NSDictionary* userInfo = notification.object;
        NSNumber* intTimeLeft = (NSNumber*)userInfo[@"total"];
        
        if(intTimeLeft.integerValue>=0)
            [self setDuration:intTimeLeft.integerValue];
    }
}

#pragma mark - Call Actions

- (IBAction)accept:(id)sender
{
    UIButton *btnSender = sender;
    
    if([btnSender isEqual:self.answerButton])
        [[NSNotificationCenter defaultCenter] postNotificationName:@"callAccepted" object:nil];
    
  [[self audioController] stopPlayingSoundFile];
  [self.call answer];
}

- (IBAction)decline:(id)sender {
  [self.call hangup];
  [self dismiss];
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hangup:(id)sender {
  [self.call hangup];
  [self dismiss];
    if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSwitchCameraTapped:(id)sender {
  AVCaptureDevicePosition current = self.videoController.captureDevicePosition;
  self.videoController.captureDevicePosition = SINToggleCaptureDevicePosition(current);
}

- (IBAction)onFullScreenTapped:(id)sender {
  UIView *view = [sender view];
  if ([view sin_isFullscreen]) {
    view.contentMode = UIViewContentModeScaleAspectFit;
    [view sin_disableFullscreen:YES];
  } else {
    view.contentMode = UIViewContentModeScaleAspectFill;
    [view sin_enableFullscreen:YES];
  }
}

- (void)onDurationTimer:(NSTimer *)unused {
//  NSInteger duration = [[NSDate date] timeIntervalSinceDate:[[self.call details] establishedTime]];
//  [self setDuration:duration];
}

#pragma mark - SINCallDelegate

- (void)callDidProgress:(id<SINCall>)call {
  [self setCallStatusText:@"ringing..."];
  [[self audioController] startPlayingSoundFile:[self pathForSound:@"ringback.wav"] loop:YES];
}

- (void)callDidEstablish:(id<SINCall>)call {
  [self startCallDurationTimerWithSelector:@selector(onDurationTimer:)];
  [self showButtons:kButtonsHangup];
  [[self audioController] stopPlayingSoundFile];
}

- (void)callDidEnd:(id<SINCall>)call {
  [self dismiss];
  [[self audioController] stopPlayingSoundFile];
  [self stopCallDurationTimer];
  [[[self videoController] remoteView] removeFromSuperview];
  [[self audioController] disableSpeaker];
  if(self.navigationController)
        [self.navigationController popViewControllerAnimated:YES];
  else
        [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)callDidAddVideoTrack:(id<SINCall>)call {
  [self.remoteVideoView addSubview:[[self videoController] remoteView]];
}
- (IBAction)Btn_mmute:(id)sender {
    
    if (self.Btn_OtletMenu.selected == YES) {
        self.Btn_OtletMenu.selected = NO;
        UIImage *btnImage = [UIImage imageNamed:@"unmute.png"];
        [_Btn_OtletMenu setImage:btnImage forState:UIControlStateNormal];
        
        id<SINAudioController> audio = [self audioController];
        [audio unmute];
        
    }else{
        self.Btn_OtletMenu.selected = YES;
        UIImage *btnImage = [UIImage imageNamed:@"muted.png"];
        [_Btn_OtletMenu setImage:btnImage forState:UIControlStateNormal];
        
        id<SINAudioController> audio = [self audioController];
        [audio mute];
    }
}

#pragma mark - Sounds

- (NSString *)pathForSound:(NSString *)soundName {
  return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundName];
}

@end
