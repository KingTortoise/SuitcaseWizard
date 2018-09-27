//
//  WizardHomeAPI.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/6.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <XNetworking/XNetworking.h>

@interface WizardHomeAPI : XNRequest<XNRequestProtocol>
@property (nonatomic, strong)NSNumber *userId;

@end
