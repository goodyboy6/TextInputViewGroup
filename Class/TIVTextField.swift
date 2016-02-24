//
//  TIVTextField.swift
//  TextInputViewGroup
//
//  Created by yixiaoluo on 16/2/24.
//  Copyright © 2016年 alibaba.com. All rights reserved.
//

import UIKit

protocol TIVTextFieldDelegate : class{
    func textField(didChanged textField:TIVTextField) -> (String, Bool)//the caller should offer the tip and whether exceeded the max character count. this method will be operate in a serial background queue, so, it will not block the main thread.
}


class TIVTextField: UIView {

    weak var delegate:TIVTextFieldDelegate?
    
    let calQueue:dispatch_queue_t = dispatch_queue_create("com.alibaba.TIVTextField", DISPATCH_QUEUE_SERIAL)//text length calculate will be excute in this queue to avoid potential block in main thread

    //internal controls
    private(set) var textField:UITextField;
    private(set) var tipLabel:UILabel;

    //property about tip label
    var tipLabelHeight:CGFloat = 20.0//you can custom tip label height
    private var tipLabelHeightConstraint:NSLayoutConstraint?

    //input status
    var isExceedThanMaxAllowCharactersCount:Bool = true
    var currentText:String{
        return self.textField.text ?? ""
    }
    
    //place holder
    //tip: place holder font size perfers to be text view font size
    var placeHolderText:NSAttributedString?{
        didSet{
            self.textField.attributedPlaceholder = placeHolderText
        }
    }
    
    override init(frame: CGRect) {
        textField = UITextField(frame:CGRectMake(0, 0, frame.size.width, frame.size.height))
        tipLabel = UILabel(frame: CGRectMake(0, frame.size.height, frame.size.width, 0))

        super.init(frame: frame)
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //initialize property
        let frame = CGRectMake(0, 0, 20, 20);
        textField = UITextField(frame:CGRectMake(0, 0, frame.size.width, frame.size.height))
        tipLabel = UILabel(frame: CGRectMake(0, frame.size.height, frame.size.width, 0))

        super.init(coder: aDecoder)
    }

    override func awakeFromNib(){
        super.awakeFromNib()
        self.setupSubViews()
    }
    
    func textFieldDidChanged(sender:UITextField){
        dispatch_async(calQueue) {[weak self] () -> Void in

            if let weakSelf = self, temp = weakSelf.delegate{
                
                let info:(tip:String, isMore:Bool) = temp.textField(didChanged: weakSelf)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    weakSelf.isExceedThanMaxAllowCharactersCount = info.isMore
                    
                    if weakSelf.isExceedThanMaxAllowCharactersCount{
                        weakSelf.tipLabelHeightConstraint?.constant = weakSelf.tipLabelHeight;
                        weakSelf.needsUpdateConstraints()
                        
                        weakSelf.tipLabel.hidden = false;
                        weakSelf.tipLabel.text = info.tip;
                    }else{
                        weakSelf.tipLabelHeightConstraint?.constant = 0;
                        weakSelf.needsUpdateConstraints()
                        
                        weakSelf.tipLabel.hidden = true;
                    }
                })
            }
        }
    }
    
    private func setupSubViews()
    {
        //config subview
        textField.textColor = UIColor.blackColor();
        textField.addTarget(self, action: Selector("textFieldDidChanged:"), forControlEvents: UIControlEvents.EditingChanged)
        
        tipLabel.textColor = UIColor.redColor()
        tipLabel.textAlignment = NSTextAlignment.Right
        tipLabel.font = UIFont.systemFontOfSize(12)
        
        self.addSubview(textField)
        self.addSubview(tipLabel)
        
        
        //add constraint
        textField.translatesAutoresizingMaskIntoConstraints = false;
        tipLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        //config textView
        self.addConstraint(NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: textField, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.tipLabel, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        
        //config tipLabel
        self.addConstraint(NSLayoutConstraint(item: tipLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: tipLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: tipLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        tipLabelHeightConstraint = NSLayoutConstraint(item: tipLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0);
        self.addConstraint(tipLabelHeightConstraint!)        
    }

}