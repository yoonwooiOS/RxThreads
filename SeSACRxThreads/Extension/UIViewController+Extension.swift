//
//  UIViewController+Extension.swift
//  RxThreads
//
//  Created by 김윤우 on 8/4/24.
//

import UIKit

extension UIViewController {
    func yearDateFormatter() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let thisYear = formatter.string(from: Date())
        guard let thisYear = Int(thisYear) else {
            print("monthDateFormatter Error")
            return 0
        }
        return thisYear
    }
    func monthDateFormatter() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        let thisMonth = formatter.string(from: Date())
        guard let thisMonth = Int(thisMonth) else {
            print("monthDateFormatter Error")
            return 0
        }
        return thisMonth
    }
    func todayDateFormatter() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let today = formatter.string(from: Date())
        guard let today = Int(today) else {
            print("todayDateFormatter Error")
            return 0
        }
        return today
    }
    
        func showAlert(t: String, msg: String, style: UIAlertController.Style, ok: String, complitionHandler: @escaping (UIAlertAction) -> Void ) {
            let alert = UIAlertController(title: t, message: msg, preferredStyle: style)
            let ok = UIAlertAction(title: ok, style: .default, handler: complitionHandler)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    
}
