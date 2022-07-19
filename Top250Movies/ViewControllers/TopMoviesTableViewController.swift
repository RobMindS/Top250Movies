//
//  TopMoviesTableViewController.swift
//  Top250Movies
//
//  Created by admin on 18.07.2022.
//

import UIKit

class TopMoviesTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    var searchBar: UISearchBar!
    private var pullControl = UIRefreshControl()
    var btnCancelSearch: UIBarButtonItem!
    
    let webService = WebService()
    var firstTenMovies: [TopMovies] = []
    var filterMovies: [TopMovies] = []
    
    //Constants
    struct Constants {
        static let cellHeight: CGFloat = 220
        static let searchBarHeight: CGFloat = 40
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        pullControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        self.tableView.refreshControl = pullControl
        
        hideKeyboardWhenTappedAround()
    }
    
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            
        case "movieDetail":
            guard let detailVC = segue.destination as? DetailViewController else { return }
            if let data = sender as? TopMovies {
                detailVC.movie = data
            }
            
        default:
            break
        }
    }
    
    @objc func getData() {
        webService.getMovies(requestUrl: .top250Movies, completionHandler: { result in
            DispatchQueue.main.async {
                self.firstTenMovies = result.limit(10)
                self.filterMovies = result.limit(10)
                self.tableView.reloadData()
                self.pullControl.endRefreshing()
            }
        })
    }
    
    
    //MARK: Set searchBar
    @IBAction func searchButtonAction(_ sender: UIBarButtonItem) {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: Constants.searchBarHeight))
        searchBar.placeholder = "Search movie"
        searchBar.searchBarStyle = .default
        searchBar.showsCancelButton = true
        searchBar.keyboardType = .alphabet
        searchBar.delegate = self
        
        self.navigationItem.titleView = self.searchBar
        self.searchButton.isEnabled = false
        searchBar.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        self.firstTenMovies = self.filterMovies
        self.tableView.reloadData()
        self.navigationItem.titleView = nil
        self.navigationController?.navigationItem.rightBarButtonItem = self.searchButton
        self.searchButton.isEnabled = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.firstTenMovies = self.filterMovies.filter{$0.title.lowercased().hasPrefix(searchText.lowercased()) }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstTenMovies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        cell.posterImageView.downloaded(from: firstTenMovies[indexPath.row].image)
        cell.movieNameLabel.text = firstTenMovies[indexPath.row].title
        cell.movieRankLabel.text = "Rank: " + firstTenMovies[indexPath.row].rank
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "movieDetail", sender: firstTenMovies[indexPath.row])
    }
    
}
