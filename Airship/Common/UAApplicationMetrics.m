/*
 Copyright 2009-2014 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "UAApplicationMetrics+Internal.h"
#import "UAPreferenceDataStore.h"

@interface UAApplicationMetrics()
@property (nonatomic, strong) UAPreferenceDataStore *dataStore;
@end

@implementation UAApplicationMetrics
NSString *const UAApplicationMetricLastOpenDate = @"UAApplicationMetricLastOpenDate";

- (instancetype)initWithDataStore:(UAPreferenceDataStore *)dataStore {
    self = [super init];
    if (self) {
        // App inactive/active for incoming calls, notification center, and taskbar
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }

    return self;
}

+ (instancetype)applicationMetricsWithDataStore:(UAPreferenceDataStore *)dataStore {
    UAApplicationMetrics *metrics = [[UAApplicationMetrics alloc] init];
    metrics.dataStore = dataStore;

    [metrics.dataStore migrateUnprefixedKeys:@[UAApplicationMetricLastOpenDate]];

    return metrics;
}

- (void)didBecomeActive {
    self.lastApplicationOpenDate = [NSDate date];
}

- (NSDate *)lastApplicationOpenDate {
    return [self.dataStore objectForKey:UAApplicationMetricLastOpenDate];
}

- (void)setLastApplicationOpenDate:(NSDate *)date {
    [self.dataStore setObject:date forKey:UAApplicationMetricLastOpenDate];
}

@end
