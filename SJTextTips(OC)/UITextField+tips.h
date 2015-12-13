//
//  UITextField+tips.h
//  输入提示
//
//  Created by shmily on 15/9/4.
//  Copyright (c) 2015年 shmilyAshen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^mBlock)(NSString *key);


@interface UITextField (tips)<UITextFieldDelegate>

/// 是否匹配成功
@property(nonatomic,assign,readonly)NSValue *isMatched;

/// 匹配的数组
@property(nonatomic,strong)NSArray *matchArray;

/// 从第几位开始匹配(可选)
@property(nonatomic,assign)NSNumber *startMatch;

/// 匹配成功后的回调(可选)
@property(nonatomic,copy)mBlock finishedBlock;

/// 匹配失败后的回调(可选)
@property(nonatomic,copy)mBlock failedBlock;

/// 匹配结果
@property(nonatomic,copy)NSString *result;

@end
