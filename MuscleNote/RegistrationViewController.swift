//
//  RegistrationViewController.swift
//  MuscleNote
//
//  Created by 大森　亮佑 on 2016/04/18.
//  Copyright © 2016年 RyosukeOmori. All rights reserved.
//

import Foundation
import UIKit


class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    //override func---------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registButton.addTarget(self, action: #selector(RegistrationViewController.onClickRegistButton), forControlEvents: .TouchUpInside)
        updateButton.addTarget(self, action: #selector(RegistrationViewController.onClickUpdateButton), forControlEvents: .TouchUpInside)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //登録画面に遷移する際にnavigationControllerBarを表示
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.015, green: 0.002, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //トップに戻る際にnavigationControllerBarを非表示
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    //original func-----------------------------------------
    func onClickRegistButton() {
        let sweetAlert: SweetAlertForMe = SweetAlertForMe()
        sweetAlert.showAlert("REGIST", subTitle: "Please input your status.", style: AlertStyle.None, buttonTitle: "Cancel", buttonColor: UIColor.colorFromRGB(0xD0D0D0), otherButtonTitle: "OK", otherButtonColor: UIColor.colorFromRGB(0xDD6B55), useMustle: true) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("Cancel Button!")
            }
            else {
                print("OK Button!")
                self.checkAndSaveStatus(sweetAlert.nameTextField.text, weight: sweetAlert.weightTextField.text, leps: sweetAlert.lepsTextField.text)
            }
        }
    }
    
    func onClickUpdateButton() {
        if app.userSelected != nil {
            
        } else {
            SweetAlert().showAlert("Not selected!!!", subTitle: "Please select user.", style: AlertStyle.Error)
        }
    }
    
    
    func checkAndSaveStatus(name: String?, weight: String?, leps: String?) {
        if !((name!.isEmpty)) && !((weight!.isEmpty)) && !((leps!.isEmpty)) {
            let userDataObjects = app.myUserDefault.objectForKey("userData")
            if userDataObjects != nil {
                var userDataDicArray: [NSDictionary] = userDataObjects as! [NSDictionary]
                var userExistsFlag: Bool = false
                for userDataDic in userDataDicArray {
                    if (userDataDic["userName"])! as! String == name! {
                        userExistsFlag = true
                        SweetAlert().showAlert("Incorrect!!!", subTitle: "This user already exists.", style: AlertStyle.Error)
                        return
                    }
                }
                if !(userExistsFlag) {
                    if checkGrammar(weight!, leps: leps!) {
                        let userDic: NSDictionary = ["userName": name!,
                                                     "userWeight": weight!,
                                                     "userLeps": leps!
                        ]
                        let userData: UserData = UserData.SetUserData(userDic)
                        print(userDataDicArray.count)
                        print(userDataDicArray[0]["userName"])
                        userDataDicArray.append(userData.GetUserData())
                        app.myUserDefault.setObject(userDataDicArray, forKey: "userData")
                        SweetAlert().showAlert("Success!!!", subTitle: "You registed successfully.", style: AlertStyle.Success)
                    } else {
                        SweetAlert().showAlert("Incorrect!!!", subTitle: "This status is illegality.", style: AlertStyle.Error)
                    }
                }
            } else {
                if checkGrammar(weight!, leps: leps!) {
                    let userDic: NSDictionary = ["userName": name!,
                                                 "userWeight": weight!,
                                                 "userLeps": leps!
                    ]
                    let userData: UserData = UserData.SetUserData(userDic)
                    let userDataDicArray: [NSDictionary] = [userData.GetUserData()]
                    app.myUserDefault.setObject(userDataDicArray, forKey: "userData")
                    SweetAlert().showAlert("Success!!!", subTitle: "You registed successfully.", style: AlertStyle.Success)
                } else {
                    SweetAlert().showAlert("Incorrect!!!", subTitle: "This status is illegality.", style: AlertStyle.Error)
                }
            }
            app.userSelected = name
        } else {
            SweetAlert().showAlert("Incorrect!!!", subTitle: "Please Input completely.", style: AlertStyle.Error)
        }
    }
    
    func checkGrammar(weight: String, leps: String) -> Bool {
        var weightFlag: Bool = false
        var lepsFlag: Bool = false
        
        let wPattern = "\\d+\\.\\d+"
        if Regexp(wPattern).isMatch(weight) {
            weightFlag = true
        }
        
        let lPattern = "\\d+"
        if Regexp(lPattern).isMatch(leps) {
            lepsFlag = true
        }
        
        if weightFlag && lepsFlag {
            return true
        }
        return false
    }
    
}