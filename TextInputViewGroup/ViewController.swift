//
//  ViewController.swift
//  TextInputViewGroup
//
//  Created by yixiaoluo on 16/2/24.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let textView:TIVTextView = TIVTextView(frame: CGRectMake(100, 100, 200, 200), _delegate: self)
        textView.backgroundColor = UIColor.brownColor()
        textView.placeHolderText = NSAttributedString(string: "请输入评论， 不超过20个字", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        textView.textView.backgroundColor = UIColor.grayColor()
        textView.tipLabel.backgroundColor = UIColor.orangeColor()

        self.view.addSubview(textView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController:TIVTextViewDelegate{
    
    var maxAllowCharactersCount:Int {
        get{
            return 20
        }
    }//允许输入字符的最大个数
    
    func textView(didBeginEditing textView:TIVTextView)//开始输入
    {
        print("text view did begin editing")
    }
    
    func textView(didEndEditing textView:TIVTextView)//结束输入
    {
        print("text view did end editing")
    }
    
    func textView(shouldEndEditing  textView:TIVTextView) -> Bool//键盘是否该收起
    {
        return true
    }
    
    func textView(didChanged textView:TIVTextView) -> (String, Bool)//文字发生变化时，调用方返回提示文字及当前文字个数。此方法被放入了子线程调用，调用方不用担心主线程被卡顿
    {
        let maxCount = self.maxAllowCharactersCount
        let currentTextCount = textView.currentText.characters.count
        
        let moreCount = currentTextCount - maxCount;
        if moreCount > 0{//超过字符限制
            return ("超过\(moreCount)个文字", true)
        }else{
            return ("", false)
        }
    }
}


