//
//  AdvancedSearchViewController.swift
//  Pods
//
//  Created by Rahul Sheth on 9/20/17.
//
//

import UIKit
import Firebase

class AdvancedSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating {
    
    let titleLabel = UILabel()
    let continueButton = UIButton()
    let backButton = UIButton()
    let majorTitle = UILabel()
    let majorTextField = UITextField()
    let universityTitle = UILabel()
    let universityTextField = UITextField()
    let skillTitle = UILabel()
    let skillTextField = UITextField()
    
    var passedMajorList = [String]()
    var passedUniversityList = [String]()
    var passedSkillList = [String]()
    
    let bottomLabel = UILabel()
    let sendButton = UIButton()
    let searchController = UISearchController(searchResultsController: nil)

    var majorList = [String]()
    var universityList = [String]()
    var skillList = [String]()
    let genericList = ["Search for something in each category", "Then click on the characteristic you want", "This will add it in the bottom"]
    var filteredMajorList = [String]()
    var filteredUniversityList = [String]()
    var filteredSkillList = [String]()
    
    
    var tableView = UITableView()
    
   
    func handleBackMove() {
        dismiss(animated: true, completion: nil)
    }
    
    func killSearch() {
        if (searchController.isActive == true) {
            searchController.isActive = false
        }
    }
    func moveBackToFeed() {
        killSearch()
        let segueController = FeedController(nibName: nil, bundle: nil)
        segueController.passedMajorList = self.passedMajorList
        segueController.passedUniversityList = self.passedUniversityList
        segueController.passedSkillsList = self.passedSkillList
        segueController.passedInInt = 5
        segueController.searchBool = true
        present(segueController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        
        
        
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchBarStyle = .default
        
        self.searchController.searchBar.frame.size.width = self.view.frame.size.width * 0.85
        searchController.isActive = false
        searchController.searchBar.barTintColor = UIColor.white
        searchController.searchBar.scopeButtonTitles = ["Major", "University", "Skill"]
        searchController.searchBar.delegate = self
        let containerView = UIView()
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 15).isActive = true
        containerView.isUserInteractionEnabled = true
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: self.view.bounds.width * 0.1).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.topAnchor, constant: 50 ).isActive = true
        containerView.addSubview(searchController.searchBar)
        
        view.addSubview(backButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 3).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: self.view.bounds.height * 0.05).isActive = true
        backButton.setImage(UIImage(named: "arrowIcon"), for: .normal)
        
        backButton.addTarget(self, action: #selector(handleBackMove), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -60).isActive = true
        tableView.separatorStyle = .none
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tap.cancelsTouchesInView = false
        
        let bottomContainerView = UIView()
        self.view.addSubview(bottomContainerView)
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomContainerView.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        bottomContainerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomContainerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottomContainerView.backgroundColor = UIColor.white
        
        bottomContainerView.addSubview(bottomLabel)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        bottomLabel.leftAnchor.constraint(equalTo: bottomContainerView.leftAnchor, constant: 15).isActive = true
        bottomLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        bottomLabel.text = "Text Comes Here..."
        bottomLabel.numberOfLines = 0
        bottomLabel.lineBreakMode = .byWordWrapping
        bottomLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        bottomLabel.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 35).isActive = true
        bottomLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        let forwardButton = UIButton()
        bottomContainerView.addSubview(forwardButton)
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.setBackgroundImage(UIImage(named: "images"), for: .normal)
        forwardButton.leftAnchor.constraint(equalTo: bottomLabel.rightAnchor).isActive = true
        forwardButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true
        forwardButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor).isActive = true
        forwardButton.heightAnchor.constraint(equalTo: forwardButton.widthAnchor, constant: 10).isActive = true
        forwardButton.addTarget(self, action: #selector(moveBackToFeed), for: .touchUpInside)
        view.addGestureRecognizer(tap)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (searchController.isActive && searchController.searchBar.text != "") {
            switch searchController.searchBar.selectedScopeButtonIndex {
            case 0:
                return "Majors"
            case 1:
                return "Universities"
            default:
                return "Skills"
            }
        } else {
            return "How to Search"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.isActive && searchController.searchBar.text != "") {
            switch searchController.searchBar.selectedScopeButtonIndex {
            case 0:
                return filteredMajorList.count
            case 1:
                return filteredUniversityList.count
            default:
                return filteredSkillList.count
            }
        } else {
            return genericList.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if (searchController.isActive && searchController.searchBar.text != "") {
            bottomLabel.text = ""
            switch searchController.searchBar.selectedScopeButtonIndex {
            case 0:
                passedMajorList.append(filteredMajorList[indexPath.row])
                break
            case 1:
                passedUniversityList.append(filteredUniversityList[indexPath.row])
                break
            default:
                passedSkillList.append(filteredSkillList[indexPath.row])
            }
            
            
            
            for i in 0..<passedMajorList.count {
                bottomLabel.text?.append(passedMajorList[i])
                bottomLabel.text?.append(", ")
            }
            if (passedUniversityList.count != 0) {
            bottomLabel.text?.append(" at ")
            }
            for i in 0..<passedUniversityList.count {
                bottomLabel.text?.append(passedUniversityList[i])
                bottomLabel.text?.append(", ")
                
            }
            if (passedSkillList.count != 0) {
            bottomLabel.text?.append("skillful in ")
            }
            for i in 0..<passedSkillList.count {
                bottomLabel.text?.append(passedSkillList[i])
                bottomLabel.text?.append(", ")
            }
            searchController.searchBar.text = ""

        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CellID")
        let textLabel = UILabel()
        cell.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        textLabel.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 15).isActive = true
        textLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        

        
        if (searchController.isActive && searchController.searchBar.text != "") {
            cell.isUserInteractionEnabled = true
            switch searchController.searchBar.selectedScopeButtonIndex {
            case 0:
                textLabel.text = filteredMajorList[indexPath.row]
                break
            case 1:
                textLabel.text = filteredUniversityList[indexPath.row]
                break
            default:
                textLabel.text = filteredSkillList[indexPath.row]
                break
                
            }
        } else {
            cell.isUserInteractionEnabled = false
            textLabel.text = genericList[indexPath.row]
        }
        return cell 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //-----------------------------------
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchText(searchText: searchController.searchBar.text!)
    }
    
    
    
    func filterSearchText (searchText: String, scope: String = "All") {
        filteredMajorList = majorList.filter { major in
            return major.lowercased().contains(searchText.lowercased())
            
        }
        filteredUniversityList = universityList.filter { university in
            return university.lowercased().contains(searchText.lowercased())
        }
        
        filteredSkillList = skillList.filter { skills in
            return skills.lowercased().contains(searchText.lowercased())
        }
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
    
    

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
