//
//  File.swift
//  InternTest
//
//  Created by Rahul Sheth on 7/3/17.
//  Copyright © 2017 Rahul Sheth. All rights reserved.
//

import Foundation
import UIKit
import Firebase

//This is where you search for users.
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating {
    
    
    
    
    
    //INITIALIZATION OF VARIABLES
    
    let ref = FIRDatabase.database().reference().child("users")
    var majorList = [String]()
    var universityList = [String]()
    var companyList = [String]()
    var peopleList = [User]()
    var skillList = [String]()
    var filteredMajorList = [String]()
    var filteredUniversityList = [String]()
    var filteredCompanyList = [String]()
    var filteredPeopleList = [User]()
    var filteredSkillList = [String]()
    var tableView = UITableView()
    var previousController = UIViewController()
    let searchController = UISearchController(searchResultsController: nil)
    let backButton = UIButton()

    
    
    
    deinit {
        
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class genericCellButton: UIButton {
        
        var typeString: String = ""
        var user = User()
        var typeInt: Int = 5
    }
    
    
    
    
    //-------------------------------------------------------------------------------------------
    //HELPER FUNCTIONS AND VIEW DID LOAD
    
    
    
    
    //First find all the students, then find all of the majors that start with that
    func fetchMajors() {
        ref.observe(.childAdded, with: { (snapshot) in
            let dictionary = snapshot.value as! [String: AnyObject]
            let user = User()
            if (dictionary["name"] as? String != nil) {
                user.name = dictionary["name"] as! String
            }
            user.uid = snapshot.key
            self.peopleList.append(user)
            
            if (dictionary["Occupation"] as? String == "Student") {
                if let majorString = dictionary["Major"] as? String {
                    
                    if (!self.majorList.contains((majorString as? String)!)) {
                        self.majorList.append((majorString as? String)!)
                    }
                }
                if let universityString = dictionary["Unversity"] as? String {
                    if (!self.universityList.contains((universityString as? String)!)) {
                        self.universityList.append(universityString)
                        
                    }
                }
                if let skill1 = dictionary["Skill 1"] as? String {
                    if (!self.skillList.contains(skill1)) {

                        self.skillList.append(skill1)
                    }
                }
                if let skill2 = dictionary["Skill 2"] as? String {
                    if (!self.skillList.contains(skill2)) {
                        self.skillList.append(skill2)
                    }
                }
                if let skill3 = dictionary["Skill 3"] as? String {
                    if (!self.skillList.contains(skill3)) {

                        self.skillList.append(skill3)
                    }
                }
                if let skill4 = dictionary["Skill 4"] as? String {
                    if (!self.skillList.contains(skill4)) {

                        self.skillList.append(skill4)
                    }
                }
            } else {
                if let companyString = dictionary["Company"] as? String {
                    if (!self.companyList.contains((companyString as? String)!)) {
                        self.companyList.append(companyString)
                    }
                }
                
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchText(searchText: searchController.searchBar.text!)
    }
    
    
    
    func filterSearchText (searchText: String, scope: String = "All") {
        filteredMajorList = majorList.filter { major in
            if (major.lowercased().contains(searchText.lowercased())) {
            }
            return major.lowercased().contains(searchText.lowercased())
            
            
        }
        filteredUniversityList = universityList.filter { university in
            return university.lowercased().contains(searchText.lowercased())
        }
        
        filteredCompanyList = companyList.filter { company in
            return company.lowercased().contains(searchText.lowercased())
        }
        filteredPeopleList = peopleList.filter { people in
            return people.name.lowercased().contains(searchText.lowercased())
        }
        filteredSkillList = skillList.filter { skills in
            return skills.lowercased().contains(searchText.lowercased())
        }
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
    
    
    
    
    func killSearch() {
        if (searchController.isActive == true) {
            searchController.isActive = false
        }
    }
    
    func handleMoveBackToFeed(sender: genericCellButton) {
        killSearch()
        
        let segueController = FeedController(nibName: nil, bundle: nil)
        segueController.passedInString = sender.typeString
        segueController.passedInInt = sender.typeInt
        segueController.searchBool = true
        present(segueController, animated: true, completion: nil)
    }
    
    func handleMoveToFullSearchForMajor() {
        
        let segueController = FullSearchViewController(nibName: nil, bundle: nil)
        segueController.isItemAUser = false
        if (filteredMajorList.count != 0) {
            segueController.itemList = filteredMajorList as [AnyObject]
        } else {
            segueController.itemList = majorList as [AnyObject]
        }
        killSearch()
        
        segueController.typeInt = 0
        present(segueController, animated: true, completion: nil)
    }
    
    func handleMoveToFullSearchForUniversity() {
        
        let segueController = FullSearchViewController(nibName: nil, bundle: nil)
        segueController.isItemAUser = false
        if (filteredUniversityList.count != 0 ) {
            segueController.itemList = filteredUniversityList as [AnyObject]
        } else {
            segueController.itemList = universityList as [AnyObject]
        }
        segueController.typeInt = 1
        killSearch()
        
        present(segueController, animated: true, completion: nil)
        
    }
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        backButton.isHidden = true
        return true
    }
    func handleMoveToFullSearchForCompany() {
        
        let segueController = FullSearchViewController(nibName: nil, bundle: nil)
        segueController.isItemAUser = false
        if (filteredCompanyList.count != 0 ) {
            segueController.itemList = filteredCompanyList as [AnyObject]
            
        } else {
            segueController.itemList = companyList as [AnyObject]
        }
        segueController.typeInt = 2
        killSearch()
        
        present(segueController, animated: true, completion: nil)
        
    }
    func handleMoveToFullSearchForUser() {
        let segueController = FullSearchViewController(nibName: nil, bundle: nil)
        segueController.isItemAUser = true
        if (filteredPeopleList.count != 0 ) {
            segueController.itemList = filteredPeopleList as [AnyObject]
            
        } else {
            segueController.itemList = peopleList as [AnyObject]
        }
        segueController.typeInt = 3
        killSearch()
        
        present(segueController, animated: true, completion: nil)
        
    }
    
    func handleMoveToFullSearchForSkills() {
        let segueController = FullSearchViewController(nibName: nil, bundle: nil)
        segueController.isItemAUser = false
        if (filteredSkillList.count != 0 ) {
            segueController.itemList = filteredSkillList as [AnyObject]
        } else {
            segueController.itemList = skillList as [AnyObject]
            
        }
        segueController.typeInt = 4
        killSearch()
        
        present(segueController, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)

        
        
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchBarStyle = .minimal
        self.searchController.searchBar.frame.size.width = self.view.frame.size.width * 0.85
        searchController.isActive = false
        searchController.searchBar.barTintColor = UIColor.white
        let containerView = UIView()
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        containerView.isUserInteractionEnabled = true
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.bounds.width * 0.1).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        containerView.addSubview(searchController.searchBar)
        
        view.addSubview(backButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 3).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        
        backButton.addTarget(self, action: #selector(handleMoveBack), for: .touchUpInside)
        fetchMajors()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.separatorStyle = .none
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        
        
        view.addGestureRecognizer(tap)
    }
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
    
    func handleMoveBack() {
        present(previousController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    //-------------------------------------------------------------------------------------------
    //TABLE VIEW AND ALL
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
        let titleLabel = UILabel()
        let cellButton = genericCellButton()
        cell.addSubview(cellButton)
        cell.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 24)
        let label = UILabel()
        cell.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
        label.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        
        
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        cellButton.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
        cellButton.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        cellButton.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        cellButton.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        var searchBool = false
        if (searchController.isActive == true) {
            backButton.isHidden = true
            
        } else {
            backButton.isHidden = false

        }
        if (searchController.isActive == true && searchController.searchBar.text != "") {
            searchBool = true
        }
        
        switch indexPath.section {
        case 0:
            
            
            titleLabel.text = "Major"
            
            break
        case 1:
            
            if (searchBool) {
                if (indexPath.row == 5 || indexPath.row == filteredMajorList.count) {
                    if (filteredMajorList.count == 0) {
                        label.text = "See All Majors"
                    } else {
                        label.text = "See More Majors"
                    }
                    cellButton.addTarget(self, action: #selector(handleMoveToFullSearchForMajor), for: .touchUpInside)
                    break
                }
                if (indexPath.row  < filteredMajorList.count) {
                    label.text = filteredMajorList[indexPath.row]
                    cellButton.typeString = label.text!
                    cellButton.typeInt = 0
                    cellButton.addTarget(self, action: #selector(handleMoveBackToFeed), for: .touchUpInside)
                    
                }
                break
            } else {
                if (indexPath.row == 5 || indexPath.row == majorList.count) {
                    label.text = "See more Majors"
                    cellButton.addTarget(self, action: #selector(handleMoveToFullSearchForMajor), for: .touchUpInside)
                    break
                }
                if (indexPath.row < majorList.count) {
                    label.text = majorList[indexPath.row]
                    cellButton.typeString = label.text!
                    cellButton.typeInt = 0
                    cellButton.addTarget(self, action: #selector(handleMoveBackToFeed), for: .touchUpInside)
                    
                    
                }
                break
            }
        case 2:
            
            
            titleLabel.text = "University"
            break
        case 3:
            
            if (searchBool) {
                if (indexPath.row == 5 || indexPath.row == filteredUniversityList.count) {
                    if (filteredUniversityList.count == 0) {
                        label.text = "See All Universities"
                    } else {
                        label.text = "See More Universities"
                    }
                    cellButton.addTarget(self, action: #selector(handleMoveToFullSearchForUniversity), for: .touchUpInside)
                    break
                }
                if (indexPath.row  < filteredUniversityList.count) {
                    label.text = filteredUniversityList[indexPath.row]
                    cellButton.typeString = label.text!
                    cellButton.addTarget(self, action: #selector(handleMoveBackToFeed), for: .touchUpInside)
                    
                    cellButton.typeInt = 1
                }
                break
            } else {
                if (indexPath.row == 5 || indexPath.row == universityList.count) {
                    label.text = "See more Universities"
                    cellButton.addTarget(self, action: #selector(handleMoveToFullSearchForUniversity), for: .touchUpInside)
                    break
                    
                }
                
                if (indexPath.row < universityList.count) {
                    label.text = universityList[indexPath.row]
                    cellButton.typeString = label.text!
                    cellButton.typeInt = 1
                    cellButton.addTarget(self, action: #selector(handleMoveBackToFeed), for: .touchUpInside)
                    
                }
                
                break
            }
        case 4:
            
            titleLabel.text = "Company"
            
            break
        case 5:
            
            if (searchBool) {
                if (indexPath.row == 5 || indexPath.row == filteredCompanyList.count) {
                    if (filteredCompanyList.count == 0) {
                        label.text = "See All Companies"
                    } else {
                        label.text = "See More Companies"
                    }
                    cellButton.addTarget(self, action: #selector(handleMoveToFullSearchForCompany), for: .touchUpInside)
                    break
                }
                if (indexPath.row  < filteredCompanyList.count) {
                    label.text = filteredCompanyList[indexPath.row]
                    cellButton.typeString = label.text!
                    cellButton.typeInt = 2
                    cellButton.addTarget(self, action: #selector(handleMoveBackToFeed), for: .touchUpInside)
                    
                }
                break
            } else {
                if (indexPath.row == 5 || indexPath.row == companyList.count) {
                    label.text = "See more Companies"
                    cellButton.addTarget(self, action: #selector(handleMoveToFullSearchForCompany), for: .touchUpInside)
                    break
                    
                }
                
                if (indexPath.row < companyList.count) {
                    label.text = companyList[indexPath.row]
                    cellButton.typeString = label.text!
                    cellButton.typeInt = 2
                    cellButton.addTarget(self, action: #selector(handleMoveBackToFeed), for: .touchUpInside)
                    
                }
                
                
                break
            }
        case 6:
            
            titleLabel.text = "People"
            break
        case 7:
            if (searchBool) {
                if (indexPath.row == 5 || indexPath.row == filteredPeopleList.count) {
                    if (filteredPeopleList.count == 0) {
                        label.text = "See All People"
                    } else {
                        label.text = "See More People"
                    }
                    cellButton.addTarget(self, action: #selector(handleMoveToFullSearchForUser), for: .touchUpInside)
                    break
                }
                if (indexPath.row  < filteredPeopleList.count) {
                    label.text = filteredPeopleList[indexPath.row].name
                    cellButton.typeString = filteredPeopleList[indexPath.row].uid
                    cellButton.typeInt = 3
                    cellButton.addTarget(self, action: #selector(handleMoveBackToFeed), for: .touchUpInside)
                    
                }
            } else {
                if (indexPath.row == 5 || indexPath.row == peopleList.count) {
                    label.text = "See more People"
                    cellButton.addTarget(self, action: #selector(handleMoveToFullSearchForUser), for: .touchUpInside)
                    break
                    
                }
                
                if (indexPath.row < peopleList.count) {
                    label.text = peopleList[indexPath.row].name
                    cellButton.typeString = peopleList[indexPath.row].uid
                    cellButton.typeInt = 3
                    cellButton.addTarget(self, action: #selector(handleMoveBackToFeed), for: .touchUpInside)
                    
                }
                
                
                break
            }
            
        case 8:
            titleLabel.text = "Skills"
            break
        case 9:
            if (searchBool) {
                if (indexPath.row == 5 || indexPath.row == filteredSkillList.count) {
                    if (filteredSkillList.count == 0) {
                        label.text = "See All Skills"
                    } else {
                        label.text = "See More Skills"
                    }
                    cellButton.addTarget(self, action: #selector(handleMoveToFullSearchForSkills), for: .touchUpInside)
                    break
                }
                if (indexPath.row  < filteredSkillList.count) {
                    label.text = filteredSkillList[indexPath.row]
                    cellButton.typeString = label.text!
                    
                    cellButton.typeInt = 4
                    cellButton.addTarget(self, action: #selector(handleMoveBackToFeed), for: .touchUpInside)
                    
                }
            } else {
                if (indexPath.row == 5 || indexPath.row == skillList.count) {
                    label.text = "See more Skills"
                    cellButton.addTarget(self, action: #selector(handleMoveToFullSearchForSkills), for: .touchUpInside)
                    break
                    
                }
                
                if (indexPath.row < skillList.count) {
                    label.text = skillList[indexPath.row]
                    cellButton.typeString = label.text!
                    cellButton.typeInt = 4
                    cellButton.addTarget(self, action: #selector(handleMoveBackToFeed), for: .touchUpInside)
                    
                }
                
                
                break
            }

        default:
            break
            
            
        }
        return cell
    }
    
    
    func rowCount(genericList: [AnyObject], filteredList: [AnyObject], searchBool: Bool) -> Int {
        if (searchBool) {
            if (filteredList.count < 5) {
                return filteredList.count + 1
            } else {
                return 6
            }
            
            
        }
        if (genericList.count < 5) {
            return genericList.count + 1
        }
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var searchBool = false
        if (searchController.isActive == true && searchController.searchBar.text != "") {
            searchBool = true
        }
        switch section {
        case 0, 2, 4, 6, 8:
            return 1
            
        case 1:
          return rowCount(genericList: majorList as [AnyObject], filteredList: filteredMajorList as [AnyObject], searchBool: searchBool)
        case 3:
            return rowCount(genericList: universityList as [AnyObject], filteredList: filteredUniversityList as [AnyObject], searchBool: searchBool)
        case 5:
            return rowCount(genericList: companyList as [AnyObject], filteredList: filteredCompanyList as [AnyObject], searchBool: searchBool)
        case 7:
            return rowCount(genericList: peopleList as [AnyObject], filteredList: filteredPeopleList as [AnyObject], searchBool: searchBool)
        case 9:
            return rowCount(genericList: skillList as [AnyObject], filteredList: filteredSkillList as [AnyObject], searchBool: searchBool)
        default:
            return 6
            
        }
    }
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0, 2, 4, 6, 8:
            return 75
            
        case 1, 3, 5, 7:
            return 25
            
        default:
            return 25
        }
    }
    
    
    
    
    
    
    
    
}
