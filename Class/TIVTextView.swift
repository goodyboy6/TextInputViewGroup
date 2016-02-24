//
//  TIVTextView.swift
//  TextInputViewGroup
//
//  Created by yixiaoluo on 16/2/24.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

import UIKit

protocol TIVTextViewDelegate : class{
    var maxAllowCharactersCount:Int {get}//允许输入字符的最大个数
    
    func textView(didBeginEditing textView:TIVTextView)//开始输入
    func textView(didEndEditing textView:TIVTextView)//结束输入
    
    func textView(shouldEndEditing  textView:TIVTextView) -> Bool//键盘是否该收起
    func textView(didChanged textView:TIVTextView) -> (String, Bool)//文字发生变化时，调用方返回提示文字及是否超过文字个数限制。此方法被放入了子线程调用，调用方不用担心主线程被卡顿
}

class TIVTextView: UIView {
    
    unowned var delegate:TIVTextViewDelegate
    let calQueue:dispatch_queue_t = dispatch_queue_create("com.alibaba.TIVTextView", DISPATCH_QUEUE_SERIAL)

    //输入状态
    var isMoreThanMaxAllowCharactersCount:Bool = true//当前状态是否超过了最大个数
    var currentText:String{
        return self.textView.text
    }
    
    //place holder
    //tip: place holder文字大小最好和输入框内文字的大小相同
    var placeHolderText:NSAttributedString?{
        didSet{
            self.placeHolderLabel.attributedText = placeHolderText
        }
    }
    
    //提示文字属性
    let tipLabelHeight:CGFloat = 20.0

    //内部控件
    private(set) var textView:UITextView;
    private(set) var tipLabel:UILabel;
    private var placeHolderLabel:TIVLabel;

    init(frame: CGRect, _delegate:TIVTextViewDelegate) {
        //初始化
        delegate = _delegate;
        textView = UITextView(frame:CGRectMake(0, 0, frame.size.width, frame.size.height))
        tipLabel = UILabel(frame: CGRectMake(0, frame.size.height, frame.size.width, 0))
        placeHolderLabel = TIVLabel(frame: CGRectMake(4, 4, frame.size.width, 20))
        
        super.init(frame: frame)
        
        //配置子页面信息
        textView.delegate = self;
        textView.textColor = UIColor.blackColor();
        
        tipLabel.textColor = UIColor.redColor()
        tipLabel.textAlignment = NSTextAlignment.Right
        tipLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
        
        self.addSubview(textView)
        self.addSubview(tipLabel)
        self.addSubview(placeHolderLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TIVTextView: UITextViewDelegate{
    
    //UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.delegate.textView(didBeginEditing: self)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.delegate.textView(didEndEditing: self)
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        return self.delegate.textView(shouldEndEditing: self)
    }
    
    func textViewDidChange(textView: UITextView) {
        dispatch_async(calQueue) {[weak self] () -> Void in
            
            if let weakSelf = self{
                
                let info:(tip:String, isMore:Bool) = weakSelf.delegate.textView(didChanged: weakSelf)
                weakSelf.isMoreThanMaxAllowCharactersCount = info.isMore
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let width = weakSelf.frame.size.width
                    let height = weakSelf.frame.size.height
                    
                    if weakSelf.isMoreThanMaxAllowCharactersCount{
                        weakSelf.textView.frame = CGRectMake(0, 0, width, height - weakSelf.tipLabelHeight)
                        weakSelf.tipLabel.frame = CGRectMake(0, height - weakSelf.tipLabelHeight, width, weakSelf.tipLabelHeight)
                        weakSelf.tipLabel.hidden = false;
                        weakSelf.tipLabel.text = info.tip;
                    }else{
                        weakSelf.textView.frame = CGRectMake(0, 0, width, height)
                        weakSelf.tipLabel.hidden = true;
                    }
                    
                    weakSelf.placeHolderLabel.hidden = weakSelf.currentText.characters.count != 0
                })
            }
        }
    }
}
