//
//  calendarViewController.swift
//  praticeDelegate
//
//  Created by 서민영 on 2023/09/05.
//

import Foundation
import FSCalendar
import RealmSwift

class calendarViewController: UIViewController{
    
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var calendarView: FSCalendar!
    var dateSelect: String = ""
    let dateFormatter = DateFormatter()
    let realm = try! Realm()
    var load:[Person] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.backgroundColor = UIColor(red: 241/255, green: 249/255, blue: 255/255, alpha: 1)
        calendarView.appearance.selectionColor = UIColor(red: 38/255, green: 153/255, blue: 251/255, alpha: 1)
        calendarView.appearance.todayColor = UIColor(red: 188/255, green: 224/255, blue: 253/255, alpha: 1)
        calendarView.allowsMultipleSelection = true
        calendarView.swipeToChooseGesture.isEnabled = true
        calendarView.scrollEnabled = true
        calendarView.scrollDirection = .vertical
        let realm = try! Realm()
        let result = realm.objects(Person.self)
        self.load = Array(result)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func selectDate(_ sender: Any) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "sampleViewController") as? sampleViewController else { return }
        vc.date = dateSelect ?? ""
        vc.userName = load.last?.name ?? ""
        vc.mobile = load.last?.phone ?? ""
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension calendarViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.selectedDates.count > 2{
            for _ in 0 ..< calendar.selectedDates.count - 1{
                calendar.deselect(calendar.selectedDates[0])
            }
        }
        
        var startTemp: Date!
        if calendar.selectedDates.count == 2{
            if calendar.selectedDates[0] < calendar.selectedDates[1]{
                startTemp = calendar.selectedDates[0]
                while startTemp < calendar.selectedDates[1]-86400{
                    startTemp += 86400
                    calendar.select(startTemp)
                }
                startTemp = nil
            }
            else{
                startTemp = calendar.selectedDates[1]
                while startTemp < calendar.selectedDates[0] - 86400{
                    startTemp += 86400
                    calendar.select(startTemp)
                }
            }
            var firstDate  = dateFormatter.string(from: calendar.selectedDates[0])
            var endDate = dateFormatter.string(from: calendar.selectedDates[1])
            dateSelect = firstDate + "~" + endDate
            print(dateFormatter.string(from: calendar.selectedDates[0]) + " 선택됨")
            
            print(dateFormatter.string(from: calendar.selectedDates[1]) + " 선택됨")
        }
        
       
        
//        UserDefaults.standard.set(dateFormatter.string(from: date),forKey: "dates")
    }
}
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        for _ in 0 ..< calendar.selectedDates.count {
                   calendar.deselect(calendar.selectedDates[0])
               }
               calendar.select(date)
           }

    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//            switch dateFormatter.string(from: date) {
//            case "2023-09-25":
//                return "D-day"
//            default:
//                return nil
//            }
//        }
//    
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//
//            switch dateFormatter.string(from: date) {
//            case dateFormatter.string(from: Date()):
//                return "오늘"
//            case "2023-09-05":
//                return "출근"
//            case "2023-09-06":
//                return "지각"
//            case "2023-09-07":
//                return "결근"
//            case "2023-09-25":
//                return "D-day"
//            default:
//                return nil
//            }
//        }
    
    
