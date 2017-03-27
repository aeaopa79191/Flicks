//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by KaKin Chiu on 1/7/16.
//  Copyright © 2016 KaKinChiu. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        SearchBar.delegate = self
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
    
        let refreshControl = UIRefreshControl()
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
//        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
//        let request = URLRequest(url: url!)
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)

        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                             self.filteredData = self.movies
                            self.tableView.reloadData()
                            
                    }
                }
        });
        task.resume()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let movies = filteredData {
            return movies.count
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String {
        let imageUrl = URL(string: baseUrl + posterPath)
        cell.posterView.setImageWith(imageUrl!)
        }
        
        cell.titleLable.text = title
        cell.overviewLable.text = overview
        
        //Customizing the cell selection effect
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.gray
        cell.selectedBackgroundView = backgroundView
        
        print("row \(indexPath.row)")
        return cell
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        
        // Make network request to fetch latest data
        
        // Do the following when the network request comes back successfully:
        // Update tableView data source
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredData = movies
        } else {
            filteredData = movies?.filter({ (movie: NSDictionary) -> Bool in
                if let title = movie["title"] as? String {
                    if title.range(of: searchText, options: .caseInsensitive) != nil {
                        
                        return  true
                    } else {
                        return false
                    }
                }
                return false
            })
        }
        tableView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = filteredData![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.SearchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.SearchBar.setShowsCancelButton(false, animated: true)
        SearchBar.resignFirstResponder()
        SearchBar.text = ""
        filteredData = movies
        tableView.reloadData()
    }
    
    
    

}
