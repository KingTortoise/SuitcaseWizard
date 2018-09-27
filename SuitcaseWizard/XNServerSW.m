//
//  XNServerSW.m
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import "XNServerSW.h"
#import "StrokeArrangement.h"
#import "Package.h"

@implementation XNServerSW
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static XNServerSW *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [XNServerSW nodeServer];
    });
    return sharedInstance;
}

+ (XNServerSW *)nodeServer {
    XNServerSW *server = [[XNServerSW alloc] init];
    server.name = @"线上正式版";
    server.host = @"10.100.164.128:3000";
    server.imageHost = @"www.xyz.cn";
    return server;
}

+ (NSArray *)serverList{
    return @[[self nodeServer]];
}

- (NSDictionary*)appendSignature:(NSDictionary *)params {
    return params;
}

- (NSString *)buildQueryString:(NSDictionary*)params {
    NSArray *keys = [params allKeys];
    NSMutableString *paramString = [[NSMutableString alloc] init];
    for (int i = 0; i < keys.count; i ++) {
        id value = [params objectForKey:keys[i]];
        if ([keys[i] isEqualToString:@"prices"]) {
            NSString *valueStr = value;
            NSInteger length = valueStr.length - 11;
            NSString *str = [valueStr substringWithRange:NSMakeRange(10,length)];
            if (i == keys.count - 1) {
                [paramString appendFormat:@"%@=%@",keys[i],[self urlEncode:str]];
            }else{
                [paramString appendFormat:@"%@=%@&",keys[i],[self urlEncode:str]];
            }
        }else if([keys[i] isEqualToString:@"travelRoute"]){
            NSString *valueStr = value;
            NSInteger length = valueStr.length - 16;
            NSString *str =[valueStr substringWithRange:NSMakeRange(15,length)];
            if (i == keys.count - 1) {
                [paramString appendFormat:@"%@=%@",keys[i], [self urlEncode:str]];
            }else{
                [paramString appendFormat:@"%@=%@&",keys[i],[self urlEncode:str]];
            }
        }else{
            if ([value isKindOfClass:[NSString class]]) {
                if (i == keys.count - 1) {
                    [paramString appendFormat:@"%@=%@",keys[i],[self urlEncode:[params objectForKey:keys[i]]]];
                }else{
                    [paramString appendFormat:@"%@=%@&",keys[i],[self urlEncode:[params objectForKey:keys[i]]]];
                }
            }else if ([value isKindOfClass:[NSNumber class]]) {
                if (i == keys.count - 1) {
                    [paramString appendFormat:@"%@=%@",keys[i],[self urlEncode:[[params objectForKey:keys[i]] stringValue]]];
                }else{
                    [paramString appendFormat:@"%@=%@&",keys[i],[self urlEncode:[[params objectForKey:keys[i]] stringValue]]];
                }
            }else if ([value isKindOfClass:[NSArray class]]) {
                NSArray *arrayValue = [params objectForKey:keys[i]];
                for (id value in arrayValue) {
                    NSString *str = [self buildQueryString: value];
                    if (i == keys.count - 1) {
                        [paramString appendFormat:@"%@=%@",keys[i],[self urlEncode:str]];
                    }else{
                        [paramString appendFormat:@"%@=%@&",keys[i],[self urlEncode:str]];
                    }
                    
                }
            }
        }
    }
    return paramString;
}

- (NSString *)urlEncode:(NSString *)value {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)value,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}
@end
