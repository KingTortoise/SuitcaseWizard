//
//  XNServerSW.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XNServerSW : NSObject<XNServerProtocol>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *imageHost;

+ (XNServerSW *)nodeServer;
+ (NSArray *)serverList;
@end
