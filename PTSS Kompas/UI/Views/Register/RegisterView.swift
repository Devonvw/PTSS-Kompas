//
//  RegisterView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 19/11/2024.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()

    var body: some View {
        VStack {
            Image("LogoFull")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            
                Text("Welkom") .font(.largeTitle)
                    .foregroundColor(.dark)
                Text("Vul je e-mailadres en de 6-cijferige code in die je per e-mail hebt ontvangen om te beginnen met PTSS Kompas.")
                    .font(.subheadline)
                    .foregroundColor(.dark)
                    .padding(.bottom, 10).multilineTextAlignment(.center)
            
            VStack {
                Group {
                    switch viewModel.currentScreen {
                    case .Verify:
                        RegisterVerifyView(registerViewModel: viewModel)
                    case .Name:
                        RegisterVerifyView(registerViewModel: viewModel)
                    case .Password:
                        RegisterVerifyView(registerViewModel: viewModel)
                    case .Pin:
                        RegisterVerifyView(registerViewModel: viewModel)
                    }
                }
            }.frame(maxHeight: .infinity)
            
            Spacer()
            
//            Form {
////                Section
////                {
////                    VStack(alignment: .leading) {
////                        Text("Onderwerp")
////                        TextField(
////                            "Kort onderwerp van je vraag..",
////                            text: $viewModel.newQuestionSubject,
////                            axis: .vertical
////                        )
////                        .lineLimit(1...3)
////                        .padding(12)
////                        .overlay(
////                            RoundedRectangle(cornerRadius: 5)
////                                .stroke(Color.dark, lineWidth: 2)
////                        )
////                    }
////                    VStack(alignment: .leading) {
////                        Text("Beschrijving")
////                        TextField(
////                            "Beschrijf je vraag of situatie in detail..",
////                            text: $viewModel.newQuestionContent,
////                            axis: .vertical
////                        )
////                        .lineLimit(4...10)
////                        .padding(12)
////                        .overlay(
////                            RoundedRectangle(cornerRadius: 5)
////                                .stroke(Color.dark, lineWidth: 2)
////                        )
////                    }
////                    
////                } footer: {
////                    if case .validation(let err) = viewModel.error,
////                       let errorDesc = err.errorDescription {
////                        Text(errorDesc)
////                            .foregroundStyle(.red)
////                    }
////                }
//            }.padding(0)
//                .background(.clear)
//                .scrollContentBackground(.hidden)
//            
//           
//            ButtonVariant(label: "Ga verder", disabled: true) {}
//            Text("Heb je geen 6-cijferige code ontvangen? Neem dan contact op met de persoon die jou heeft uitgenodigd.").multilineTextAlignment(.center).padding(.bottom, 10).font(.caption).foregroundColor(.dark.opacity(0.8))
//            Text("Heb je al een account").multilineTextAlignment(.center).font(.caption).foregroundColor(.dark.opacity(0.8))
//            ButtonVariant(label: "Inloggen met email", variant: .light) {}
        }.padding()
            
        
        
//        Form {
//            Section
//            {
//                VStack(alignment: .leading) {
//                    Text("Onderwerp")
//                    TextField(
//                        "Kort onderwerp van je vraag..",
//                        text: $viewModel.newQuestionSubject,
//                        axis: .vertical
//                    )
//                    .lineLimit(1...3)
//                    .padding(12)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color.dark, lineWidth: 2)
//                    )
//                }
//                VStack(alignment: .leading) {
//                    Text("Beschrijving")
//                    TextField(
//                        "Beschrijf je vraag of situatie in detail..",
//                        text: $viewModel.newQuestionContent,
//                        axis: .vertical
//                    )
//                    .lineLimit(4...10)
//                    .padding(12)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color.dark, lineWidth: 2)
//                    )
//                }
//                
//            } footer: {
//                if case .validation(let err) = viewModel.error,
//                   let errorDesc = err.errorDescription {
//                    Text(errorDesc)
//                        .foregroundStyle(.red)
//                }
//            }
//        }.padding(0)
//            .background(.clear)
//            .scrollContentBackground(.hidden)
//            .alert(isPresented: $viewModel.isAlertFailure, error: viewModel.error) { }
//            .overlay {
//                if viewModel.isLoading {
//                    ProgressView()
//                }
//            }
        //            .navigationTitle("Stel een nieuwe vraag")
        //            .toolbar {
        //                ToolbarItem(placement: .primaryAction) {
        //                    Button("Klaar") {
        //                        dismiss()
        //                    }
        //                    .accessibilityIdentifier("doneBtn")
        //                }
        //            }
//        HStack {
//            ButtonVariant(label: "Stel nieuwe vraag") {
//                viewModel.addQuestion {
//                    dismiss()
//                }
//            }
//        }.padding()
    }
}

#Preview {
    RegisterView()
}
