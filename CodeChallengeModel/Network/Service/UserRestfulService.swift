//
//  UserRestfulService.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation
import Combine

class UserRestfulService: UserService {
    
    let router: Router
    private(set) var nextPage: Int = 1
    private static let decoder = JSONDecoder()
    private static let background = DispatchQueue.global(qos: .default)
    
    enum Endpoint {
        case fetch(page: Int?)
        case create(user: UserDTO)
        case delete(id: String)
    }
    
    init(router: Router = URLSessionRouter()) {
        self.router = router
    }
    
    private func advancePage() {
        nextPage += 1
    }
    
    func fetchNextPage() -> AnyPublisher<[User], APIError.User> {
        guard let request = Endpoint.fetch(page: nextPage).urlRequest else {
            return Fail<[User], APIError.User>(error: .network).eraseToAnyPublisher()
        }
        
        return router
            .dataTaskPublisher(for: request)
            .receive(on: Self.background)
            .map(\.data)
            .tryMap{ data -> UserFetchResponseSuccessDTO in
                do {
                    return try Self.decoder.decode(UserFetchResponseSuccessDTO.self, from: data)
                } catch {
                    throw (try? Self.decoder.decode(UserReponseErrorDTO.self, from: data).error) ?? APIError.User.network
                }
            }
            .map(\.data)
            .map{ $0.map{User(dto: $0)} }
            .mapError {
                switch $0 {
                case is URLError: return .network
                case is APIError.User: return $0 as! APIError.User
                default: return .network
                }
            }
            .receive(on: DispatchQueue.main)
            .handleEvents( receiveOutput: {[unowned self] _ in self.advancePage()})
            .eraseToAnyPublisher()
    }
    
    func delete(user: User) -> AnyPublisher<Void, APIError.User> {
        guard let request = Endpoint.delete(id: "\(user.id)").urlRequest else {
            return Fail<Void, APIError.User>(error: .network).eraseToAnyPublisher()
        }
        return router
            .dataTaskPublisher(for: request)
            .receive(on: Self.background)
            .map(\.data)
            .tryMap{ data -> Void in
                do {
                    let response = try Self.decoder.decode(UserDeleteReponseSuccessDTO.self, from: data)
                    guard case 200...204 = response.code else {
                        throw (try? Self.decoder.decode(UserReponseErrorDTO.self, from: data).error) ?? APIError.User.network
                    }
                    return
                } catch {
                    throw (try? Self.decoder.decode(UserReponseErrorDTO.self, from: data).error) ?? APIError.User.network
                }
            }
            .mapError {
                switch $0 {
                case is URLError: return .network
                case is APIError.User: return $0 as! APIError.User
                default: return .network
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(user: User) -> AnyPublisher<User, APIError.User> {
        guard let request = Endpoint.create(user: UserDTO(from: user)).urlRequest else {
            return Fail<User, APIError.User>(error: .network).eraseToAnyPublisher()
        }

        return router
            .dataTaskPublisher(for: request)
            .receive(on: Self.background)
            .map(\.data)
            .tryMap{ data -> UserCreateReponseSuccessDTO in
                do {
                    return try Self.decoder.decode(UserCreateReponseSuccessDTO.self, from: data)
                } catch {
                    throw (try? Self.decoder.decode(UserReponseErrorDTO.self, from: data).error) ?? APIError.User.network
                }
            }
            .map(\.data)
            .map{ User(dto: $0) }
            .mapError {
                switch $0 {
                case is URLError: return .network
                case is APIError.User: return $0 as! APIError.User
                default: return .network
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
