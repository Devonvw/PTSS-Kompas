//
//  QuestionnaireService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import Foundation

final class QuestionnaireService {
    let baseURL = "questionnaires/"
    
    func getQuestionnaires(cursor: String?, search: String?, completion: @escaping (Result<PaginatedResponse<Questionnaire, Pagination>, NetworkError>) -> Void) {
        let parameters: [String: String?] = ["cursor": cursor, "pageSize": "100", "search": search]
        
        NetworkManager.shared.request(
            endpoint: baseURL,
            method: .GET,
            parameters: parameters,
            responseType: PaginatedResponse<Questionnaire, Pagination>.self,
            completion: completion
        )
    }
    
    func getQuestionnaireExplanation(questionnaireId: String, completion: @escaping (Result<QuestionnaireExplanation, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "\(questionnaireId)/explanation",
            method: .GET,
            responseType: QuestionnaireExplanationResponse.self
        )  { result in
            switch result {
            case .success(let questionnaireExplanationResponse):
                let questionnaireExplanation = QuestionnaireExplanation.map(response: questionnaireExplanationResponse)
                completion(.success(questionnaireExplanation))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getQuestionnaireGroups(questionnaireId: String, completion: @escaping (Result<[QuestionnaireGroup], NetworkError>) -> Void) {
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
    
    func getQuestionnaireQuestions(questionnaireId: String, groupId: Int, completion: @escaping (Result<[QuestionnaireQuestion], NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "\(questionnaireId)/groups/\(groupId)/questions",
            method: .GET,
            responseType: [QuestionnaireQuestionResponse].self
        ) { result in
            switch result {
            case .success(let questionnaireQuestionResponse):
                let questionnaireQuestions = questionnaireQuestionResponse.map { QuestionnaireQuestion.map(response: $0) }
                completion(.success(questionnaireQuestions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveQuestionAnswers(answers: [SaveQuestionAnswerRequest], completion: @escaping (Result<ContactQuestion, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL,
            method: .POST,
            body: answers,
            responseType: ContactQuestion.self,
            completion: completion
        )
    }
}
