//
//  ContentView.swift
//  BleSample
//
//  Created by 佐藤汰一 on 2023/06/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: BleMngViewModel
    var presenter: ContentViewPresenter
    
    @State var isPresentedNextView = false
    @State var isShowAlert = false
    
    init(viewModel: BleMngViewModel, presenter: ContentViewPresenter) {
        self.viewModel = viewModel
        self.presenter = presenter
    }
    
    private let buttonSideMargin: CGFloat = 20.0
    
    var body: some View {
        
        ZStack {
            
            if viewModel.isBlePoweredOn {
                NavigationView {
                    
                    GeometryReader { proxy in
                        
                        VStack {
                            
                            Spacer()
                            Text("Bluetooth接続可能機器を探しています")
                                .font(.title)
                                .foregroundColor(.gray)
                            Spacer(minLength: 40)
                            
                            if viewModel.scanPeripheralStatus == .scaning {
                                
                                UtilityViews(viewType: .indicater)
                                Spacer()
                            } else {
                                
                                Button {
                                    
                                    presenter.tappedScanButton()
                                } label: {
                                    
                                    Text("スキャン開始")
                                        .lineLimit(1)
                                        .frame(minWidth: 150)
                                        .padding()
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.gray)
                                        .background(.cyan)
                                        .cornerRadius(16)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding()
                    }
                }
            }
            else{
                ZStack{
                    
                    Color(uiColor: .lightGray)
                        .ignoresSafeArea()
                        .opacity(0.7)
                    
                    VStack(alignment: .center) {
                        
                        Spacer()
                        
                        UtilityViews(viewType: .indicater)
                        
                        Spacer()
                    }
                }
            }
        }
        .alert("BluetoothをONにしてください", isPresented: $isShowAlert, actions: {
            
            Button("キャンセル") { isShowAlert.toggle() }
            Button("設定") {
                
                isShowAlert.toggle()
                presenter.tappedSettingButton()
            }
        })
        .onAppear{
            
            presenter.didApearView()
        }
        .onDisappear{
            
            // 遷移時に画面遷移用のフラグを倒す
            isPresentedNextView.toggle()
            
            presenter.willDisapearView()
        }
        .onChange(of: viewModel.isDiscoveredPeripherals, perform: { newValue in
            
            if newValue && !isPresentedNextView {
                
                isPresentedNextView.toggle()
                print("isPresentedNextView: \(isPresentedNextView)")
            }
        })
        .onChange(of: viewModel.alertType, perform: { newValue in
            
            if newValue == .bleSetting {
                isShowAlert.toggle()
                viewModel.alertType = .none
            }
        })
        .fullScreenCover(isPresented: $isPresentedNextView) {
            
            presenter.transitionNextViewPresent()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentViewRouter.assembleModule(viewModel: makeViewModel())
    }
    
    static func makeViewModel() -> BleMngViewModel {
        
        var viewModel = BleMngViewModel()
        viewModel.isBlePoweredOn = true
        viewModel.scanPeripheralStatus = .stop
                
        return viewModel
    }
}
