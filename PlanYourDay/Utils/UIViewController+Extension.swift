//
//  UIViewController+Extension.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 08.05.2021.
//

import UIKit

extension UIViewController {
  func pickImage() {
    let pickerController = UIImagePickerController()
    pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
    pickerController.allowsEditing = true
    
    let alertController = UIAlertController(
      title: Constants.imgAlertCtrlTitle,
      message: Constants.imgAlertCtrlMessage,
      preferredStyle: .actionSheet
    )
    let photosLibraryAction = UIAlertAction(
      title: Constants.photoLibraryTitle,
      style: .default) { (action) in
      pickerController.sourceType = .photoLibrary
      self.present(pickerController, animated: true, completion: nil)
    }
    let savedPhotosAction = UIAlertAction(
      title: Constants.savedPhotosTitle,
      style: .default)  { (action) in
      pickerController.sourceType = .savedPhotosAlbum
      self.present(pickerController, animated: true, completion: nil)
    }
    let cancelAction = UIAlertAction(
      title: Constants.imgCancelActionTitle,
      style: .destructive, handler: nil)
    
    alertController.addAction(photosLibraryAction)
    alertController.addAction(savedPhotosAction)
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
}
