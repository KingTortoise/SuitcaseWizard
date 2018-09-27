//
//  MD5Util.h
//  
//
//  Created by 金建新 on 11-8-18.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h> 

//md5 加密
@interface MD5Util : NSObject {

}

+ (NSString *) md5Encrypt:(NSString *)str;
+ (NSString *) md5ForFileContent:(NSString *)file;
+ (NSString *) md5ForData:(NSData *)data;

@end
