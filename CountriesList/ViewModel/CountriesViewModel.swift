//
//  CountriesViewModel.swift
//  CountriesList
//
//  Created by Imal on 18.04.2018.
//  Copyright © 2018 1. All rights reserved.
//

import UIKit
import Moya
import EVReflection
import Result
import RxSwift
import RxCocoa

protocol CountriesViewModelCoordinatorDelegate: class
{
    func countriesViewModelDidSelectData(viewModel: CountriesViewModel,
                                         allCountries : [Country],
                                         selectedCountryIndex : Int)
}

protocol CountriesViewModelDelegate : class {
    func errorHandling(message : String)
    func loader(activate : Bool)
}

protocol CountriesViewModelType {
    var countriesObservable : Observable<[Country]> { get }
    var coordinatorDelegate : CountriesViewModelCoordinatorDelegate? { get set }
    var viewModelDelegate : CountriesViewModelDelegate? { get set }
    func selected(index : Int)
}

final class CountriesViewModel : CountriesViewModelType {
    private let countriesVariable = Variable<[Country]>([])
    lazy var countriesObservable = self.countriesVariable.asObservable()
    private let provider = MoyaProvider<RestCountries>()
    
    var coordinatorDelegate: CountriesViewModelCoordinatorDelegate?
    weak var viewModelDelegate: CountriesViewModelDelegate?
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var isDataUpdated: Bool = false {
        didSet {
            self.reloadTableView?()
        }
    }
    
    var updateLoadingStatus: (()->())?
    var reloadTableView: (()->())?
    
    func requestAllCountries() {
        self.viewModelDelegate?.loader(activate: true)
        provider.request(.all) { [weak self] (result) in
            self?.errorHandling(result: result)
            self?.viewModelDelegate?.loader(activate: false)
        }
    }
    
    func refreshData() {
        provider.request(.all) { [weak self] (result) in
            self?.errorHandling(result: result)
        }
    }
    
    func selected(index : Int) {
        coordinatorDelegate?.countriesViewModelDidSelectData(viewModel: self,
                                                             allCountries: countriesVariable.value,
                                                             selectedCountryIndex: index)
    }
    
    func errorHandling(result : Result<Moya.Response, MoyaError>) {
        switch result {
        case let .success(response):
            do {
                self.countriesVariable.value = try response.RmapArray(to: Country.self)
                self.isDataUpdated = true
            } catch {
                if let delegate =  self.viewModelDelegate {
                    delegate.errorHandling(message: "Try later")
                }
            }
        case let .failure(error):
            if let delegate =  self.viewModelDelegate {
                delegate.errorHandling(message: error.localizedDescription)
            }
        }
    }
}
