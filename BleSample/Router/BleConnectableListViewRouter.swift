//
//  BleConnectableListViewRouter.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/24.
//

import Foundation
import SwiftUI
import CoreBluetooth
import Combine

protocol BleConnectableListViewRouterWireframe {
    
    static func assembleModule(viewModel: BleMngViewModel) -> BleConnectableListView
    
    func transitionDetailView(model: BlePeripheralEntity, viewModel: BleMngViewModel) -> BleConnectTargetDetailView
}

class BleConnectableListViewRouter: BleConnectableListViewRouterWireframe {

    let presenter: BleConnectableListViewPresenter
    
    init(presenter: BleConnectableListViewPresenter) {
        self.presenter = presenter
    }
    
    /// BleConnectableListViewを生成
    static func assembleModule(viewModel: BleMngViewModel) -> BleConnectableListView {
        
        let presenter = BleConnectableListViewPresenter(viewModel: viewModel)
        let view = BleConnectableListView(viewModel: viewModel, presenter: presenter)
        let router = BleConnectableListViewRouter(presenter: presenter)
        let interactor = BleConnectableListViewInteractor(presenter: presenter, viewModel: viewModel)
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = view
        
        return view
    }
    
    @ViewBuilder
    func transitionDetailView(model: BlePeripheralEntity, viewModel: BleMngViewModel) -> BleConnectTargetDetailView {
        
        let entity = BlePeripheralDetailEntity(id: model.id, name: model.name, isConnectable: model.isConnectable, localName: model.localName, serviceUUIDKey:  model.serviceUUIDKey, rssi: model.rssi)
        let nextViewModel = createBlePeripheralDetailViewModel(entity: entity, peripherals: viewModel.peripheralsModels)
        
        BleConnectTargetDetailViewRouter.assembleModule(viewModel: nextViewModel)
    }
}

private extension BleConnectableListViewRouter {
    
    func createBlePeripheralDetailViewModel(entity: BlePeripheralDetailEntity, peripherals: [BlePeripheralEntity]) -> BlePeripheralDetailViewModel {
        
        let viewModel = BlePeripheralDetailViewModel(model: entity)
        viewModel.peripheral = peripherals.first(where: {$0.peripheral.identifier.uuidString == viewModel.blePeripheralEntity.id})?.peripheral
        return viewModel
    }
}
