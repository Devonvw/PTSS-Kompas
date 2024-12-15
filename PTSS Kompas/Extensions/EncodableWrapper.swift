//
//  EncodableWrapper.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct EncodableWrapper: Encodable {
    private let encodeFunction: (Encoder) throws -> Void

    init<T: Encodable>(_ wrapped: T) {
        self.encodeFunction = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunction(encoder)
    }
}
