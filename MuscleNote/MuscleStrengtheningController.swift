//
//  MuscleHypertrophyController.swift
//  MuscleNote
//
//  Created by 大森　亮佑 on 2016/06/02.
//  Copyright © 2016年 RyosukeOmori. All rights reserved.
//

import Foundation
import UIKit

class MuscleStrengtheningController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let per100Label: UILabel = UILabel()
    let per90Label: UILabel = UILabel()
    let per90Label2: UILabel = UILabel()
    let per85Label: UILabel = UILabel()
    let per85Label2: UILabel = UILabel()
    let per80Label: UILabel = UILabel()
    let per80Label2: UILabel = UILabel()
    
    var labelSize: CGSize!
    let labelFontFamily: String = "AoyagiKouzanFontTOTF"
    let labelImageView: UIImage = UIImage(named: "muscleNoteTrainigMenu")!
    let labelBackGroundImageAsUIColor: UIColor = UIColor(patternImage: UIImage(named: "muscleNoteTrainigMenu")!)
    
    let muscleSkinImageView: UIImageView = UIImageView()
    let muscleShadowImageView: UIImageView = UIImageView()

    let maxX: CGFloat = UIScreen.mainScreen().bounds.size.width
    let maxY: CGFloat = UIScreen.mainScreen().bounds.size.height
    
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelSize = CGSize(width: maxX/2-40, height: maxY/12)
        
        setupLabel()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //登録画面に遷移する際にnavigationControllerBarを表示
        //        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.015, green: 0.002, blue: 0, alpha: 0.2)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        setupMuscleImageView()
        setupAnimation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        //トップに戻る際にnavigationControllerBarを非表示
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    //original-------------------------------------------------------------------------------------------------------------------
    //左下にアニメーション表示する男の画像を設定
    func setupMuscleImageView() {
        muscleSkinImageView.image = UIImage(named: "muscleSkin")
        muscleSkinImageView.contentMode = UIViewContentMode.ScaleAspectFit
        muscleSkinImageView.frame.size = CGSize(width: maxX/3, height: maxX/3)
        muscleSkinImageView.layer.position = CGPoint(x: 0, y: maxY - muscleSkinImageView.frame.height/2)
        muscleSkinImageView.alpha = 0.9
        self.view.addSubview(muscleSkinImageView)
        
        muscleShadowImageView.image = UIImage(named: "muscleNoteShadow")
        muscleShadowImageView.contentMode = UIViewContentMode.ScaleAspectFit
        muscleShadowImageView.frame.size = CGSize(width: maxX/3, height: maxX/3)
        muscleShadowImageView.layer.position = CGPoint(x: maxX, y: muscleShadowImageView.frame.height/2)
        muscleShadowImageView.alpha = 0.9
        self.view.addSubview(muscleShadowImageView)
    }
    
    //左下画像のアニメーションの設定
    func setupAnimation() {
        let moveToSkin = CABasicAnimation(keyPath: "position.x")
        moveToSkin.removedOnCompletion = false
        moveToSkin.fillMode = kCAFillModeForwards                               //アニメーション終了後にフレームを残す、アニメーションは自分で削除
        moveToSkin.fromValue = 0 - muscleSkinImageView.frame.width
        moveToSkin.toValue = muscleSkinImageView.frame.width / 8
        moveToSkin.duration = 0.5
        
        let moveToShadow = CABasicAnimation(keyPath: "position.x")
        moveToShadow.removedOnCompletion = false
        moveToShadow.fillMode = kCAFillModeForwards
        moveToShadow.fromValue = maxX + muscleShadowImageView.frame.width
        moveToShadow.toValue = maxX - muscleShadowImageView.frame.width / 8
        moveToShadow.duration = 0.5
        
        self.muscleSkinImageView.layer.addAnimation(moveToSkin, forKey: nil)
        self.muscleShadowImageView.layer.addAnimation(moveToShadow, forKey: nil)
    }
    
    //メニューを表示するラベルを設定
    func setupLabel() {
        let userData: NSDictionary = getUserStatus()
        var count = 0
        
        //labelに入力するstringを算出するクロージャ
        //countしたいからクロージャ
        let getLabelText = {(userData: NSDictionary, per: Float) -> String in
            //ネスト関数
            func inner() -> String {
                let weight: Float = userData["userWeight"] as! Float
                let leps: Int = userData["userLeps"] as! Int
                let RM = self.calculateRM(weight, leps: leps)
                var result = RM * (per/100)
                
                //小数点以下の0を取り除く
                let perValue: Double = Double(per)
                let perNumber: NSNumber = NSNumber.init(double: perValue)
                let perStr: String = String(perNumber)
                
                result *= 100
                result = round(result)
                result = result * 0.01
                let resultStr = String(result)
                
                //計算型プロパティ
                var switchLeps: Int {
                    switch count {
                    case 1:
                        return 8
                    case 2:
                        return 6
                    case 3:
                        return 4
                    case 4:
                        return 7
                    case 5:
                        return 5
                    case 6:
                        return 3
                    default:
                        return 0
                    }
                }
                
                if per == 100 {
                    return "\(perStr)% : \n\(resultStr)kg"
                } else {
                    count += 1
                    return "\(count), \(switchLeps)reps.\n\(perStr)%:\(resultStr)kg"
                }
            }
            return inner()
        }
        
        per100Label.setupSelf(labelSize, position: CGPoint(x: maxX/2, y: titleLabel.layer.position.y + maxY/8), text: getLabelText(userData, 100))
        self.view.addSubview(per100Label)
        
        //左列
        per80Label.setupSelf(labelSize, position: CGPoint(x: (per100Label.layer.position.x - labelSize.width/2 - 20),y: (per100Label.layer.position.y + maxY/5)), text: getLabelText(userData, 80))
        self.view.addSubview(per80Label)
        
        per85Label.setupSelf(labelSize, position: CGPoint(x: (per100Label.layer.position.x - labelSize.width/2 - 20),y: (per80Label.layer.position.y + maxY/7)), text: getLabelText(userData, 85))
        self.view.addSubview(per85Label)
        
        per90Label.setupSelf(labelSize, position: CGPoint(x: (per100Label.layer.position.x - labelSize.width/2 - 20),y: (per85Label.layer.position.y + maxY/7)), text: getLabelText(userData, 90))
        self.view.addSubview(per90Label)
        
        //右列
        per80Label2.setupSelf(labelSize, position: CGPoint(x: (per100Label.layer.position.x + labelSize.width/2 + 20),y: (per100Label.layer.position.y + maxY/5)), text: getLabelText(userData, 80))
        self.view.addSubview(per80Label2)
        
        per85Label2.setupSelf(labelSize, position: CGPoint(x: (per100Label.layer.position.x + labelSize.width/2 + 20),y: (per80Label2.layer.position.y + maxY/7)), text: getLabelText(userData, 85))
        self.view.addSubview(per85Label2)
        
        per90Label2.setupSelf(labelSize, position: CGPoint(x: (per100Label.layer.position.x + labelSize.width/2 + 20),y: (per85Label2.layer.position.y + maxY/7)), text: getLabelText(userData, 90))
        self.view.addSubview(per90Label2)
        
    }
    
    func getUserStatus() -> NSDictionary {
        let userDataObjects = app.myUserDefault.objectForKey("userData")
        let userDataDicArray: [NSDictionary] = userDataObjects as! [NSDictionary]
        for userDataDic in userDataDicArray {
            if userDataDic["userName"] as? String == app.userSelected {
                print("userWeight: \(userDataDic["userWeight"])")
                print("userLeps: \(userDataDic["userLeps"])")
                return userDataDic
            }
        }
        let nilDic: NSDictionary = ["userName": "No Selected", "userWeights": 0.0, "userLeps": 0]
        return nilDic
    }
    
    //1RM値を計算する関数
    func calculateRM(weight: Float, leps: Int) -> Float {
        print("weight: \(weight)")
        print("leps: \(leps)")
        print("RM : \(weight * (1+(Float(leps) / 40.0)))")
        return weight * (1+(Float(leps) / 40.0))
    }
    
}
