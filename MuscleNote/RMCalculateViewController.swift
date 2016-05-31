
import UIKit

class RMCalculateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var namePickerView: UIPickerView!
    
    let app: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupNamePickerView()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        namePickerView.selectRow(searchUserNumber(), inComponent: 0, animated: true)
        namePickerView.reloadAllComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func setupNamePickerView() {
        namePickerView.delegate = self
        namePickerView.dataSource = self
        namePickerView.backgroundColor = UIColor.blackColor()
        namePickerView.selectRow(searchUserNumber(), inComponent: 0, animated: true)
    }
    
    func getUserDataDicArray() -> [NSDictionary] {
        let userDataObject = app.myUserDefault.objectForKey("userData")
        if userDataObject != nil {
            let userDataDicArray: [NSDictionary] = userDataObject as! [NSDictionary]
            return userDataDicArray
        } else {
            let nilDicArray: [NSDictionary] = [[
                "userName": "Nothing Data",
                "userWeight": 0,
                "userLeps": 0
                ]]
            return nilDicArray
        }
    }
    
    func searchUserNumber() -> Int {
        let userDataDicArray: [NSDictionary] = getUserDataDicArray()
        for i in 0..<userDataDicArray.count {
            print("userSelected: \(app.userSelected)")
            if userDataDicArray[i]["userName"] as? String == app.userSelected {
                print("searchUserNumber(): \(i)")
                return i
            }
        }
        return 0
    }
    
    
    //delegate: UIPickerView-----------------------------------------
    //pickerに表示する列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //pickerに表示する行数
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.getUserDataDicArray().count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: (self.getUserDataDicArray()[row]["userName"] as? String)!, attributes: [NSFontAttributeName:UIFont(name: "HiraKakuProN-W3", size: 20.0)!,NSForegroundColorAttributeName:UIColor.whiteColor()])
        label.textAlignment = NSTextAlignment.Center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5.0
        
//        if let lb = pickerView.viewForRow(row, forComponent: component) as? UILabel, let selected = 
        return label
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("row: \(row)")
        print("value: \(self.getUserDataDicArray()[row]["userName"])")
        app.userSelected = self.getUserDataDicArray()[row]["userName"] as? String
    }
    

}

