//
//  PlannerCell.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 08.05.2021.
//

import UIKit

class PlannerCell: UITableViewCell {
  
  static let identifier = "plannerCell"
  
  @IBOutlet weak var noteImage: UIImageView!
  @IBOutlet weak var noteTitleLabel: UILabel!
  @IBOutlet weak var noteDescriptionLabel: UILabel!
  
  override class func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.noteImage.image = nil
    self.noteTitleLabel.text = nil
    self.noteDescriptionLabel.text = nil
  }
  
  func configure(with model: ToDoListItem) {
    self.noteImage.image = UIImage(data: model.image)
    self.noteTitleLabel.text = model.noteTitle
    self.noteDescriptionLabel.text = model.descriptionText
  }
  
}
