/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
 Category to add block based Key Value Observation methods to NSObject. Added support for removing the observer from the observation block, to allow for one-shot observers (it's safe to invoke appl_removeObserver from the block).
 
 */

#import <Foundation/Foundation.h>

typedef void (^AAPLBlockObserver)(id obj, NSDictionary *change, id observer);
typedef AAPLBlockObserver EKBlockObserver;

/// Code base on Apple's WWDC14 AdvancedCollectionView Session sample
@interface NSObject (EKKVOBlock)

/// Add a block-based observer. Returns a token for use with removeObserverWithBlockToken:.
- (id)ek_addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options withBlock:(EKBlockObserver)block;

/// Remove block-based observer
- (void)ek_removeObserver:(id)observer;

@end
