//
//  ViewController.h
//  avplayerdemo
//
//  Created by The Anshul Jain on 06/10/16.
//  Copyright © 2016 UseButton_NZBT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

@interface ViewController : UIViewController<AVAudioPlayerDelegate,AVAudioSessionDelegate>
{
    
}
@property (strong, nonatomic) AVPlayer *audioPlayer;
@end

