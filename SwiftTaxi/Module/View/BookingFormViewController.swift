//
//  BookingFormViewController.swift
//  SwiftTaxi
//
//  Created by Priya Gnaneshwaran on 17/04/25.
//

import UIKit

class BookingFormViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfMobileNumber: UITextField!
    @IBOutlet weak var tfDestination: UITextField!
    @IBOutlet weak var tfDateAndTime: UITextField!
    @IBOutlet weak var tfDriverName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var tfBookingTimeAndDate: TextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var selectedDriver: Driver?
    var datePicker: UIDatePicker?
    var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
        self.setupDatePicker(for: tfDateAndTime, mode: .dateAndTime)
        self.updateDisplay()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        self.tfBookingTimeAndDate.text = formatter.string(from: Date())
        self.tfBookingTimeAndDate.isUserInteractionEnabled = false
        self.validateForm()
    }
    
    func updateDisplay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewHeader.setWidth(width: self.view.width)
            self.tableView.tableHeaderView = self.viewHeader
        }
    }
    
    func updateUI() {
        self.bgView.layer.masksToBounds = true
        self.bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bgView.layer.cornerRadius = 30
        self.tfDriverName.text = self.selectedDriver?.name
        self.tfDateAndTime.delegate = self
        self.tfBookingTimeAndDate.delegate = self
    }
    
    func setupDatePicker(for textField: UITextField, mode: UIDatePicker.Mode) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minuteInterval = 15
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        textField.inputView = datePicker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneButton], animated: false)
        
        textField.inputAccessoryView = toolBar
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if self.tfDateAndTime.isFirstResponder {
            self.tfDateAndTime.text = formatter.string(from: sender.date)
        }
    }
    
    @objc func donePressed() {
        if self.tfDateAndTime.isFirstResponder {
            self.tfDateAndTime.resignFirstResponder()
        }
    }
    
    func validateForm() {
        let isFormValid = !(tfName.text?.isEmpty ?? true) &&
        (tfMobileNumber.text?.count == 10) &&
        !(tfDestination.text?.isEmpty ?? true) &&
        !(tfDateAndTime.text?.isEmpty ?? true)
        
        self.btnSubmit.isEnabled = isFormValid
        self.btnSubmit.alpha = isFormValid ? 1.0 : 0.5
    }
    
    
    @IBAction func actionClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionSubmit(_ sender: UIButton) {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let nav = storyboard.instantiateViewController(withIdentifier: "SuccessPopupViewController") as? SuccessPopupViewController {
            nav.transitioningDelegate = self
            nav.modalPresentationStyle = .custom
            nav.updateCallBack = { flag in
                if flag {
                    if let nav = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                        self.present(nav, animated: true)
                    }
                }
            }
            self.present(nav, animated: true)
        }
    }
}

extension BookingFormViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.validateForm()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension BookingFormViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presenter = CustomPresentationController(presentedViewController: presented, presenting: presenting)
        presenter.onDismiss = { [weak self] in
            
        }
        let presentedFrame = presented.view.frame
        presenter.presentedViewFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: presentedFrame.width, height: presentedFrame.height))
        return presenter
    }
}
