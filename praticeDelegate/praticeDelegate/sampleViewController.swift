//
//  sampleViewController.swift
//  praticeDelegate
//
//  Created by 서민영 on 2023/09/05.
//

import Foundation
import UIKit
import RealmSwift
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import NaverThirdPartyLogin

protocol CustomDelegate: AnyObject {
    func returnValue(num: String? ,message: String?)
}


class sampleViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var numberView: UITextView!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var textView: UITextView!
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    var userName: String = ""
    var userEmail: String = ""
    var userID: String = ""
    var mobile: String = ""
    var date: String = ""
    var load:[Person] = []
    lazy var realm: Realm? = {
        do {
            return try Realm()
        } catch {
            print("Could not access Realm, \(error)")
            return nil
        }
    }()
    var id = 1
    weak var delegate: CustomDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let savedPerson = realm?.objects(Person.self)
        id = savedPerson?.last?.id ?? 0
        print("id\(id)")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        let result = realm.objects(Person.self)
        self.load = Array(result)
      
        if nameField.text == "이름" {
            company.text =  load.last?.date
            nameField.text =  userName
            phoneNumber.text =  load.last?.phone
        } else {
            print("여기인가요")
            company.text = date
            nameField.text = userName
            phoneNumber.text = mobile
        }
       
      
    }
    
    func getInfo() {
        var ages = ageField.text ?? ""
        let person1 = Person()
        //        person1.age = Int(ages) ?? 0
        person1.name = nameField.text ?? ""
        person1.date = company.text ?? ""
        person1.phone = phoneNumber.text ?? ""
        person1.id = id + 1
        id = person1.id
        try! realm?.write {
            realm?.add(person1)
        }
    }
    @IBAction func gotoCalendarView(_ sender: Any) {
        getInfo()
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as? calendarViewController else { return }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showAgeView(_ sender: Any) {
        ageView.isHidden = false
        print("버튼이")
    }
    
    @IBAction func showphoneView(_ sender: Any) {
        phoneView.isHidden = false
        print("안눌리는")
    }
    @IBAction func showCompanyView(_ sender: Any) {
        companyView.isHidden = false
        print("경우")
    }
    @IBAction func logOutBtn(_ sender: Any) {
        loginInstance?.requestDeleteToken()
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func moveInfoVC(_ sender: Any) {
        if company.text != "날짜" {
            getInfo()
        }
        
        let savedPerson = realm?.objects(Person.self)
        print("경우\(id)")
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "infoTableViewController") as? infoTableViewController else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        self.delegate?.returnValue(num: nameField.text, message: phoneNumber.text)
    }
    
    
    
}
