//
//  QuestionnaireService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import Foundation

final class QuestionnaireService {
    let baseURL = URL(string: "https://virtserver.swaggerhub.com/652543_1/PTSS-SUPPORT/1.0.0/")!
    
    func getQuestionnaires(completion: @escaping (Result<[Questionnaire], Error>) -> Void) {
        let url = URL(string: "questionnaires", relativeTo: baseURL)
        
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
                print(data)
                let questionnaires = try JSONDecoder().decode([Questionnaire].self, from: data)
                completion(.success(questionnaires))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getQuestionnaireExplanation(questionnaireId: String, completion: @escaping (Result<QuestionnaireExplanation, Error>) -> Void) {
        let url = URL(string: "questionnaires/\(questionnaireId)/explanation", relativeTo: baseURL)
        
        guard let url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Er is iets fout gegaan."])))
            return
        }
        
        print(url.absoluteString)
        
                
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
                print(data)
                let questionnaire = try JSONDecoder().decode(QuestionnaireExplanation.self, from: data)
                completion(.success(questionnaire))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getQuestionnaireGroups(questionnaireId: String, completion: @escaping (Result<[QuestionnaireGroup], Error>) -> Void) {
        let url = URL(string: "questionnaires/\(questionnaireId)/groups", relativeTo: baseURL)
        
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
                print(data)
                let questionnaireGroups = try JSONDecoder().decode([QuestionnaireGroup].self, from: data)
                completion(.success(questionnaireGroups))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
