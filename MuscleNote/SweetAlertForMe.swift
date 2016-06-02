// CustomAlertのModuleであるSweetAlertを継承したMuscleNote専用のAlertクラス

//
//  SweetAlertForMe.swift
//  MuscleNote
//
//  Created by 大森　亮佑 on 2016/05/18.
//  Copyright © 2016年 RyosukeOmori. All rights reserved.
//

import Foundation
import UIKit

enum TextFieldType {
    case name
    case weight
    case leps
}



//================================================================================================
// stringの拡張                                                ＊使わんかった
// 全角だったら半角に、半角だったら全角にする
// 参考URL: http://qiita.com/su_k/items/1dd6c9381bdd39c6cb64
extension String {
    private func convertFullWidthToHalfWidth(reverse: Bool) -> String {
        let str = NSMutableString(string: self) as CFMutableString
        CFStringTransform(str, nil, kCFStringTransformFullwidthHalfwidth, reverse)
        return str as String
    }
    
    var hankaku: String {
        return convertFullWidthToHalfWidth(false)
    }
    
    var zenkaku: String {
        return convertFullWidthToHalfWidth(true)
    }
}



//===============================================================================================
class SweetAlertForMe: SweetAlert {
    
    //textFieldを追加(original)
    var nameTextField: UITextField = UITextField()
    var weightTextField: UITextField = UITextField()
    var lepsTextField: UITextField = UITextField()
    let weightLabel: UILabel = UILabel()
    let lepsLabel: UILabel = UILabel()
    
    var registTextFieldFlag: Bool = false
    var updateTextFieldFlag: Bool = false
    let textFieldHeight: CGFloat = 30.0
    let textFieldBorderColor: CGColor = UIColor.blackColor().CGColor
    
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented in SweetAlertForMe.")
    }
    
    //textFieldを設定(original)
    private func setupTextField() {
        //nameTextField
        nameTextField.delegate = self
        nameTextField.returnKeyType = UIReturnKeyType.Done
        nameTextField.keyboardType = UIKeyboardType.ASCIICapable
        nameTextField.borderStyle = UITextBorderStyle.RoundedRect
        nameTextField.layer.borderColor = UIColor.blackColor().CGColor
        nameTextField.tag = TextFieldType.name.hashValue
        nameTextField.placeholder = "Name"
        if updateTextFieldFlag {
            nameTextField.text = app.userSelected
            print("nameTextFieldに入りました!!!: \(app.userSelected)")
        }
        
        //weightTextField
        weightTextField.delegate = self
        weightTextField.returnKeyType = UIReturnKeyType.Done                    //returnKeyに表示される文字を設定
        weightTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation     //キーボードを数字に設定
        weightTextField.borderStyle = UITextBorderStyle.RoundedRect
        weightTextField.layer.borderColor = UIColor.blackColor().CGColor
        weightTextField.tag = TextFieldType.weight.hashValue                    //0
        
        //weightTextFieldの後のLabel
        weightLabel.text = "kg ✖︎ "
        weightLabel.numberOfLines = 1
        weightLabel.textAlignment = NSTextAlignment.Center
        weightLabel.font = UIFont(name: kFont, size: 16)
        weightLabel.textColor = UIColor.colorFromRGB(0x797979)
        
        //lepsTextField
        lepsTextField.delegate = self
        lepsTextField.returnKeyType = UIReturnKeyType.Done                      //returnKeyに表示される文字を設定
        lepsTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation       //キーボードを数字に設定
        lepsTextField.borderStyle = UITextBorderStyle.RoundedRect
        lepsTextField.layer.borderColor = UIColor.blackColor().CGColor
        lepsTextField.tag = TextFieldType.leps.hashValue                        //1
        
        //weightTextFieldの後のLabel
        lepsLabel.text = "leps"
        lepsLabel.numberOfLines = 1
        lepsLabel.textAlignment = NSTextAlignment.Center
        lepsLabel.font = UIFont(name: kFont, size: 16)
        lepsLabel.textColor = UIColor.colorFromRGB(0x797979)
        
    }
    
    // MustleNoteのtextFieldを追加するためのshowAlert(登録用)
    func showAlert(title: String, subTitle: String?, style: AlertStyle, buttonTitle: String, buttonColor: UIColor, otherButtonTitle: String?, otherButtonColor: UIColor?, useRegistMustle: Bool, action: ((isOtherButton: Bool) -> Void)? = nil) -> SweetAlertForMe {
        registTextFieldFlag = useRegistMustle
        self.setupTextField()
        self.showAlert(title, subTitle: subTitle, style: style, buttonTitle: buttonTitle,buttonColor: buttonColor,otherButtonTitle:
            otherButtonTitle,otherButtonColor: UIColor.redColor())
        userAction = action
        return self
    }
    
    // MustleNoteのtextFieldを追加するためのshowAlert(更新用)
    func showAlert(title: String, subTitle: String?, style: AlertStyle, buttonTitle: String, buttonColor: UIColor, otherButtonTitle: String?, otherButtonColor: UIColor?, useUpdateMustle: Bool, action: ((isOtherButton: Bool) -> Void)? = nil) -> SweetAlertForMe {
        updateTextFieldFlag = useUpdateMustle
        self.setupTextField()
        self.showAlert(title, subTitle: subTitle, style: style, buttonTitle: buttonTitle,buttonColor: buttonColor,otherButtonTitle:
            otherButtonTitle,otherButtonColor: UIColor.redColor())
        userAction = action
        return self
    }
    
    
    //override---------------------------------------------------------------------------------------
    override func resizeAndRelayout() {
        let mainScreenBounds = UIScreen.mainScreen().bounds
        self.view.frame.size = mainScreenBounds.size
        let x: CGFloat = kWidthMargin
        var y: CGFloat = KTopMargin
        let width: CGFloat = kContentWidth - (kWidthMargin*2)
        
        if animatedView != nil {
            animatedView!.frame = CGRect(x: (kContentWidth - kAnimatedViewHeight) / 2.0, y: y, width: kAnimatedViewHeight, height: kAnimatedViewHeight)
            contentView.addSubview(animatedView!)
            y += kAnimatedViewHeight + kHeightMargin
        }
        
        if imageView != nil {
            imageView!.frame = CGRect(x: (kContentWidth - kAnimatedViewHeight) / 2.0, y: y, width: kAnimatedViewHeight, height: kAnimatedViewHeight)
            contentView.addSubview(imageView!)
            y += imageView!.frame.size.height + kHeightMargin
        }
        
        // Title
        if self.titleLabel.text != nil {
            titleLabel.frame = CGRect(x: x, y: y, width: width, height: kTitleHeight)
            contentView.addSubview(titleLabel)
            y += kTitleHeight + kHeightMargin
        }
        
        // Subtitle
        if self.subTitleTextView.text.isEmpty == false {
            let subtitleString = subTitleTextView.text! as NSString
            let rect = subtitleString.boundingRectWithSize(CGSize(width: width, height: 0.0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:subTitleTextView.font!], context: nil)
            textViewHeight = ceil(rect.size.height) + 10.0
            subTitleTextView.frame = CGRect(x: x, y: y, width: width, height: textViewHeight)
            contentView.addSubview(subTitleTextView)
            y += textViewHeight + kHeightMargin
        }
        
        // Status TextField (original)
        if self.registTextFieldFlag || self.updateTextFieldFlag {
            // name
            nameTextField.frame = CGRect(x: x*2, y: y, width: width-x*4, height: textFieldHeight)
            contentView.addSubview(nameTextField)
            y += textFieldHeight + kHeightMargin
            
            // status
            weightTextField.frame = CGRect(x: x, y: y, width: width/4, height: textFieldHeight)
            weightLabel.frame = CGRect(x: weightTextField.frame.maxX, y: y, width: width/4, height: textFieldHeight)
            lepsTextField.frame = CGRect(x: weightLabel.frame.maxX, y: y, width: width/4, height: textFieldHeight)
            lepsLabel.frame = CGRect(x: lepsTextField.frame.maxX, y: y, width: width/4, height: textFieldHeight)
            contentView.addSubview(weightTextField)
            contentView.addSubview(weightLabel)
            contentView.addSubview(lepsTextField)
            contentView.addSubview(lepsLabel)
            y += textFieldHeight + kHeightMargin
        }
        
        var buttonRect:[CGRect] = []
        for button in buttons {
            let string = button.titleForState(UIControlState.Normal)! as NSString
            buttonRect.append(string.boundingRectWithSize(CGSize(width: width, height:0.0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes:[NSFontAttributeName:button.titleLabel!.font], context:nil))
        }
        
        var totalWidth: CGFloat = 0.0
        if buttons.count == 2 {
            totalWidth = buttonRect[0].size.width + buttonRect[1].size.width + kWidthMargin + 40.0
        }
        else{
            totalWidth = buttonRect[0].size.width + 20.0
        }
        y += kHeightMargin
        var buttonX = (kContentWidth - totalWidth ) / 2.0
        for i in 0 ..< buttons.count {
            
            buttons[i].frame = CGRect(x: buttonX, y: y, width: buttonRect[i].size.width + 20.0, height: buttonRect[i].size.height + 10.0)
            buttonX = buttons[i].frame.origin.x + kWidthMargin + buttonRect[i].size.width + 20.0
            buttons[i].layer.cornerRadius = 5.0
            self.contentView.addSubview(buttons[i])
            buttons[i].addTarget(self, action: #selector(SweetAlert.pressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        y += kHeightMargin + buttonRect[0].size.height + 10.0
        if y > kMaxHeight {
            let diff = y - kMaxHeight
            let sFrame = subTitleTextView.frame
            subTitleTextView.frame = CGRect(x: sFrame.origin.x, y: sFrame.origin.y, width: sFrame.width, height: sFrame.height - diff)
            
            for button in buttons {
                let bFrame = button.frame
                button.frame = CGRect(x: bFrame.origin.x, y: bFrame.origin.y - diff, width: bFrame.width, height: bFrame.height)
            }
            
            y = kMaxHeight
        }
        
        contentView.frame = CGRect(x: (mainScreenBounds.size.width - kContentWidth) / 2.0, y: (mainScreenBounds.size.height - y) / 2.0, width: kContentWidth, height: y)
        contentView.clipsToBounds = true
        
        print("contentView.frame.width : \(contentView.frame.width)")
        print("contentView.frame.height : \(contentView.frame.height)")
    }
    
    override func pressed(sender: UIButton!) {
        print("Called 'pressed()' in MustleNote!!!")
        
        //weightTextFieldのtextチェック
        if weightTextField.text?.characters.count != 0 {
            let wStr: String = weightTextField.text!
            let wPattern = "\\d+\\.\\d+"
            if Regexp(wPattern).isMatch(wStr) {
                print("weightTextField is OK!!!")
            } else {
                print("weightTextField is NO!!!!")
            }
        }
        
        //lepsTextFieldのtextチェック
        if lepsTextField.text?.characters.count != 0 {
            let lStr: String = lepsTextField.text!
            let lPattern = "\\d+"
            if Regexp(lPattern).isMatch(lStr) {
                print("lepsTextField is OK!!!")
            } else {
                print("lepsTextField is NO!!!!")
            }
        }
        
        super.pressed(sender)
    }
    
    
    //delegate: textField------------------------------------------------------------------
    //returnが押された際の処理
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField.tag {
        case weightTextField.tag.hashValue:
            weightTextField.resignFirstResponder()      //weightTextFieldのキーボードを閉じる   ＊endEdidtingでも可
            break
        case lepsTextField.tag.hashValue:
            lepsTextField.resignFirstResponder()
            break
        default:
            break
        }
        return true                                 //trueだとDidEndOnExitイベントが発生、それが実装されていればさらにEditingDidEndイベントが発生する。
    }
    
    //1文字でも入力されたら呼び出される       ＊今回は数字だけだから良いが、日本語等の変換を含む入力にはきちんとした処理をしてくれないため非推奨
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //文字数制限をする
        switch textField.tag {
        case TextFieldType.name.hashValue:
            let maxInputLength: Int = 21
            let str = textField.text! + string
            
            if str.characters.count < maxInputLength {
                return true
            }
            print("20文字を超えています")
            break
        case TextFieldType.weight.hashValue:
            let maxInputLength: Int = 7
            let str = textField.text! + string              //入力済みの文字と入力された文字を合わせて取得
            
            if str.characters.count < maxInputLength {
                return true
            }
            print("6文字を超えています")
            break
        case TextFieldType.leps.hashValue:
            let maxInputLength: Int = 3;
            let str = textField.text! + string
            let num = Int(str)
            
            if num < 11 && num > 0 {                                   //入力された値が11以上だとreject
                if str.characters.count < maxInputLength {
                    return true
                }
            }
            print("2文字を超えています")
            break
        default:
            break;
        }
        return false
    }
    
}




//=================================================================================================
// 文字列検索クラス
// 参考URL: http://qiita.com/coa00@github/items/ae9c38dc92f3626dcd19
class Regexp {
    let internalRegexp: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.internalRegexp = try! NSRegularExpression( pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
    }
    
    func isMatch(input: String) -> Bool {
        let matches = self.internalRegexp.matchesInString( input, options: [], range:NSMakeRange(0, input.characters.count) )
        return matches.count > 0
    }
    
    func matches(input: String) -> [String]? {
        if self.isMatch(input) {
            let matches = self.internalRegexp.matchesInString( input, options: [], range:NSMakeRange(0, input.characters.count) )
            var results: [String] = []
            for i in 0 ..< matches.count {
                results.append( (input as NSString).substringWithRange(matches[i].range) )
            }
            return results
        }
        return nil
    }
    
}



