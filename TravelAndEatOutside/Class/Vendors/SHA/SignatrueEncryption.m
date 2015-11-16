//
//  SignatrueEncryption.m
//  Tuantuangou
//
//  Created by Duke on 13-6-3.
//  Copyright (c) 2013年 Duke. All rights reserved.
//

#import "SignatrueEncryption.h"
#import <CommonCrypto/CommonDigest.h>
#import "CommonDefine.h"

@implementation SignatrueEncryption

+ (NSMutableDictionary *)encryptedParamsWithBaseParams:(NSMutableDictionary *)paramsDictionary
{
    NSMutableString *signatrueString = [NSMutableString stringWithString:kAPP_KEY];
//    NSMutableString *paramsString = [NSMutableString stringWithFormat:@"appkey=%@", kAPP_KEY];
    //将参数字典排序
    NSArray *sortedParamsDictionaryKeys = [[paramsDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *oneKey in sortedParamsDictionaryKeys) {
        [signatrueString appendFormat:@"%@%@", oneKey, [paramsDictionary objectForKey:oneKey]];
    }
    //将secret串拼接在末尾 747364472category火锅city北京has_coupon1limit20region海淀区sort25257689458624870a3f25fb2f742b37c
    
    /////////////////////747364472category火锅city北京has_coupon1limit20region海淀区sort25257689458624870a3f25fb2f742b37c
    [signatrueString appendString:kAPP_SECRET];
// 转换为utf_8
    [signatrueString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:signatrueString]];
//    [signatrueString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //进行SHA-1加密计算
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *signatrueBytes = [signatrueString dataUsingEncoding:NSUTF8StringEncoding];
    if (CC_SHA1([signatrueBytes bytes], (int)[signatrueBytes length], digest)) {
        NSMutableString *digestedString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
            unsigned char signleCharacter = digest[i];
            //转成16进制的字符串，注意格式%02X，X 表示以十六进制形式输出 02 表示不足两位,前面补0输出
            [digestedString appendFormat:@"%02X", signleCharacter];
        }
        //045018701D3E341C38C4BC703495C1F031594FBB
        NSMutableDictionary *newParamsDictionary = [NSMutableDictionary dictionaryWithDictionary:paramsDictionary];
        [newParamsDictionary setObject:digestedString forKey:@"sign"];
        return newParamsDictionary;
    } else {
        return nil;
    }
}

@end
