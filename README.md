# TextInputView
开发的灵感来自于android的viewgroup类，从设计模式的角度来看，这是一个对象的适配器模式（可以理解为装饰(Decorator)模式/代理(Proxy)模式等），通过创建一个wrapper类持有UITextView/UITextField等的一个实例，实现被封装类的功能扩展。
