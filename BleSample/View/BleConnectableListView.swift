//
//  BleConnectableListView.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/22.
//

import SwiftUI

struct BleConnectableListView: View {
    
    @Environment(\.dismiss) var dissmiss
    @ObservedObject var viewModel: BleMngViewModel
    var presenter: BleConnectableListViewPresentation
    
    init(viewModel: BleMngViewModel, presenter: BleConnectableListViewPresentation) {
        self.viewModel = viewModel
        self.presenter = presenter
    }
    
    var body: some View {
        
        NavigationView {
            createChildView()
                .navigationTitle(Text("bluetooth接続リスト"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            
                            // 前画面への遷移
                            dissmiss()
                        } label: {
                            Text("戻る")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        Button {
                            
                            presenter.reloadList()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
        }
        .onAppear{
            
            presenter.didApearView()
        }
        .onDisappear{
            
            presenter.willDisapearView()
        }
    }
    
    @ViewBuilder
    func createChildView() -> some View {
        List{
            
            ForEach(viewModel.peripheralsModels) { model in
                
                NavigationLink(destination: presenter.tappedPeripheral(model: model)) {
                    
                    createItemCell(model: model)
                }
                .listRowInsets(.init(top: 0, leading: 10, bottom: 0, trailing: 10))
            }
        }
        .listStyle(.grouped)
        .environment(\.defaultMinListRowHeight, 50)
    }
    
    @ViewBuilder
    func createItemCell(model: BlePeripheralEntity) -> some View{
        
        HStack(alignment: .center) {
            
            Text(model.name)
            
            Spacer()
            
            Image(systemName: model.peripheral.state == .connected ? "line.3.horizontal.decrease.circle" : "circle.slash")
        }
    }
}

struct BleConnectableListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        BleConnectableListViewRouter.assembleModule(viewModel: BleMngViewModel())
    }
}
