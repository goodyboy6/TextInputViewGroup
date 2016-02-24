//
//  TIVTextView.swift
//  TextInputViewGroup
//
//  Created by yixiaoluo on 16/2/24.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

import UIKit

protocol TIVTextViewDelegate : class{
    var maxAllowCharactersCount:Int {get}//max character count that allow
    
    func textView(didBeginEditing textView:TIVTextView)//text input did begin
    func textView(didEndEditing textView:TIVTextView)//text input did end
    
    func textView(shouldEndEditing  textView:TIVTextView) -> Bool//should end editing when user press the Reture key?
    func textView(didChanged textView:TIVTextView) -> (String, Bool)//the caller should offer the tip and whether exceeded the max character count. this method will be operate in a serial background queue, so, it will not block the main thread.
}

class TIVTextView: UIView {
    
    weak var delegate:TIVTextViewDelegate?
    let calQueue:dispatch_queue_t = dispatch_queue_create("com.alibaba.TIVTextView", DISPATCH_QUEUE_SERIAL)//text length calculate will be excute in this queue to avoid potential block in main thread

    //input status
    var isExceedThanMaxAllowCharactersCount:Bool = true
    var currentText:String{
        return self.textView.text
    }
    
    //place holder
    //tip: place holder font size perfers to be text view font size
    var placeHolderText:NSAttributedString?{
        didSet{
            self.placeHolderLabel.attributedText = placeHolderText
        }
    }
    
    //property about tip label
    let tipLabelHeight:CGFloat = 20.0
    private var tipLabelHeightConstraint:NSLayoutConstraint?
    
    //internal controls
    private(set) var textView:UITextView;
    private(set) var tipLabel:UILabel;
    private var placeHolderLabel:TIVLabel;

    override init(frame: CGRect) {
        //initialize property
        textView = UITextView(frame:CGRectMake(0, 0, frame.size.width, frame.size.height))
        tipLabel = UILabel(frame: CGRectMake(0, frame.size.height, frame.size.width, 0))
        placeHolderLabel = TIVLabel(frame: CGRectMake(4, 4, frame.size.width, 20))
        
        super.init(frame: frame)
        self.setupSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        //initialize property
        let frame = CGRectMake(0, 0, 20, 20);
        textView = UITextView(frame:CGRectMake(0, 0, frame.size.width, frame.size.height))
        tipLabel = UILabel(frame: CGRectMake(0, frame.size.height, frame.size.width, 0))
        placeHolderLabel = TIVLabel(frame: CGRectMake(4, 4, frame.size.width, 20))
        
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupSubViews()
    }

    private func setupSubViews()
    {
        //config subview
        textView.delegate = self;
        textView.textColor = UIColor.blackColor();
        
        tipLabel.textColor = UIColor.redColor()
        tipLabel.textAlignment = NSTextAlignment.Right
        tipLabel.font = UIFont.systemFontOfSize(12, weight: UIFontWeightLight)
        
        self.addSubview(textView)
        self.addSubview(tipLabel)
        self.addSubview(placeHolderLabel)
        
        
        //add constraint 
        textView.translatesAutoresizingMaskIntoConstraints = false;
        tipLabel.translatesAutoresizingMaskIntoConstraints = false;
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        //config textView
        self.addConstraint(NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: textView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tipLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))

        //config tipLabel
        self.addConstraint(NSLayoutConstraint(item: tipLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: tipLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: tipLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        tipLabelHeightConstraint = NSLayoutConstraint(item: tipLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0);
        self.addConstraint(tipLabelHeightConstraint!)

        //config placeHolderLabel
        self.addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 4))
        self.addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 4))
        self.addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 4))
        self.addConstraint(NSLayoutConstraint(item: placeHolderLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 20))
    }
}

extension TIVTextView: UITextViewDelegate{
    
    //UITextViewDelegate
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            if let temp = self.delegate{
                return temp.textView(shouldEndEditing: self)
            }
        }
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if let temp = self.delegate{
            return  temp.textView(didBeginEditing: self)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if let temp = self.delegate{
            temp.textView(didEndEditing: self)
        }
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        if let temp = self.delegate{
            return temp.textView(shouldEndEditing: self)
        }
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        dispatch_async(calQueue) {[weak self] () -> Void in
            
            if let weakSelf = self, temp = weakSelf.delegate{
                
                let info:(tip:String, isMore:Bool) = temp.textView(didChanged: weakSelf)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    weakSelf.isExceedThanMaxAllowCharactersCount = info.isMore

                    if weakSelf.isExceedThanMaxAllowCharactersCount{
                        weakSelf.tipLabelHeightConstraint?.constant = 20;
                        weakSelf.needsUpdateConstraints()
                        
                        weakSelf.tipLabel.hidden = false;
                        weakSelf.tipLabel.text = info.tip;
                    }else{
                        weakSelf.tipLabelHeightConstraint?.constant = 0;
                        weakSelf.needsUpdateConstraints()
                        
                        weakSelf.tipLabel.hidden = true;
                    }
                    
                    weakSelf.placeHolderLabel.hidden = weakSelf.currentText.characters.count != 0
                })
            }
        }
    }
}
