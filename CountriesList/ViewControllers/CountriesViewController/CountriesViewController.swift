//
//  CountriesViewController.swift
//  CountriesList
//
//  Created by Imal on 18.04.2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reachability

class CountriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var reachability = Reachability()
    var viewModel = CountriesViewModel() {
        didSet {
            self.viewModel.viewModelDelegate = self
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshData),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Country's list"
        networkReachability()
        setupTableView()
        setupViewModel()
    }
    
    
    //MARK: - NetworkReachability
    func networkReachability() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkStatusChanged(_:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if let reachability = notification.object as? Reachability,
            reachability.connection == .none {
            if viewModel.isEmpty {
                 showAlert("Ooops!", message: "Lost connection(")
            } else {
                showAlert("Ooops! Lost connection(",
                          message: "But don't worry. You can work with cashed data")
            }
        }
    }
    
    //MARK: - TableView
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "CountryWithPopulationTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "countryCell")
        tableView.addSubview(refreshControl)
    }
    
    //MARK: - ViewModel
    func setupViewModel() {
        //select country handling
        tableView.rx.itemSelected.subscribe({ [weak self] country in
            if let index = country.element?.row {
                self?.viewModel.selected(index: index)
            }
        }).disposed(by: disposeBag)
        
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        //setup bind
        viewModel.countriesObservable.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell") as! CountryWithPopulationTableViewCell
            if let name = element.name {
                cell.countryLabel?.text = name
            }
            cell.populationLabel?.text = "\(element.population)"
            return cell
        }.disposed(by: disposeBag)
        
        viewModel.requestAllCountries()
    }
    
    //MARK: - Others
    
    @objc func refreshData() {
        viewModel.refreshData()
        refreshControl.endRefreshing()
    }
    
    func animateTableView(alpha : CGFloat) {
        UIView.animate(withDuration: 0.2, animations: {
            self.tableView.alpha = alpha
        })
    }

    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }
}

extension CountriesViewController : CountriesViewModelDelegate {
    
    func loader(activate: Bool) {
        if activate {
            self.activityIndicator.startAnimating()
            self.animateTableView(alpha: 0)
        } else {
            self.activityIndicator.stopAnimating()
            self.animateTableView(alpha: 1)
        }
    }
    
    func errorHandling(message: String) {
        showAlert("Error", message: message)
    }
}
