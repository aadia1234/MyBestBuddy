

import SwiftUI

public struct Question {
    let title: String
    let choices: [String: Any]
    
    init(title: String, choices: [String: Any]) {
        self.title = title
        self.choices = choices
    }
}
