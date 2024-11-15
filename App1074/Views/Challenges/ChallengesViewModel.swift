import Foundation
import Combine

final class ChallengesViewModel: ObservableObject {
    
    let dm: DataManager
    
    @Published var challenges: Array<Challenge>
    
    private var challengesCancellable: AnyCancellable?
    
    init(dm: DataManager) {
        self.dm = dm
        
        challenges = dm.challenges
        
        challengesCancellable = dm.$challenges.sink { [weak self] value in
            self?.challenges = value
        }
    }
    
    func accept(_ challenge: Challenge) {
        dm.accept(challenge)
    }
    
    func complete(_ challenge: Challenge) {
        dm.complete(challenge)
    }
}
