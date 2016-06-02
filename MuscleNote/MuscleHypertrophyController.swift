//
//  MuscleHypertrophyController.swift
//  MuscleNote
//
//  Created by 大森　亮佑 on 2016/06/02.
//  Copyright © 2016年 RyosukeOmori. All rights reserved.
//

import Foundation
import UIKit

class MuscleHypertrophyController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    let per100Label: UILabel = UILabel()
    let per87_5Label: UILabel = UILabel()
    let per85Label: UILabel = UILabel()
    let per82_5Label: UILabel = UILabel()
    let per80Label: UILabel = UILabel()
    let per77_5Label: UILabel = UILabel()
    let per75Label: UILabel = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabel()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //登録画面に遷移する際にnavigationControllerBarを表示
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.015, green: 0.002, blue: 0, alpha: 0.2)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        //トップに戻る際にnavigationControllerBarを非表示
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupLabel() {
        
    }
    
}
