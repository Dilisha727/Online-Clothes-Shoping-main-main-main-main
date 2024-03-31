import Foundation

struct UserLogin: Codable {
    var email: String
    var password: String
}

class UserLoginService {
    func loginUser(userLogin: UserLogin, completion: @escaping (Bool, String) -> Void) {
        guard let url = URL(string: "http://localhost:8000/users/login") else {
            completion(false, "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(userLogin)
        } catch {
            completion(false, "Error encoding login data")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false, "Login failed")
                return
            }

            completion(true, "Login successful")
        }.resume()
    }
}
