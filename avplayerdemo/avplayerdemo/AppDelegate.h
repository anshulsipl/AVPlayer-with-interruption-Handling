//
//  AppDelegate.h
//  avplayerdemo
//
//  Created by The Anshul Jain on 06/10/16.
//  Copyright © 2016 UseButton_NZBT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate,AVAudioSessionDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

