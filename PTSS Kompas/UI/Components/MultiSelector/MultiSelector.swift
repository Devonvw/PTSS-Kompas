//
//  MultiSelector.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 29/12/2024.
//

import SwiftUI

struct MultiSelector<LabelView: View, Selectable: Identifiable & Hashable>: View {
    let label: LabelView
    let options: [Selectable]
    let optionToString: (Selectable) -> String
    
    var selected: Binding<Set<Selectable>>
    @State var shouldShowSelectionView = false
    
    private var formattedSelectedListString: String {
        ListFormatter.localizedString(byJoining: selected.wrappedValue.map { optionToString($0) })
    }
    
    var body: some View {
        Button(action: {
            shouldShowSelectionView = true
        }, label: {HStack {
            label
            Spacer()
            Text(formattedSelectedListString)
                .foregroundColor(.gray)
                .multilineTextAlignment(.trailing)
        }}
        ).sheet(isPresented: $shouldShowSelectionView) {
            multiSelectionView()
        }
    }
    
    private func multiSelectionView() -> some View {
        MultiSelectionView(
            options: options,
            optionToString: optionToString,
            selected: selected
        )
    }
}

struct MultiSelector_Previews: PreviewProvider {
    struct IdentifiableString: Identifiable, Hashable {
        let string: String
        var id: String { string }
    }
    
    @State static var selected: Set<IdentifiableString> = Set(["A", "C"].map { IdentifiableString(string: $0) })
    
    static var previews: some View {
        NavigationView {
            Form {
                MultiSelector<Text, IdentifiableString>(
                    label: Text("Multiselect"),
                    options: ["A", "B", "C", "D"].map { IdentifiableString(string: $0) },
                    optionToString: { $0.string },
                    selected: $selected
                )
            }.navigationTitle("Title")
        }
    }
}
