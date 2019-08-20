import Foundation

// MARK: - Originator

public class User: Codable {
    public class UserState: Codable {
        public var name: String = "Mohamed Ali"
        public var email: String = "fakemail"
        public var achievement: Int = 0
    }

    public var state = UserState()


    public func updateUserAchievements() {
        state.achievement += 4
    }
}

// MARK: - Memento
typealias UserMemento = Data


// MARK: - CareTaker
public class UserSystem {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let userDefaults = UserDefaults.standard

    public func save(_ user: User, title: String) throws {
        let data = try encoder.encode(user)
        userDefaults.set(data, forKey: title)
    }

    public func load(title: String) throws -> User {
        guard let data = userDefaults.data(forKey: title),
            let user = try? decoder.decode(User.self, from: data)
            else {
                throw Error.gameNotFound
        }
        return user
    }

    public enum Error: String, Swift.Error {
        case gameNotFound
    }
}


var user = User()
user.updateUserAchievements()

let userSystem = UserSystem()
try userSystem.save(user, title: "CurrentUser")

// wipe current user achievements i.e (new game)
user = User()
print("Current User Achievement Score \(user.state.achievement)")

user = try userSystem.load(title: "CurrentUser")
print("New User Achievement Score: \(user.state.achievement)")

