/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

#import <ScanditCaptureCore/SDCDataCaptureView.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCDataCaptureView (Defaults)

@property (class, nonatomic, readonly) SDCMarginsWithUnit defaultScanAreaMargins;
@property (class, nonatomic, readonly) SDCPointWithUnit defaultPointOfInterest;
@property (class, nonatomic, readonly) SDCAnchor defaultLogoAnchor;
@property (class, nonatomic, readonly) SDCPointWithUnit defaultLogoOffset;

@end

NS_ASSUME_NONNULL_END
