//
//  TIVLabel.swift
//  TextInputViewGroup
//
//  Created by yixiaoluo on 16/2/24.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

import UIKit

class TIVLabel: UILabel {

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        print("TIVLabel did tapped")
        return nil;
    }
}
