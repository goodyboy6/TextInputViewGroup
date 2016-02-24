//
//  ViewController.swift
//  TextInputViewGroup
//
//  Created by yixiaoluo on 16/2/24.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: TIVTextView!
    @IBOutlet weak var textField: TIVTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textView.delegate = self;
        textView.placeHolderText = NSAttributedString(string: "请输入评论， 不超过20个字", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        textView.textView.backgroundColor = UIColor.grayColor()
        textView.tipLabel.backgroundColor = UIColor.orangeColor()
        
        
        textField.delegate = self
        textField.placeHolderText = NSAttributedString(string: "请输入评论， 不超过20个字", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: UIColor.whiteColor()])
        textField.textField.backgroundColor = UIColor.grayColor()
        textField.tipLabel.backgroundColor = UIColor.orangeColor()
        textField.tipLabel.font = UIFont.systemFontOfSize(8, weight: UIFontWeightLight)
        textField.tipLabelHeight = 10;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension ViewController:TIVTextFieldDelegate{
    func textField(didChanged textField: TIVTextField) -> (String, Bool) {
        let maxCount = self.maxAllowCharactersCount
        let currentTextCount = textField.currentText.characters.count
        
        let exccedCount = currentTextCount - maxCount;
        if exccedCount > 0{//excced the max
            return ("超过\(exccedCount)个文字", true)
        }else{
            return ("", false)
        }
    }
}


extension ViewController:TIVTextViewDelegate{
    
    var maxAllowCharactersCount:Int {
        get{
            return 20
        }
    }
    
    func textView(didBeginEditing textView:TIVTextView)
    {
        print("text view did begin editing")
    }
    
    func textView(didEndEditing textView:TIVTextView)
    {
        print("text view did end editing")
    }
    
    func textView(shouldEndEditing  textView:TIVTextView) -> Bool
    {
        return true
    }
    
    func textView(didChanged textView:TIVTextView) -> (String, Bool)
    {
        let maxCount = self.maxAllowCharactersCount
        let currentTextCount = textView.currentText.characters.count
        
        let exccedCount = currentTextCount - maxCount;
        if exccedCount > 0{//excced the max
            return ("超过\(exccedCount)个文字", true)
        }else{
            return ("", false)
        }
    }
}


