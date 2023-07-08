//
//  ContentViewPresenter.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/22.
//

import Foundation

protocol ContentViewPresentation {
    /// BleConnectableListViewへ画面遷移
    func transitionNextViewPresent() -> BleConnectableListView
    
    /// Viewが表示された際の処理
    func didApearView()
    
    /// Viewが非表示になった際の処理
    func willDisapearView()
    
    /// BLE接続先をスキャンした時の処理
    func notifyPeripherals()
    
    /// スキャンボタンをタップした時の処理
    func tappedScanButton()
    
    /// アラートの設定ボタンをタップした時の処理
    func tappedSettingButton()
}

class ContentViewPresenter {
    
    var view: ContentView!
    var router: ContentViewRouter!
    var interactor: ContetnViewUseCase!
    var viewModel: BleMngViewModel
    
    init(viewModel: BleMngViewModel) {
        self.viewModel = viewModel
    }
}

extension ContentViewPresenter: ContentViewPresentation{
    
    func transitionNextViewPresent() -> BleConnectableListView {
        
        router.transitionBleListView(viewModel: viewModel)
    }

    func didApearView() {
        
        interactor.initialViewProcess()
    }
    
    func willDisapearView() {
        
        interactor.disappearProcess()
    }
    
    func notifyPeripherals() {
        
        viewModel.isDiscoveredPeripherals = true
    }
    
    func tappedScanButton() {
        
        interactor.startScanPeripheral()
    }
    
    func tappedSettingButton() {
        
        router.openSetting()
    }
}
