//
//  ContactService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

import Foundation

final class ContactService {
    let baseURL = URL(string: "https://virtserver.swaggerhub.com/652543_1/PTSS-SUPPORT/1.0.0/contact/")!
    
    func getContactQuestions(cursor: String?, search: String?, completion: @escaping (Result<PaginatedResponse<ContactQuestion>, Error>) -> Void) {
        let parameters: [String: String?] = ["cursor": cursor, "pageSize": "100", "search": search]
        
        guard let url = baseURL.appendingQueryParameters(parameters) else {
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
                let contactQuestionsResponse = try JSONDecoder().decode(PaginatedResponse<ContactQuestion>.self, from: data)
                print(contactQuestionsResponse)
                completion(.success(contactQuestionsResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getContactQuestionMessages(questionId: String, cursor: String?, search: String?, completion: @escaping (Result<PaginatedResponse<ContactQuestionMessage>, Error>) -> Void) {
        let messagesUrl = URL(string: "\(questionId)/messages", relativeTo: baseURL)
        
        guard let messagesUrl else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Er is iets fout gegaan."])))
            return
        }
        
        let parameters: [String: String?] = ["cursor": cursor, "pageSize": "100", "search": search]
        
        guard let messagesUrl = messagesUrl.appendingQueryParameters(parameters) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Er is iets fout gegaan."])))
            return
        }
                
        URLSession.shared.dataTask(with: messagesUrl) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Er is iets fout gegaan."])))
                return
            }
            do {
//                let contactQuestionMessagesResponse = try JSONDecoder().decode(PaginatedResponse<ContactQuestionMessage>.self, from: data)
                completion(.success(PaginatedResponse<ContactQuestionMessage>.example))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
