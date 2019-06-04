//
//  TimePopUpViewController.swift
//  Personection
//
//  Created by Quintin Leary on 2/19/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import UIKit

class TimePopUpViewController: UIViewController {
    
    private var selectedDate: Date?
    var selectingStart: Bool?
    var delegate: TimePickerControllerDelegate?

    lazy var datePicker: UIDatePicker = {
        let pv = UIDatePicker()
        pv.minuteInterval = 30
        pv.backgroundColor = UIColor.white
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.addTarget(self, action: #selector(handleDateChange), for: .valueChanged)
        return pv
    }()
    
    let backgroundView: UIView = {
        let bv = UIView()
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.layer.cornerRadius = 10
        bv.layer.masksToBounds = true
        bv.backgroundColor = UIColor.white
        return bv
    }()
    
    lazy var doneButton: UIButton = {
        let db = UIButton(type: .system)
        db.translatesAutoresizingMaskIntoConstraints = false
        db.addTarget(self, action: #selector(removeAnimate), for: .touchUpInside)
        db.setTitle("Done", for: .normal)
        db.setTitleColor(themeColor, for: .normal)
        return db
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedDate = datePicker.date
        setUpUI()
        self.showAnimate()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleDateChange() {
        self.selectedDate = self.datePicker.date
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    @objc func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: { (finished : Bool) in
            if(finished) {
                if let start = self.selectingStart {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = DateFormatter.Style.short
                    dateFormatter.timeStyle = DateFormatter.Style.short
                    if let date = self.selectedDate {
                        print("Date: " + dateFormatter.string(from: date))
                        self.delegate?.passTime(date: date, start: start)
                    } else {
                        print("Date has not been initialized")
                    }
                } else {
                    print("SOMETHING WENT Wrong: START HAS NOT BEEN INTIALIZED")
                }
                self.view.removeFromSuperview()
            }
        })
    }

    
    func setUpUI() {
        view.addSubview(backgroundView)
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        backgroundView.widthAnchor.constraint(equalToConstant: 340).isActive = true
        
        backgroundView.addSubview(datePicker)
        datePicker.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20).isActive = true
        datePicker.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, constant: -40).isActive = true
        datePicker.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 2/3).isActive = true
        
        backgroundView.addSubview(doneButton)
        doneButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
