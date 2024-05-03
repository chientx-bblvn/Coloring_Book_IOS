//
//  AudioTone.h
//  Doll-Coloring
//
//  Created by BBLabs on 06/09/2023.
//

#ifndef AudioTone_h
#define AudioTone_h

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AudioTone : NSObject {
    AudioQueueRef queue;
    AudioQueueBufferRef buffer;
    BOOL rebuildBuffer;
}
@property (nonatomic, assign) NSUInteger frequency;
@property (nonatomic, assign) CGFloat dB;

- (void)play;
- (void)clearQueue;
- (void)pause;
@end

#endif /* AudioTone_h */
