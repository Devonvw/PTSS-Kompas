//
//  ContactService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

import Foundation

final class ContactService {
    let baseURL = URL(string: "https://virtserver.swaggerhub.com/652543_1/PTSS-SUPPORT/1.0.0/contact/")!
    
    func getContactQuestions(completion: @escaping (Result<[ContactQuestionsResponse], Error>) -> Void) {
        let url = URL(string: "", relativeTo: baseURL)
        
        guard let url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Er is iets fout gegaan."])))
            return
        }
        
                
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Er is iets fout gegaan."])))
                return
            }
            do {
                let contactQuestionsResponse = try JSONDecoder().decode([ContactQuestionsResponse].self, from: data)
                completion(.success(contactQuestionsResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getContactQuestionMessages(completion: @escaping (Result<[ContactQuestionMessagesResponse], Error>) -> Void) {
        let url = URL(string: "", relativeTo: baseURL)
        
        guard let url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Er is iets fout gegaan."])))
            return
        }
        
                
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Er is iets fout gegaan."])))
                return
            }
            do {
                let contactQuestionMessagesResponse = try JSONDecoder().decode([ContactQuestionMessagesResponse].self, from: data)
                completion(.success(contactQuestionMessagesResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
