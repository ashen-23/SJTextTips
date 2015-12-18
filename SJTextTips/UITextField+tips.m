//
//  UITextField+tips.m
//  输入提示
//
//  Created by shmily on 15/9/4.
//  Copyright (c) 2015年 shmilyAshen. All rights reserved.
//

#import "UITextField+tips.h"
#import <objc/runtime.h>

typedef enum {
    /// 成功的回调
    callbackFinished,
    /// 失败的回调
    callbackFailed
}callbackType;

@implementation UITextField (tips)

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {//删除不执行任何操作
        [self callback:callbackFailed str:@""]; // 执行错误回调
        return YES;
    }
    
    if ([string isEqualToString:@"\n"])
    {
        if (self.returnKey)
        {
            self.returnKey();
            return YES;
        }
    }
    
    NSMutableString *text = [[NSMutableString alloc]initWithCapacity:0];
    [text appendString:textField.text];
    [text deleteCharactersInRange:range];//在选中的位置 插入string
    [text insertString:string atIndex:range.location];
    //断言,防止未设置数组
    NSAssert(self.matchArray, @"必须设置文本框的matchArray 属性");
    
    int startMatch = self.startMatch ? [self.startMatch intValue] : 0;
    if (text.length>startMatch) { // 限制从1个以上才开始匹配  根据需求 自己设定
        NSString *behind = [self matchString:text]; //匹配是否有开头相同的
        if (behind) {
            [text appendString:behind];
            textField.text = text;
            UITextPosition *endDocument = textField.endOfDocument;//获取 text的 尾部的 TextPositext
            //选取尾部补全的String
            UITextPosition *end = [textField positionFromPosition:endDocument offset:0];
            UITextPosition *start = [textField positionFromPosition:end offset:-behind.length];//左－右＋
            textField.selectedTextRange = [textField textRangeFromPosition:start toPosition:end];
            [self callback:callbackFinished str:text]; // 回调
            return NO;
        }else{
            [self callback:callbackFailed str:text]; // 执行回调
            return YES;
        }
    }
    return YES;
}

/// 执行回调方法
- (void)callback:(callbackType)type str:(NSString *)str{
    if (type ==callbackFinished) {
        self.isMatched = @TRUE; // 设置匹配状态
        if (self.finished) {
            self.finished(str); //执行回调
        }
    }else {
        self.isMatched = @FALSE;
        if (self.failed)
        {
            self.failed(str); //执行回调
        }
    }
}

//匹配算法
-(NSString *)matchString:(NSString *)head{
    for (int i = 0; i<[self.matchArray count]; i++) {
        NSString *string = self.matchArray[i];
        if ([string hasPrefix:head]) {
            self.result = string; // 设置结果
            return  [string substringFromIndex:head.length];
        }
    }
    self.result = nil;
    return nil;
}

// 其它代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.beginEdit)
    {
        self.beginEdit();
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.endEdit)
    {
        self.endEdit();
    }
}

#pragma mark- 运行时添加属性
//匹配数组
- (NSArray *)matchArray {
    return objc_getAssociatedObject(self, @selector(matchArray));
    
}
- (void)setMatchArray:(NSArray *)matchArray {
    self.delegate = self;
    
    objc_setAssociatedObject(self, @selector(matchArray), matchArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//开始匹配的位置
- (NSNumber *)startMatch {
    return objc_getAssociatedObject(self, @selector(startMatch));
}
- (void)setStartMatch:(NSNumber *)startMatch {
    objc_setAssociatedObject(self, @selector(startMatch), startMatch, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//成功回调
- (block)finished {
    return objc_getAssociatedObject(self, @selector(finished));
}
- (void)setFinished:(block)finished {
    objc_setAssociatedObject(self, @selector(finished), finished, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
//失败的回调
- (block)failed {
    return objc_getAssociatedObject(self, @selector(failed));
}
- (void)setFailed:(block)failed {
    objc_setAssociatedObject(self, @selector(failed), failed, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

// 回车的回调
- (void (^)())returnKey
{
    return objc_getAssociatedObject(self, @selector(returnKey));
}

- (void)setReturnKey:(void (^)())returnKey
{
    objc_setAssociatedObject(self, @selector(returnKey), returnKey, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSValue *)isMatched {
    return objc_getAssociatedObject(self, @selector(isMatched));
}
- (void)setIsMatched:(NSValue *)isMatched {
    objc_setAssociatedObject(self, @selector(isMatched), isMatched, OBJC_ASSOCIATION_ASSIGN);
}
//匹配结果
- (NSString *)result {
    return objc_getAssociatedObject(self, @selector(result));
}
- (void)setResult:(NSString *)result {
    objc_setAssociatedObject(self, @selector(result), result, OBJC_ASSOCIATION_ASSIGN);
}

- (void (^)())beginEdit
{
    return objc_getAssociatedObject(self, @selector(beginEdit));
}

- (void)setBeginEdit:(void (^)())beginEdit
{
    objc_setAssociatedObject(self, @selector(beginEdit), beginEdit, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())endEdit
{
    return objc_getAssociatedObject(self, @selector(endEdit));
}

- (void)setEndEdit:(void (^)())endEdit
{
    objc_setAssociatedObject(self, @selector(endEdit), endEdit, OBJC_ASSOCIATION_COPY_NONATOMIC);
}



@end
