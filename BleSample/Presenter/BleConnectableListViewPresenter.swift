//
//  BleConnectableListViewPresenter.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/22.
//

import Foundation
import CoreBluetooth
import Combine

protocol BleConnectableListViewPresentation {
    
    func didApearView()
    
    func willDisapearView()
    
    func tappedPeripheral(model: BlePeripheralEntity) -> BleConnectTargetDetailView
    
    func reloadList()
}

class BleConnectableListViewPresenter {
    
    var view: BleConnectableListView?
    var router: BleConnectableListViewRouterWireframe!
    var interactor: BleConnectableListViewUseCase!
    var viewModel: BleMngViewModel
    
    init(viewModel: BleMngViewModel) {
        self.viewModel = viewModel
    }
}

extension BleConnectableListViewPresenter: BleConnectableListViewPresentation{
    
    /// Viewが表示された際の処理
    func didApearView() {
        return
    }
    
    /// Viewが非表示になった際の処理
    func willDisapearView() {
        
        interactor.disapperProcess()
    }
    
    /// リストのセルをタップした際の処理
    func tappedPeripheral(model: BlePeripheralEntity) -> BleConnectTargetDetailView {
        
        
        
        return router.transitionDetailView(model: model, viewModel: viewModel)
    }
    
    /// peripheralリストのリロードを行う
    func reloadList() {
        
        interactor.scanPeripheral()
    }
}
