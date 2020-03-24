//
//  TimeSelectionViewController.swift
//  Personection
//
//  Created by Quintin Leary on 1/29/19.
//  Copyright © 2019 Quintin Leary. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class TimeSelectionViewController: UIViewController, TimePickerControllerDelegate {

    var startTime: Date?
    var endTime: Date?
    
    let earliestTimeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = NSTextAlignment.center
        l.text = "When is the earliest you would like to meet?"
        l.font = l.font.withSize(21)
        l.textColor = UIColor.white
        return l
    }()
    
    let startDateDisplay: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = NSTextAlignment.center
        l.font = l.font.withSize(30)
        l.text = "Now"
        l.textColor = UIColor.white
        return l
    }()
    
    var selectStartButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.white
        b.setTitleColor(themeColor, for: .normal)
        b.setTitle("Select a Time", for: .normal)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(handleStartTimeSelection), for: .touchUpInside)
        return b
    }()
    
    let latestTimeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = l.font.withSize(21)
        l.textAlignment = NSTextAlignment.center
        l.text = "When is the latest you would like to meet?"
        l.textColor = UIColor.white
        return l
    }()
    
    let endDateDisplay: UILabel = {
        let l = UILabel()
        var date = Date()
        date.addTimeInterval(5*60*60)
        let formatter = DateFormatter()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = NSTextAlignment.center
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = DateFormatter.Style.short
        formatter.locale = Locale(identifier: "en_US")
        l.text = formatter.string(from: date)
        l.font = l.font.withSize(30)
        l.textColor = UIColor.white
        return l
    }()
    
    lazy var selectEndButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.white
        b.setTitleColor(themeColor, for: .normal)
        b.setTitle("Select a Time", for: .normal)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(handleEndTimeSelection), for: .touchUpInside)
        return b
    }()
    
    var makePlansButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = UIColor.white
        b.setTitleColor(themeColor, for: .normal)
        b.setTitle("Make Plans!", for: .normal)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(handleMakePlans), for: .touchUpInside)
        return b
    }()
    
    lazy var cancel: UIBarButtonItem = {
        let c = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        c.tintColor = themeColor
        return c
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.startTime = Date()
        self.endTime = Date(timeInterval: 18000, since: self.startTime!)
        
        // Do any additional setup after loading the view.
    }
    
    //TimePickerController Delegate Function
    func passTime(date: Date, start: Bool) {
        //Handle getting the Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.locale = Locale(identifier: "en_US")
        if(start) {
            self.startTime = date
            print("DATE: " + dateFormatter.string(from: date))
            startDateDisplay.text = dateFormatter.string(from: date)
        } else {
            self.endTime = date
            endDateDisplay.text = dateFormatter.string(from: date)
        }
    }
    
    @objc func cancelPressed(sender: UIBarButtonItem) {
        print("Should dismiss view controller")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleStartTimeSelection() {
        let dateSelector = TimePopUpViewController()
        dateSelector.delegate = self
        dateSelector.selectingStart = true
        self.addChild(dateSelector)
        dateSelector.view.frame = self.view.frame
        self.view.addSubview(dateSelector.view)
        dateSelector.didMove(toParent: self)
    }
    
    @objc func handleEndTimeSelection() {
        let dateSelector = TimePopUpViewController()
        dateSelector.selectingStart = false
        dateSelector.delegate = self
        self.addChild(dateSelector)
        dateSelector.view.frame = self.view.frame
        self.view.addSubview(dateSelector.view)
        dateSelector.didMove(toParent: self)
    }
    
    @objc func handleMakePlans() {
        let uid = Auth.auth().currentUser?.uid
        let db = Firestore.firestore()
        
        guard let start = self.startTime else {
            return Log.e(eventType: LogEvent.null, message: "startTime is null while attempting to send plans request.")
        }
        
        guard let end = self.endTime else {
            return Log.e(eventType: LogEvent.null, message: "endTime is null while attempting to send plans request.")
        }
        var ref: DocumentReference? = nil
        ref = db.collection(Globals.usersPath).document(uid!).collection(Globals.plansPath).addDocument(data: [
            Globals.startTimePath: Double(start.timeIntervalSince1970),
            Globals.endTimePath: Double(end.timeIntervalSince1970),
            Globals.membersPath: [CurrentUser.getCurrentUser().getID()],
        ]) { err in
            if let err = err {
                print(err);
            } else {
                ref?.collection(Globals.membersPath).document(CurrentUser.getCurrentUser().getID()).setData([
                    "firstName": CurrentUser.getCurrentUser().getFirstName(),
                    "lastName": CurrentUser.getCurrentUser().getLastName()
                ])
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpUI() {
        view.backgroundColor = themeColor
        let nav = self.navigationItem
        nav.title = "Select a Time Slot"
        nav.leftBarButtonItem = cancel
        
        //Start Time Views
        self.view.addSubview(earliestTimeLabel)
        earliestTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        earliestTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        earliestTimeLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        earliestTimeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(startDateDisplay)
        startDateDisplay.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        startDateDisplay.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        startDateDisplay.topAnchor.constraint(equalTo: self.earliestTimeLabel.bottomAnchor, constant: 16).isActive = true
        startDateDisplay.heightAnchor.constraint(equalTo: earliestTimeLabel.heightAnchor).isActive = true
        
        self.view.addSubview(selectStartButton)
        selectStartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectStartButton.topAnchor.constraint(equalTo: startDateDisplay.bottomAnchor, constant: 15).isActive = true
        selectStartButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        selectStartButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        //End Time Views
        self.view.addSubview(latestTimeLabel)
        latestTimeLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        latestTimeLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        latestTimeLabel.topAnchor.constraint(equalTo: self.selectStartButton.bottomAnchor, constant: 50).isActive = true
        latestTimeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(endDateDisplay)
        endDateDisplay.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        endDateDisplay.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        endDateDisplay.topAnchor.constraint(equalTo: self.latestTimeLabel.bottomAnchor, constant: 16).isActive = true
        endDateDisplay.heightAnchor.constraint(equalTo: earliestTimeLabel.heightAnchor).isActive = true
        
        self.view.addSubview(selectEndButton)
        selectEndButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectEndButton.topAnchor.constraint(equalTo: endDateDisplay.bottomAnchor, constant: 15).isActive = true
        selectEndButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        selectEndButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.view.addSubview(makePlansButton)
        makePlansButton.topAnchor.constraint(equalTo: selectEndButton.bottomAnchor, constant: 75).isActive = true
        makePlansButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        makePlansButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        makePlansButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
