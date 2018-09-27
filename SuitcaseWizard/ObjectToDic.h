//
//  ObjectToDic.h
//  XYZ_iOS
//
//  Created by ruikaiqiang on 17/2/4.
//  Copyright © 2017年 焦点科技. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
#pragma GCC diagnostic ignored "-Wdeprecated-implementations"

/**
 *  标记属性在集成http参数时展开对象
 */
@protocol ExpandProperty
@end

/**
 *  该属性标记在集成http参数时对数组中的内容展开为类似[0].
 */
@protocol IndexArrayProperty
@end


/**
 *  该属性标记在集成http参数时不将其放入参数中.
 */
@protocol IgnoreParam
@end

/**
 *  该属性标记为文件上传参数.
 */
@protocol FileUploadParam
@end



@interface ObjectToDic : NSObject

+ (NSDictionary*)getObjectData:(id)obj;

/**
 将对象转化为http参数的字典

 @param obj 转化的对象
 @return 返回的params
 */
+ (NSDictionary *)generateHTTPParams:(id)obj;

/**
 将对象转化为http参数的字典

 @param obj 转化的对象
 @param mapKeys 映射的keys {propertyName:httpParamKey}
 @return 返回的params
 */
+ (NSDictionary *)generateHTTPParams:(id)obj mapKeys:(NSDictionary *)mapKeys;


@end
