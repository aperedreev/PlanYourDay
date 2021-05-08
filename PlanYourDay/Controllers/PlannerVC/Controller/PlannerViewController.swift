//
//  PlannerViewController.swift
//  PlanYourDay
//
//  Created by NIKOLAI BORISOV on 06.05.2021.
//

import RealmSwift
import UIKit

class PlannerViewController: UIViewController, UISearchControllerDelegate {
  
  @IBOutlet weak var plannerTableView: UITableView!
  @IBOutlet weak var countLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  private var data = [ToDoListItem]()
  private var realm = try! Realm()
  private var items: Results<ToDoListItem>?
  private var deletionHandler: (() -> Void)?
  
  // MARK: - Setting up the search bar properties
  
  private let searchController = UISearchController(searchResultsController: nil)
  var filteredNotes: [ToDoListItem] = []
  private var searchBarIsEmpty: Bool {
    guard let text = searchController.searchBar.text else { return false }
    return text.isEmpty
  }
  var isFiltering: Bool {
    return searchController.isActive && !searchBarIsEmpty
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.data = realm.objects(ToDoListItem.self).map({$0})
    self.items = realm.objects(ToDoListItem.self)
    self.setUpTableView()
    self.setupSearchController()
    self.setupActivityIndicator()
    self.getNotesFromJSON()
  }
  
  private func getNotesFromJSON() {
    self.data = JSONParcer.parseFile(with: .PlannerJSON, type: ToDoListItem.self) ?? []
    data.forEach {
      print($0)
    }
    self.plannerTableView.reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.refresh()
    self.countNotes()
  }
  
  private func countNotes() {
    if data.count == 1 {
      countLabel.text = "\(data.count)" + " Note"
    } else {
      countLabel.text = "\(data.count)" + " Notes"
    }
  }
  
  private func setUpTableView() {
    self.plannerTableView.register(UINib(nibName: "PlannerCell", bundle: nil), forCellReuseIdentifier: PlannerCell.identifier)
    self.plannerTableView.delegate = self
    self.plannerTableView.dataSource = self
  }
  
  private func setupActivityIndicator() {
    activityIndicator.startAnimating()
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.activityIndicator.stopAnimating()
      self.activityIndicator.removeFromSuperview()
    }
  }
  
  private func setupSearchController() {
    searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchController.searchResultsUpdater = self
    searchController.delegate = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = Constants.searchControllerplaceholder
    UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
    navigationItem.searchController = searchController
    definesPresentationContext = true
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  @available(iOS 13.0, *)
  @IBAction func onAddButtonTapped() {
    guard let vc = storyboard?.instantiateViewController(identifier: Constants.entyVCId) as? EntryViewController else { return }
    vc.completionHandler = { [weak self] in
      self?.refresh()
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  private func refresh() {
    data = realm.objects(ToDoListItem.self).map({$0})
    plannerTableView.reloadData()
  }
}

// MARK:- TableViewDataSource, TableViewDelegate

extension PlannerViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60.0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering {
      return filteredNotes.count
    }
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PlannerCell.identifier, for: indexPath) as? PlannerCell else { return UITableViewCell() }
    var item: ToDoListItem
    if isFiltering {
      item = filteredNotes[indexPath.row]
    } else {
      item = data[indexPath.row]
    }
    cell.configure(with: item)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if #available(iOS 13.0, *) {
      guard let vc = storyboard?.instantiateViewController(identifier: Constants.infoVCId) as? InfoViewController else { return }
      vc.deletionHandler = { [weak self] in
        self?.refresh()
      }
      let note: ToDoListItem
      if isFiltering {
        note = filteredNotes[indexPath.row]
      } else {
        note = data[indexPath.row]
      }
      vc.note = note
      navigationController?.pushViewController(vc, animated: true)
    } else {
      return
    }
  }
  
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      tableView.beginUpdates()
      if let item = items?[indexPath.row] {
        data.remove(at: indexPath.row)
        try! realm.write {
          realm.delete(item)
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        tableView.reloadData()
        self.countNotes()
        self.deletionHandler?()
      }
    }
  }
  
}

//MARK: - SearchController methods

extension PlannerViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text ?? "")
  }
  
  func filterContentForSearchText(_ searchText: String) {
    filteredNotes = data.filter({ (note: ToDoListItem) -> Bool in
      return note.noteTitle.lowercased().contains(searchText.lowercased())
    })
    plannerTableView.reloadData()
  }
}
