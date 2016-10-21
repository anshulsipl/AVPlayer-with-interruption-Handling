# AVPlayer-with-interruption-Handling

   
    
    
    /* This is for getting lock screen events and will respond to delegates when lock screen receive actions */
    [self becomeFirstResponder];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    /* Audio session to play in background and set audio  sessions active */
    AVAudioSession *aSession = [AVAudioSession sharedInstance];
    [aSession setCategory:AVAudioSessionCategoryPlayback
              withOptions:AVAudioSessionCategoryOptionAllowBluetooth
                    error:&myErr];
    [aSession setMode:AVAudioSessionModeDefault error:&myErr];
    [aSession setActive: YES error: &myErr];
    
    /* Observer for handling interruption */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAudioSessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:aSession];
    
    
   
    
      /* Player method. Pass your audio url, audio title and frequency(If any) */
      [self setPlayerURL:[NSURL URLWithString:@"YourStreamURl"] withStationName:@"Dummy" andStationDial:@"Dial"];


/* set Player URL from all the screens of app. and set name on player with dial FM. Also it will clear instance of already playing on player.*/

      -(void)setPlayerURL:(NSURL *)str_URL withStationName:( NSString *)str_stname andStationDial:(NSString *)str_fm
      {    

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
               //MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage: [UIImage imageNamed:@"youricon"]];
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
            [[AVAudioSession sharedInstance] setActive: YES error: nil];
            if (interruptionOption.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
                // Here you should continue playback.
                // Resume after exteranl interruption.            
                [_audioPlayer play];
            }
        } break;
        default:            break;
    }
}
