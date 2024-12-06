//
//  QuestionnaireService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import Foundation

final class QuestionnaireService {
    let baseURL = "questionnaires/"
    
    func getQuestionnaires(cursor: String?, search: String?, completion: @escaping (Result<PaginatedResponse<Questionnaire>, NSError>) -> Void) {
        let parameters: [String: String?] = ["cursor": cursor, "pageSize": "100", "search": search]
        
        NetworkManager.shared.request(
            endpoint: baseURL,
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<Questionnaire>.self,
            completion: completion
        )
    }
    
    func getQuestionnaireExplanation(questionnaireId: String, completion: @escaping (Result<[QuestionnaireSubQuestion], NSError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "\(questionnaireId)/explanation",
            method: .GET,
            responseType: [QuestionnaireSubQuestion].self,
            completion: completion
        )
    }
    
    func getQuestionnaireGroups(questionnaireId: String, completion: @escaping (Result<[QuestionnaireGroup], NSError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "\(questionnaireId)/groups",
            method: .GET,
            responseType: [QuestionnaireGroupResponse].self
        ) { result in
            switch result {
            case .success(let questionnaireGroupsResponse):
                let questionnaireGroups = questionnaireGroupsResponse.map { QuestionnaireGroup.map(response: $0) }
                completion(.success(questionnaireGroups))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getQuestionnaireQuestions(questionnaireId: String, groupId: String, completion: @escaping (Result<[QuestionnaireQuestion], NSError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "\(questionnaireId)/groups/\(groupId)/questions",
            method: .GET,
            responseType: [QuestionnaireQuestion].self,
            completion: completion
        )
    }
    
    func saveQuestionAnswers(answers: [SaveQuestionAnswerRequest], completion: @escaping (Result<ContactQuestion, NSError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL,
            method: .POST,
            body: answers,
            responseType: ContactQuestion.self,
            completion: completion
        )
    }
}
