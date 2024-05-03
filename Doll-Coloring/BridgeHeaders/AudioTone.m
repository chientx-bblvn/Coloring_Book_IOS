//
//  AudioTone.m
//  Doll-Coloring
//
//  Created by BBLabs on 06/09/2023.
//

#import <Foundation/Foundation.h>
#import "AudioTone.h"
#define TONE_SAMPLERATE 44100.

@implementation AudioTone
@synthesize dB=_dB,frequency=_frequency;

void handleBuffer(void *inUserData,
                  AudioQueueRef inAQ,
                  AudioQueueBufferRef inBuffer);

#pragma mark - Initialization and deallocation -

- (id)init
{
    if ((self=[super init])) {
        [self initializeBuffer];
    }
    return self;
}

- (void)dealloc
{
    AudioQueueStop(queue, YES);
    AudioQueueFreeBuffer(queue, buffer);
    AudioQueueDispose(queue, YES);

//    [super dealloc];
}

-(void) initializeBuffer {
    _dB=0.;
    _frequency=440;
    rebuildBuffer=YES;

    // TO DO: handle AudioQueueXYZ's failures!!

    // create a descriptor containing a LPCM, mono, float format
    AudioStreamBasicDescription desc;

    desc.mSampleRate=TONE_SAMPLERATE;
    desc.mFormatID=kAudioFormatLinearPCM;
    desc.mFormatFlags=kLinearPCMFormatFlagIsFloat;
    desc.mBytesPerPacket=sizeof(float);
    desc.mFramesPerPacket=1;
    desc.mBytesPerFrame=sizeof(float);
    desc.mChannelsPerFrame=1;
    desc.mBitsPerChannel=8*sizeof(float);

    // create a new queue
    AudioQueueNewOutput(&desc,
                        &handleBuffer,
                        (__bridge void * _Nullable)(self),
                        CFRunLoopGetCurrent(),
                        kCFRunLoopCommonModes,
                        0,
                        &queue);

    // and its buffer, ready to hold 1" of data
    AudioQueueAllocateBuffer(queue,
                             sizeof(float)*TONE_SAMPLERATE,
                             &buffer);

    // create the buffer and enqueue it
    handleBuffer((__bridge void *)(self), queue, buffer);

}

#pragma mark - Main function -

void handleBuffer(void *inUserData,
                AudioQueueRef inAQ,
                AudioQueueBufferRef inBuffer) {

    // this function takes care of building the buffer and enqueuing it.

    // cast inUserData type to Tone
    AudioTone *tone=(__bridge AudioTone *)inUserData;

    // check if the buffer must be rebuilt
    if (tone->rebuildBuffer) {

        // precompute some useful qtys
        float *data=inBuffer->mAudioData;
        NSUInteger max=inBuffer->mAudioDataBytesCapacity/sizeof(float);

        // multiplying the argument by 2pi changes the period of the cosine
        //  function to 1s (instead of 2pi). then we must divide by the sample
        //  rate to get TONE_SAMPLERATE samples in one period.
        CGFloat unit=2.*M_PI/TONE_SAMPLERATE;
        // this is the amplitude converted from dB to a linear scale
        CGFloat amplitude=pow(10., tone.dB*.05);

        // loop and simply set data[i] to the value of cos(...)
        for (NSUInteger i=0; i<max; ++i)
            data[i]=(float)(amplitude*cos(unit*(CGFloat)(tone.frequency*i)));

        // inform the queue that we have filled the buffer
        inBuffer->mAudioDataByteSize=sizeof(float)*max;

        // and set flag
        tone->rebuildBuffer=NO;
    }

    // reenqueue the buffer
    AudioQueueEnqueueBuffer(inAQ,
                            inBuffer,
                            0,
                            NULL);

    /* TO DO: the transition between two adjacent buffers (the same one actually)
              generates a "tick", even if the adjacent buffers represent a continuous signal.
              maybe using two buffers instead of one would fix it.
     */
}

#pragma - Properties and methods -

- (void)play
{
    // generate an AudioTimeStamp with "0" simply!
    //  (copied from FillOutAudioTimeStampWithSampleTime)

    AudioTimeStamp time;

    time.mSampleTime=0.;
    time.mRateScalar=0.;
    time.mWordClockTime=0.;
    memset(&time.mSMPTETime, 0, sizeof(SMPTETime));
    time.mFlags = kAudioTimeStampSampleTimeValid;

    // TO DO: maybe it could be useful to check AudioQueueStart's return value
    AudioQueueStart(queue, &time);
}

- (void)pause
{
    // TO DO: maybe it could be useful to check AudioQueuePause's return value
    AudioQueuePause(queue);
}


- (void)clearQueue
{
    // TO DO: maybe it could be useful to check AudioQueuePause's return value
    AudioQueueStop(queue, YES);
    AudioQueueFreeBuffer(queue, buffer);
    AudioQueueDispose(queue, YES);
    
    [self initializeBuffer];
}

- (void)setFrequency:(NSUInteger)frequency
{
    if (_frequency!=frequency) {
        _frequency=frequency;

        // we need to update the buffer (as soon as it stops playing)
        rebuildBuffer=YES;
    }
}

- (void)setDB:(CGFloat)dB
{
    if (dB!=_dB) {
        _dB=dB;

        // we need to update the buffer (as soon as it stops playing)
        rebuildBuffer=YES;
    }
}

@end
