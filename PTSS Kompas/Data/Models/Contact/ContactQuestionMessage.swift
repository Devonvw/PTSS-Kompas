//
//  ContactQuestionAnswer.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

struct ContactQuestionMessage: Codable, Identifiable {
    let id: String
    let senderName: String
    let content: String
    let createdAt: String
    
    static let example: ContactQuestionMessage = .init(
        id: "1",
        senderName: "Joost",
        content: "Hoi! Als je naaste dissocieert tijdens een herbeleving, blijf dan vooral rustig. Zachtjes en vertrouwd spreken kan helpen, zoals \"Je bent veilig, ik ben hier.\" Benoem iets eenvoudigs uit hun omgeving: “Voel de stoel onder je.” Houd zinnen kort en concreet.\nFysiek contact kan soms helpen, zoals hun hand vasthouden, maar wees voorzichtig—niet iedereen vindt dat prettig tijdens dissociatie.\nHet belangrijkste is om geduldig te blijven en hen de tijd te geven om terug te komen. Jij doet al heel veel door er voor hen te zijn!\nAls je meer vragen hebt, laat het gerust weten! 😊",
        createdAt: "202-11-22T1:10:10Z"
    )
}
