//
//  ViewController.m
//  avplayerdemo
//
//  Created by The Anshul Jain on 06/10/16.
//  Copyright © 2016 UseButton_NZBT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSError *myErr;
    // Initialize the AVAudioSession here.
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
        [[AVAudioSession sharedInstance]setActive:YES error:&myErr ];
        // Handle the error here.
        NSLog(@"Audio Session error %@, %@", myErr, [myErr userInfo]);
    }
    else{
        // Since there were no errors initializing the session, we'll allow begin receiving remote control events
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
  
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSError *myErr;
   
    //[[AVAudioSession sharedInstance]setActive:YES error:&myErr ];
    //[[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:&myErr];
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    AVAudioSession *aSession = [AVAudioSession sharedInstance];
    [aSession setCategory:AVAudioSessionCategoryPlayback
              withOptions:AVAudioSessionCategoryOptionAllowBluetooth
                    error:&myErr];
    [aSession setMode:AVAudioSessionModeDefault error:&myErr];
    [aSession setActive: YES error: &myErr];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAudioSessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:aSession];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMediaServicesReset)
                                                 name:AVAudioSessionMediaServicesWereResetNotification
                                               object:aSession];
    
    
      [self setPlayerURL:[NSURL URLWithString:@"YourStreamURl"] withStationName:@"Dummy" andStationDial:@"Dial"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleMediaServicesReset {
    // • No userInfo dictionary for this notification
    // • Audio streaming objects are invalidated (zombies)
    // • Handle this notification by fully reconfiguring audio
}




#pragma Manage Media from Lock Screen
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    UIEventSubtype rc = event.subtype;
    NSLog(@"got a remote event! %ld", (long)rc);
    if (rc == UIEventSubtypeRemoteControlPlay) {
        
       
            [_audioPlayer play];
       
        
        
    } else if (rc == UIEventSubtypeRemoteControlPause) {
        [_audioPlayer pause];
        
        
        
    }
    else if (rc == UIEventSubtypeRemoteControlStop)
    {
        
    }
    else if (rc == UIEventSubtypeRemoteControlTogglePlayPause)
    {
        
    }
    else if (rc == UIEventSubtypeRemoteControlNextTrack)
    {

        
        
    }
    else if (rc == UIEventSubtypeRemoteControlPreviousTrack)
    {

    }
    else if (rc == UIEventSubtypeRemoteControlBeginSeekingBackward)
    {
        
        
    }
    else if (rc == UIEventSubtypeRemoteControlEndSeekingBackward)
    {
        
    }
    else if (rc == UIEventSubtypeRemoteControlBeginSeekingForward)
    {
        
    }
    else if (rc == UIEventSubtypeRemoteControlEndSeekingForward)
    {
        
    }
    
}

#pragma Singleton method to set Player URL from all the screens of app. and set name on player with FM. Also it will clear instance of already playing on player.
-(void)setPlayerURL:(NSURL *)str_URL withStationName:( NSString *)str_stname andStationDial:(NSString *)str_fm{
    
    
    
    NSURL *url = str_URL;
    AVPlayer *player = [[AVPlayer alloc]initWithURL:url];
    if (_audioPlayer != nil)
    {
        @try {
            [_audioPlayer removeObserver:self forKeyPath:@"status" context:nil];
        } @catch (NSException *exception) {
            NSLog(@"Catch player exception");
        }
    }
    _audioPlayer = player;
    
    NSLog(@"got a remote event 11! %@ AND player.currentItem%@", url,player.currentItem);
    NSLog(@"_audioPlayer.currentItem! %@", _audioPlayer.currentItem);
    NSLog(@"_audioPlayer.currentItem 33! %f", _audioPlayer.rate);

    
    [_audioPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];

}


#pragma Observer for Player status.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (object == _audioPlayer && [keyPath isEqualToString:@"status"]) {
        if (_audioPlayer.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
           
        } else if (_audioPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
                [_audioPlayer play];
            
            
            
         
            
            
            
            Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
            if (playingInfoCenter)
            {
                NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
               //MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imageNamed:@"logo2"]];
                [songInfo setObject:@"Application name" forKey:MPMediaItemPropertyTitle];
                [songInfo setObject:@"Heading" forKey:MPMediaItemPropertyArtist];
                [songInfo setObject:@"Title" forKey:MPMediaItemPropertyAlbumTitle];
                //[songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
                
            }
            
        } else if (_audioPlayer.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
           
            
        }
        [_audioPlayer removeObserver:self forKeyPath:@"status" context:nil];
    }
    
}





- (void)handleAudioSessionInterruption:(NSNotification*)notification {
    
    NSNumber *interruptionType = [[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey];
    NSNumber *interruptionOption = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey];
    
    
    switch (interruptionType.unsignedIntegerValue) {
        case AVAudioSessionInterruptionTypeBegan:{
            // • Audio has stopped, already inactive
            // • Change state of UI, etc., to reflect non-playing state
             [_audioPlayer pause];
            
        } break;
        case AVAudioSessionInterruptionTypeEnded:{
            // • Make session active
            // • Update user interface
            // • AVAudioSessionInterruptionOptionShouldResume option
           // [self playOnInterupption];
            
            [[AVAudioSession sharedInstance] setActive: YES error: nil];
            if (interruptionOption.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
                // Here you should continue playback.
                // Resume after exteranl interruption.
                
                
                [_audioPlayer play];
                
                
                
            }
        } break;
        default:
            break;
    }
}
-(void)playOnInterupption
{

        
  [self setPlayerURL:[NSURL URLWithString:@"your Stream Url"] withStationName:@"Dummy" andStationDial:@"Dial"];


    
}

@end
