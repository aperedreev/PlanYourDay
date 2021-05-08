//
//  EntryViewController.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//

import RealmSwift
import UIKit

class EntryViewController: UIViewController, UINavigationControllerDelegate {
  
  @IBAction func unwindToEntryVC(segue: UIStoryboardSegue) {
      }
  
  @IBOutlet var noteTitleTextField: UITextField!
  @IBOutlet var startDatePicker: UIDatePicker!
  @IBOutlet weak var endDatePicker: UIDatePicker!
  @IBOutlet var noteDescriptionTextView: UITextView!
  @IBOutlet var noteImage: UIImageView!
  @IBOutlet weak var photoCameraButton: UIButton!
  
  private let realm = try! Realm()
  public var completionHandler: (() -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTextFieldAndTextView()
    setUpNavigationBar()
    startDatePicker.setDate(Date(), animated: true)
    endDatePicker.setDate(Date(), animated: true)
    startDatePicker.setUpBorder()
    endDatePicker.setUpBorder()
    
  }
  
  private func setUpNavigationBar() {
    title = "Add New Note"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Save",
      style: .done,
      target: self,
      action: #selector(onSaveButtonTapped))
  }
  
  private func setUpTextFieldAndTextView() {
    self.noteTitleTextField.becomeFirstResponder()
    self.noteDescriptionTextView.becomeFirstResponder()
    self.noteTitleTextField.delegate = self
    self.noteDescriptionTextView.delegate = self
  }
  
  @IBAction func onPhotoButtonTapped(_ sender: UIButton) {
    self.photoCameraButton.pulsate()
    self.pickImage()
  }
  
  @objc func onSaveButtonTapped() {
    if let text = noteTitleTextField.text, !text.isEmpty {
      let startDate = startDatePicker.date
      let enddate = endDatePicker.date
      guard let description = noteDescriptionTextView.text,
            !description.isEmpty,
            description != Constants.textViewPlaceHolder else {
        return AlertController.showIncompleteFormAlert(on: self)
      }
      guard let image = noteImage.image?.jpegData(compressionQuality: 0.9) else { return }
      
      realm.beginWrite()
      let newNote = ToDoListItem()
      newNote.dateStart = startDate
      newNote.dateFinish = enddate
      newNote.noteTitle = text
      newNote.descriptionText = description
      newNote.image = image
      realm.add(newNote)
      try! realm.commitWrite()
      completionHandler?()
      self.navigationController?.popToRootViewController(animated: true)
    } else {
      AlertController.showIncompleteFormAlert(on: self)
    }
  }
  
}

extension EntryViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension EntryViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      textView.resignFirstResponder()
      return false
    }
    return true
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == Constants.textViewPlaceHolder {
      textView.text = ""
      textView.textColor = .black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textView.setupPlaceholder(text: Constants.textViewPlaceHolder)
    }
  }
}

extension EntryViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    self.dismiss(animated: true, completion: nil)
    DispatchQueue.main.async {
      if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
        self.noteImage.image = image
      }
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}
