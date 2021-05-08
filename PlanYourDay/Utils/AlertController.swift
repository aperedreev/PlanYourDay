//
//  AlertController.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 08.05.2021.
//

import UIKit

struct AlertController {
  
  var model = InfoViewController()
  
  private static func showSaveButtonAlert(on vc: UIViewController, with title: String, message: String) {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    
    alertController.addAction(UIAlertAction(
      title: Constants.saveDismissTitle,
      style: .default,
      handler: nil
    ))
    DispatchQueue.main.async {
      vc.present(alertController, animated: true)
    }
  }
  
  static func showIncompleteFormAlert(on vc: UIViewController) {
    showSaveButtonAlert(on: vc, with: Constants.saveAlertControllerTitle, message: Constants.saveAlertControllerMessage)
  }
  
  private static func showImagePickerAlert(on vc: UIViewController, with title: String, message: String) {
    let pickerController = UIImagePickerController()
    pickerController.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    pickerController.allowsEditing = true
    
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .actionSheet
    )
  
    alertController.addAction(UIAlertAction(
      title: Constants.libraryTitle,
      style: .default) { (action) in
      pickerController.sourceType = .photoLibrary
      vc.present(pickerController, animated: true, completion: nil)
    })
    
    alertController.addAction(UIAlertAction(
      title: Constants.savedPhotosTitle,
      style: .default)  { (action) in
      pickerController.sourceType = .savedPhotosAlbum
      vc.present(pickerController, animated: true, completion: nil)
    })
    
    alertController.addAction(UIAlertAction(
                                title: Constants.cancelTitle,
                                style: .destructive,
                                handler: nil))
    DispatchQueue.main.async {
      vc.present(alertController, animated: true)
    }
    
  }
  
  static func showImagePickerSources(on vc: UIViewController) {
    showImagePickerAlert(on: vc, with: Constants.alertTitle, message: Constants.alertMessage)
  }
  
//  private func showDeletionAlert(on vc: UIViewController, with title: String, message: String) {
//    let alertMessage = UIAlertController(
//      title: "Please, confirm deletion!",
//      message: "Are you sure you want to delete this note?",
//      preferredStyle: .alert
//    )
//    let yes = UIAlertAction(
//      title: "Yes",
//      style: .default,
//      handler: { (action) -> Void in
//      model.deleteTheNote()
//    })
//    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in }
//    alertMessage.addAction(yes)
//    alertMessage.addAction(cancel)
//    vc.present(alertMessage, animated: true, completion: nil)
//    DispatchQueue.main.async {
//      vc.present(alertMessage, animated: true)
//    }
//  }
//  
//  static func showDeletionAlertForm(on vc: UIViewController) {
//  }
  
}

