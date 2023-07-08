//
//  BleConnectTargetDetailViewRouter.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/24.
//

import Foundation
import SwiftUI
import Combine
import CoreBluetooth

protocol BleConnectTargetDetailViewWireframe {
    
    /// BleConnectTargetDetailViewを生成
    static func assembleModule(viewModel: BlePeripheralDetailViewModel) -> BleConnectTargetDetailView
    
}

class BleConnectTargetDetailViewRouter: BleConnectTargetDetailViewWireframe {

    let presenter: BleConnectTargetDetailViewPresenter
    
    init(presenter: BleConnectTargetDetailViewPresenter) {
        self.presenter = presenter
    }
    
    static func assembleModule(viewModel: BlePeripheralDetailViewModel) -> BleConnectTargetDetailView {
        
        let presenter = BleConnectTargetDetailViewPresenter(viewModel: viewModel)
        let view = BleConnectTargetDetailView(viewModel: viewModel, presenter: presenter)
        let router = BleConnectTargetDetailViewRouter(presenter: presenter)
        let interactor = BleConnectTargetDetailViewInteractor(presenter: presenter, viewModel: viewModel)
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
}
