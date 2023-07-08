//
//  ContentViewRouter.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/24.
//

import Foundation
import SwiftUI
import UIKit

protocol ContentViewWireframe {
    
    /// ContentViewを生成
    static func assembleModule(viewModel: BleMngViewModel) -> ContentView
    
    /// BleConnectableListViewへ遷移
    func transitionBleListView(viewModel: BleMngViewModel) -> BleConnectableListView
    
    /// 設定を開く
    func openSetting()
    
}

class ContentViewRouter: ContentViewWireframe {
    let presenter: ContentViewPresenter
    let view: ContentView
    
    init(presenter: ContentViewPresenter, view: ContentView) {
        self.presenter = presenter
        self.view = view
    }
    
    static func assembleModule(viewModel: BleMngViewModel) -> ContentView {
        let presenter = ContentViewPresenter(viewModel: viewModel)
        let view = ContentView(viewModel: viewModel, presenter: presenter)
        let router = ContentViewRouter(presenter: presenter, view: view)
        let interactor = ContentViewInteractor(presenter: presenter, viewModel: viewModel)
        presenter.router = router
        presenter.interactor = interactor
        presenter.view = view
        
        return view
    }
    
    @ViewBuilder
    func transitionBleListView(viewModel: BleMngViewModel) -> BleConnectableListView {
        
        BleConnectableListViewRouter.assembleModule(viewModel: viewModel)
    }
    
    func openSetting() {
        
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }

}
