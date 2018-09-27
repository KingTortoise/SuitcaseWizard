//
//  PlayMethodViewModel.h
//  SuitcaseWizard
//
//  Created by jinwenwu on 17/3/21.
//  Copyright © 2017年 金文武. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayMethodViewModel : NSObject
/* 保存玩法名称、亮点、介绍 */
@property (nonatomic, strong, readonly)RACCommand *savePlayMethodRACCommand;
/* 名称 */
@property (nonatomic, strong)NSString *title;
/* 亮点 */
@property (nonatomic, strong)NSString *strength;
/* 介绍 */
@property (nonatomic, strong)NSString *introduction;
@end
