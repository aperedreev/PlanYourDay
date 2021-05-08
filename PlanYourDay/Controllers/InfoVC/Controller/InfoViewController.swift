//
//  InfoViewController.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//
import RealmSwift
import UIKit

class InfoViewController: UIViewController, UINavigationControllerDelegate {
  
  public var note: ToDoListItem?
  public var deletionHandler: (() -> Void)?
  public var completionHandler: (() -> Void)?
  private var realm = try! Realm()
  
  @IBOutlet weak var noteTitleTextField: UITextField!
  @IBOutlet weak var noteStartDateLabel: UILabel!
  @IBOutlet weak var noteEndDateLabel: UILabel!
  @IBOutlet weak var startDatePicker: UIDatePicker!
  @IBOutlet weak var endDatePicker: UIDatePicker!
  @IBOutlet weak var noteDescription: UITextView!
  @IBOutlet weak var noteImage: UIImageView!
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var photoCameraButton: UIButton!
  @IBOutlet weak var newNoteButton: UIButton!
  
  static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .short
    return dateFormatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = Constants.vcTitelPrefix + (note?.noteTitle ?? "")
    setUpTrashButton()
    setUpTextFieldAndTextView()
    setUpDataForInfoView()
    setUpBorder()
  }
  
  private func setUpBorder() {
    self.startDatePicker.setUpBorder()
    self.endDatePicker.setUpBorder()
    self.noteStartDateLabel.setUpBorder()
    self.noteEndDateLabel.setUpBorder()
  }
  
  private func setUpDataForInfoView() {
    noteTitleTextField.text = note?.noteTitle
    noteDescription.text = note?.descriptionText
    noteStartDateLabel.text = Constants.startDatePrefix + (Self.dateFormatter.string(from: note?.dateStart ?? Date()))
    noteEndDateLabel.text = Constants.endDatePrefix + (Self.dateFormatter.string(from: note?.dateFinish ?? Date()))
    if let image = note?.image { self.noteImage.image = UIImage(data: image) }
  }
  
  private func setUpTextFieldAndTextView() {
    self.noteDescription.delegate = self
    self.noteDescription.becomeFirstResponder()
    self.noteTitleTextField.delegate = self
  }
  
  private func setUpTrashButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .trash,
      target: self,
      action: #selector(onTrashButtonTapped))
  }
  
  @IBAction func onNewNoteButtonDidTap(_ sender: UIButton) {
    self.newNoteButton.pulsate()
    guard let vc = UIStoryboard.init(name: Constants.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: Constants.entyVCId) as? EntryViewController else { return }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func onCameraButtonDidTap(_ sender: UIButton) {
    self.photoCameraButton.pulsate()
    self.pickImage()
  }
  
  @IBAction func onSaveButtonDidTap(_ sender: UIButton) {
    if let noteTitle = noteTitleTextField.text, !noteTitle.isEmpty {
      saveButton.pulsate()
      guard let description = noteDescription.text, !description.isEmpty else { return }
      guard let image = noteImage.image?.jpegData(compressionQuality: 0.9) else { return }
      let startDate = startDatePicker.date
      let enddate = endDatePicker.date
      
      if let updateNote = note {
        try! realm.write {
          updateNote.noteTitle = noteTitle
          updateNote.descriptionText = description
          updateNote.image = image
          updateNote.dateStart = startDate
          updateNote.dateFinish = enddate
        }
      }
      self.completionHandler?()
      self.navigationController?.popToRootViewController(animated: true)
    }
  }
  
  @objc private func onTrashButtonTapped() {
    let alertMessage = UIAlertController(
      title: Constants.deletionAlertTitle,
      message: Constants.deletionAlertMessage,
      preferredStyle: .alert
    )
    let yesAction = UIAlertAction(title: Constants.yesTitle, style: .destructive, handler: { (action) -> Void in
      self.deleteTheNote()
    })
    let cancelAction = UIAlertAction(title: Constants.cancelTitle, style: .cancel) { (action) -> Void in }
    alertMessage.addAction(yesAction)
    alertMessage.addAction(cancelAction)
    self.present(alertMessage, animated: true, completion: nil)
  }
  
  private func deleteTheNote() {
    guard let note = self.note else { return }
    self.realm.beginWrite()
    self.realm.delete(note)
    try! self.realm.commitWrite()
    self.deletionHandler?()
    self.navigationController?.popToRootViewController(animated: true)
  }
  
}

extension InfoViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension InfoViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if !textView.text.isEmpty {
      textView.text = note?.descriptionText
      textView.textColor = .black
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textView.setupPlaceholder(text: Constants.textViewPlaceHolder)
    }
  }
}

extension InfoViewController: UIImagePickerControllerDelegate {
  
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
