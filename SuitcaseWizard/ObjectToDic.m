//
//  ObjectToDic.m
//  XYZ_iOS
//
//  Created by ruikaiqiang on 17/2/4.
//  Copyright © 2017年 焦点科技. All rights reserved.
//

#import "ObjectToDic.h"
#import <objc/runtime.h>
#import "StrokeArrangement.h"
#import "Package.h"

@implementation ObjectToDic

+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    for(int i = 0;i < propsCount; i++){
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        
        //get property attributes
        const char *attrs = property_getAttributes(prop);
        NSString* propertyAttributes = @(attrs);
        NSArray* attributeItems = [propertyAttributes componentsSeparatedByString:@","];
        
        //ignore read-only properties
        if ([attributeItems containsObject:@"R"]) {
            continue; //to next property
        }
        
        id value = [obj valueForKey:propName];
        if(value == nil){
            continue; //to next property
        }else{
            value = [self getObjectInternal:value];//自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]){
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]){
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++){
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys){
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}

////////////////////////
+ (NSDictionary *)generateHTTPParams:(id)obj
{
    return [self generateHTTPParams:obj mapKeys:nil];
}

+ (NSDictionary *)generateHTTPParams:(id)obj mapKeys:(NSDictionary *)mapKeys
{
    return [self generateDicBySuperKey:nil Object:obj mapKeys:mapKeys];
}

+ (NSDictionary *)generateDicBySuperKey:(NSString *)superKey Object:(id)obj mapKeys:(NSDictionary *)mapKeys
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        if (superKey.length > 0) {
            return [self getObjectInternal:obj superKey:superKey];
        }else{
            return obj;
        }
    }
    
    if ([obj isKindOfClass:[NSArray class]]) {
        [self getObjectInternal:obj superKey:superKey];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);//获得属性列表
    
    NSString* propertyType = nil;
    NSScanner* scanner = nil;
    for(int i = 0;i < propsCount; i++){
        BOOL isExpandProperty = NO;
        BOOL isIgnoreProperty = NO;
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];//获得属性的名称
        
        //get property attributes
        const char *attrs = property_getAttributes(prop);
        NSString* propertyAttributes = @(attrs);
        NSArray* attributeItems = [propertyAttributes componentsSeparatedByString:@","];
        
        //ignore read-only properties
        if ([attributeItems containsObject:@"R"]) {
            continue; //to next property
        }
        scanner = [NSScanner scannerWithString: propertyAttributes];
        [scanner scanUpToString:@"T" intoString: nil];
        [scanner scanString:@"T" intoString:nil];
        //check if the property is an instance of a class
        if ([scanner scanString:@"@\"" intoString: &propertyType]) {
            //read through the property protocols
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]intoString:&propertyType];
            while ([scanner scanString:@"<" intoString:NULL]) {
                NSString* protocolName = nil;
                [scanner scanUpToString:@">" intoString: &protocolName];
                if ([protocolName isEqualToString:@"ExpandProperty"]) {
                    isExpandProperty = YES;
                }else if ([protocolName isEqualToString:@"IgnoreParam"]){
                    isIgnoreProperty = YES;
                }else if ([protocolName isEqualToString:@"FileUploadParam"]){
                    isIgnoreProperty = YES;
                }
                [scanner scanString:@">" intoString:NULL];
            }
        }
        
        if (isIgnoreProperty) {
            continue;
        }
        
        NSString *propertyKey = nil;
        NSString *resultKey = propName;
        
        for (NSString *key in mapKeys.allKeys) {
            if ([key isEqualToString:propName]) {
                resultKey = mapKeys[key];
                break;
            }
        }
        
        if (isExpandProperty) {
            resultKey = nil;//Expandproperty不需要superkey
        }
        
        if (superKey.length > 0) {
            propertyKey = [NSString stringWithFormat:@"%@.%@",superKey,resultKey];
        }else{
            propertyKey = resultKey;
        }
        
        id value = [obj valueForKey:propName];
        if(value == nil){
            continue; //to next property
        }else{
            value = [self getObjectInternal:value superKey:propertyKey];//自定义处理数组，字典，其他类
        }
        if ([value isKindOfClass:[NSDictionary class]]) {
            [dic addEntriesFromDictionary:value];
        }else{
            [dic setObject:value forKey:propertyKey];
        }
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj superKey:(NSString *)superKey
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]){
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]){
        NSArray *objarr = obj;
        NSMutableDictionary *dic = @{}.mutableCopy;
        for(int i = 0;i < objarr.count; i++){
            NSString *key = [NSString stringWithFormat:@"%@[%@]",superKey,@(i)];
            [dic addEntriesFromDictionary:[self generateDicBySuperKey:key Object:[objarr objectAtIndex:i] mapKeys:nil]];
        }
        return dic;
    }
    
    if([obj isKindOfClass:[NSDictionary class]]){
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys){
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:[NSString stringWithFormat:@"%@.%@",superKey,key]];
        }
        return dic;
    }
    
    return [self generateDicBySuperKey:superKey Object:obj mapKeys:nil];
}

////////////////////////

@end
