import Foundation

struct Profile {
    var image: Data?
    var name: String
    var surname: String
    var target: String
    var birthday: String
}

struct Task {
    let description: String
    let name: String
    let time: Int
    let taskBreak: Int
}
