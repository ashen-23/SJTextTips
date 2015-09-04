#SJTextTips
#### **根据本地保存数据自动填充文本框**

![TextTips.gif](./TextTips.gif)

##如何使用SJTextTips
#### 1.导入头文件 
	#import "UITextField+tips.h"
#### 2.设置代理（设置代理为文本框自己本身）
	textFiled.delegate = textField;
#### 3.设置匹配内容
	textFiled.matchArray = @[@"515783034",@"982042662",@"965917768"];

#### 4.其它可选设置项（==可选==）
	//设置开始匹配的位置
    textFiled.startMatch = @1;
#### 5.如果该项目用于输入用户的账户和密码，需要实现以下回调
   //设置成功的回调（匹配成功后，填充密码）
   
       _txtInput.finished = ^() {
        _txtPwd.text = @"账号匹配,自动导入密码";
    };
   //设置失败的回调（匹配失败后，删除密码框的内容）
  
       _txtInput.failed = ^() {
        _txtPwd.text = @"账号不匹配,清空密码";
    };