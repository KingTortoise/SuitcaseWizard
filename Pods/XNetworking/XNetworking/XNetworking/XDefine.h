//
//  XDefine.h
//  XNetworking
//
//  Created by 金建新 on 16/9/19.
//  Copyright © 2016年 金建新. All rights reserved.
//

#ifndef XDefine_h
#define XDefine_h

#ifdef DEBUG
#define XLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define XLog(format, ...)
#endif

#define XWeakSelf(type)  __weak typeof(type) weak##type = type;
#define XStrongSelf(type)  __strong typeof(type) type = weak##type;


#endif /* XDefine_h */
