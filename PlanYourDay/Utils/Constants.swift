//
//  Constants.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//

import Foundation

struct Constants {
  // VC Identifiers
  static let entyVCId = "EntryViewController"
  static let infoVCId = "InfoViewController"
  static let plannerVCId = "PlannerViewController"
  // AlertController
  static let saveAlertControllerTitle = "Missing Data"
  static let saveAlertControllerMessage = "You still have some empty fields. All the fields should be filled before saving"
  static let saveDismissTitle = "Dismiss"
  static let noteNameKey = "NoteName"
  static let noteTextKey = "NoteDescription"
  static let noteImageKey = "NoteImage"
  static let alertTitle = "Choose an Avatar"
  static let alertMessage = "from Source"
  static let cameraTitle = "From Camera"
  static let libraryTitle = "From Photos Library"
  static let savedPhotosTitle = "Saved Photos Album"
  static let cancelTitle = "Cancel"
  static let yesTitle = "Yes"
  static let deletionAlertTitle = "Please, confirm deletion!"
  static let deletionAlertMessage = "Are you sure you want to delete this note?"
  static let imgAlertCtrlTitle = "Add an Image"
  static let imgAlertCtrlMessage = "from Source"
  static let imgCancelActionTitle = "Cancel"
  static let photoLibraryTitle = "Photos Library"
  // Placeholder
  static let textViewPlaceHolder = "Type something here..."
  static let searchControllerplaceholder = "Search"
  // Prefixes
  static let vcTitelPrefix = "Update "
  static let startDatePrefix = "Start: "
  static let endDatePrefix = "End: "
  // Storyboard
  static let mainStoryboard = "Main"
}

enum Segue: String {
  case toNextController = "ToNextController"
}
