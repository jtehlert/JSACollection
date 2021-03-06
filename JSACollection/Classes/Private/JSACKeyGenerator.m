//
//  JSACKeyGenerator.m
//  JSADataExample
//
//  Created by Nelson LeDuc on 12/17/13.
//  Copyright (c) 2013 Jump Space Apps. All rights reserved.
//

#import "JSACKeyGenerator.h"
#import "NSObject+ListOfProperties.h"

static NSString * const kJSACollectionPropertyPrefix = @"jsc_";

@implementation JSACKeyGenerator

+ (NSDictionary *)keyListFromClass:(Class)clazz ofType:(JSACKeyGeneratorKeyType)type {
    NSArray *properties = nil;
    switch (type) {
        case JSACKeyGeneratorKeyTypeAll:
            properties = [clazz listOfProperties];
            break;
        case JSACKeyGeneratorKeyTypeNonStandard:
            properties = [clazz listOfNonStandardProperties];
            break;
        case JSACKeyGeneratorKeyTypeStandard:
            properties = [clazz listOfStandardProperties];
            break;
    }
    
    return [self generatedKeyListFromArray:properties];
}

+ (NSDictionary *)generatedKeyListFromArray:(NSArray *)array
{
    NSMutableDictionary *keyDict = [[NSMutableDictionary alloc] init];
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"([a-z])([A-Z])" options:0 error:nil];
    
    for (NSString *propertyName in array)
    {
        NSString *prop = propertyName;
        if ([[prop lowercaseString] hasPrefix:kJSACollectionPropertyPrefix] && [prop length] > [kJSACollectionPropertyPrefix length]) {
            prop = [prop substringFromIndex:[kJSACollectionPropertyPrefix length]];
        }
        
        NSTextCheckingResult *first = [regexp firstMatchInString:prop options:0 range:NSMakeRange(0, prop.length)];
        NSString *firstWord = [prop substringToIndex:first.range.location + 1];
        if (first && firstWord) {
            keyDict[firstWord] = propertyName;
        }
        
        NSString *underscores = [regexp stringByReplacingMatchesInString:prop options:0 range:NSMakeRange(0, prop.length) withTemplate:@"$1_$2"];
        NSString *dashes = [regexp stringByReplacingMatchesInString:prop options:0 range:NSMakeRange(0, prop.length) withTemplate:@"$1-$2"];
        if (underscores) {
            keyDict[underscores] = propertyName;
        }
        if (dashes) {
            keyDict[dashes] = propertyName;
        }
        
        keyDict[prop] = propertyName;
    }
    
    return [keyDict copy];
}

@end
