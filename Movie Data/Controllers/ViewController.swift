//
//  ViewController.swift
//  Movie Data
//
//  Created by Константин Малков on 24.06.2022.
//

import UIKit
import SafariServices

class ShowSearchResultController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .tertiarySystemBackground
    }
}

class ViewController: UIViewController {

    private let table = UITableView()
    
    private let searchController = UISearchController(searchResultsController: ShowSearchResultController())
    
    private var moviesKP = [Docs]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        searchbarSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    //MARK: - objc methods
    @objc func didTapHome(){
        moviesKP.removeAll()
        table.reloadData()
        title = "Top-10 Films by Kinopoisk rating"
        topMoviesKP()
    }
    
    //MARK: -  Editor funcs
    func tableViewSetup(){
        view.addSubview(table)
        title = "Top-10 Films by Kinopoisk rating"
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        topMoviesKP()
    }
    
    func searchbarSetup(){
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        let bar = searchController.searchBar
        bar.placeholder = "Enter film or serial!"
        bar.enablesReturnKeyAutomatically = true
        bar.backgroundColor = .tertiarySystemBackground
        bar.becomeFirstResponder()
        bar.showsCancelButton = true
    }
    
    //MARK: - Key func search movie
    func searchMovie(query: String) {
        guard let url = URL(string: "https://api.kinopoisk.dev/movie?field=name&search=\(query)&isStrict=false&sortField=rating.kp&sortType=-1&token=ZQQ8GMN-TN54SGK-NB3MKEC-ZKB8V06") else {
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let resultKP = try JSONDecoder().decode(Root.self, from: data)
                print("Result decoding \(resultKP.docs.count) movies")
                DispatchQueue.main.async {
                    self?.moviesKP = resultKP.docs
                    self?.table.reloadData()
                    if self?.moviesKP.count == 0 {
                        let alert = UIAlertController(title: "Error searching", message: "Enter another search request", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                        self?.present(alert, animated: true)
                    }
                    
                }
                
            }
            catch{
                print("Error downloading API: \(error)")
            }
            
        })
        .resume()
    }
    
    func topMoviesKP() {
        guard let url = URL(string: "https://api.kinopoisk.dev/movie?field=name&search=&isStrict=false&sortField=rating.kp&sortType=-1&token=ZQQ8GMN-TN54SGK-NB3MKEC-ZKB8V06") else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data , error == nil else {
                return
            }
            do {
                let resultKP = try JSONDecoder().decode(Root.self, from: data)
                print("Base random request is \(resultKP.docs.count) count")
                DispatchQueue.main.async {
                    self?.moviesKP = resultKP.docs
                    self?.table.reloadData()
                }
            }
            catch{
                print("Error of downloading Trend Movies \(error)")
            }
        }.resume()
    }
}

    //MARK: - Extension for table
extension ViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesKP.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            fatalError()
        }
        cell.configure(with: moviesKP[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string:"https://www.kinopoisk.ru/film/\(moviesKP[indexPath.row].id)/" ) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
}
    //MARK: - Extension for search bar
extension ViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.searchBar.text != nil else {
            return
        }
        let vc = searchController.searchResultsUpdater as? ShowSearchResultController
        vc?.view.backgroundColor = .lightGray
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            print(text)
            self.searchMovie(query: text)
            self.title = "Search result: \(text)"
            self.dismiss(animated: true)

        }
    }
}


