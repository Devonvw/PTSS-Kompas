//
//  OTPField.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 15/12/2024.
//

import SwiftUI
import Combine


// A SwiftUI view for entering OTP (One-Time Password).
struct OTPField: View {
    
    @FocusState private var pinFocusState: FocusPin?
    @Binding private var otp: String
    @State private var pins: [String]
    
    var numberOfFields: Int
    
    enum FocusPin: Hashable {
        case pin(Int)
    }
    
    init(numberOfFields: Int, otp: Binding<String>) {
        self.numberOfFields = numberOfFields
        self._otp = otp
        self._pins = State(initialValue: Array(repeating: "", count: numberOfFields))
    }
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(0..<numberOfFields, id: \.self) { index in
                TextField("", text: $pins[index])
                    .modifier(OtpModifier(pin: $pins[index]))
                    .foregroundColor(.dark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.dark, lineWidth: 2)
                    )
                    .onChange(of: pins[index]) { oldVal, newVal in
                        if newVal.count == 1 {
                            if index < numberOfFields - 1 {
                                pinFocusState = FocusPin.pin(index + 1)
                            }
                        } else if newVal.count == numberOfFields, let intValue = Int(newVal) {
                            // Handle pasted value
                            otp = newVal
                            updatePinsFromOTP()
                            pinFocusState = FocusPin.pin(numberOfFields - 1)
                        } else if newVal.isEmpty {
                            if index > 0 {
                                pinFocusState = FocusPin.pin(index - 1)
                            }
                        }
                        updateOTPString()
                    }
                    .focused($pinFocusState, equals: FocusPin.pin(index))
                    .onTapGesture {
                        // Set focus to the current field when tapped
                        pinFocusState = FocusPin.pin(index)
                    }
            }
        }
        .onAppear {
            // Initialize pins based on the OTP string
            updatePinsFromOTP()
        }
    }
    
    private func updatePinsFromOTP() {
        let otpArray = Array(otp.prefix(numberOfFields))
        for (index, char) in otpArray.enumerated() {
            pins[index] = String(char)
        }
    }
    
    private func updateOTPString() {
        otp = pins.joined()
    }
}

struct OtpModifier: ViewModifier {
    @Binding var pin: String
    
    var textLimit = 1
    
    func limitText(_ upper: Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) { _ in limitText(textLimit) }
            .frame(width: 40, height: 48)
            .font(.system(size: 18))
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}

struct OTPFieldView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("VERIFICATION CODE")
                .foregroundColor(Color.gray)
                .font(.system(size: 12))
            OTPField(numberOfFields: 5, otp: .constant("54321"))
                .previewLayout(.sizeThatFits)
        }
    }
}


