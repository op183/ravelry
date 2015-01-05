//
//  SprintFVAList.m
//  ravelry
//
//  Created by Kellan Cummings on 1/1/15.
//  Copyright (c) 2015 Kellan Cummings. All rights reserved.
//

#import "SprintFVAList.h"

+ (NSString *) sprintfWithFormat:(NSString *)format, ... {
    va_list argp;
    va_start(argp, arguments);
    
    (NSString) string = [SprintFVAList sprintfWithFormat:format args:argp];

    va_end(argp);

    return string;
}

+ (NSString *) sprintfWithFormat:(NSString *)format args:(va_list) args {
    return [NSString stringWithFormat:format arguments:args]
}