# TextInputView
开发的灵感来自于android的viewgroup类，从设计模式的角度来看，这是一个对象的适配器模式（可以理解为装饰(Decorator)模式/代理(Proxy)模式等），通过创建一个wrapper类持有UITextView/UITextField等的一个实例，实现被封装类的功能扩展。

##示例代码
<code><pre>
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: TIVTextView!
    @IBOutlet weak var textField: TIVTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textView.delegate = self;
        textView.placeHolderText = NSAttributedString(string: "请输入评论， 不超过20个字", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: UIColor.whiteColor()])
        textField.tipLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
        textField.tipLabelHeight = 18;

        textField.delegate = self
        textField.placeHolderText = NSAttributedString(string: "请输入评论， 不超过20个字", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(12), NSForegroundColorAttributeName: UIColor.whiteColor()])
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
    
    func textView(didBeginEditing textView:TIVTextView){
        print("text view did begin editing")
    }
    
    func textView(didEndEditing textView:TIVTextView){
        print("text view did end editing")
    }
    
    func textView(shouldEndEditing  textView:TIVTextView) -> Bool{
        return true
    }
    
    func textView(didChanged textView:TIVTextView) -> (String, Bool){
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
</pre></code>
