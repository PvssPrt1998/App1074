import Foundation

struct Achievement: Hashable {
    var lockedTitle: String
    var title: String
    var reward: Int
    var blocked: Bool
    var earned: Bool
}

struct Challenge: Hashable {
    let title: String
    let time: String
    let points: Int
    let levelForUnlock: Int
    var accepted: Bool
    var completed: Bool
}
