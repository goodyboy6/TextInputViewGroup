# TextInputViewGroup

The idea is derived from the view group of Android.  An instance UITextView/UITextField is wrapped by TextInputViewGroup, which is Decorator Pattern or Proxy Pattern from the perspective of design patterns.  


#CocoaPods install
pod 'TextInputViewGroup', '~> 1.0.3'   support iOS>=8.0

##code demo
you can init it [initWithFrame:] , certainly, from storyboard is OK. The following code demo is from storyboard. 
<code>
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
</code>
