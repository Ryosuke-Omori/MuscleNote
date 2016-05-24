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
        SweetAlertForMe().showAlert("REGIST", subTitle: "Please input your status.", style: AlertStyle.None, buttonTitle: "Cancel", buttonColor: UIColor.colorFromRGB(0xD0D0D0), otherButtonTitle: "OK", otherButtonColor: UIColor.colorFromRGB(0xDD6B55), useMustle: true) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("Cancel Button!")
            }
            else {
                print("OK Button!")
            }
            
        }
    }
    
    func onClickUpdateButton() {
        makeAlert("UPDATE", message: "Please input your status", preferredStyle: UIAlertControllerStyle.Alert)
    }
    
    func makeAlert(title:String, message:String, preferredStyle:UIAlertControllerStyle) {
        var weightsTextField: UITextField?
        var lepsTextField: UITextField?
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action:UIAlertAction) -> Void in
            print("Pushed CANCEL")
        })
        let registAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
            print("Pushed OK")
            print(weightsTextField?.text)
            print(lepsTextField?.text)
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(registAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField:UITextField) -> Void in
            weightsTextField = textField
        }
        alertController.addTextFieldWithConfigurationHandler{ (textField:UITextField) -> Void in
            lepsTextField = textField
        }
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}