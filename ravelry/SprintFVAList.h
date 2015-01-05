//
//  SprintFVAList.h
//  ravelry
//
//  Created by Kellan Cummings on 1/1/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

#ifndef ravelry_SprintFVAList_h
#define ravelry_SprintFVAList_h

#import <Foundation/Foundation.h>

@interface SprintFVAList : NSObject

+ (NSString *) sprintfWithFormat:(NSString *)format, ...;
+ (NSString *) sprintfWithFormat:(NSString *)format args:(va_list) args;

@end

#endif
