//
//  UserRestfulService.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation
import Combine

class UserRestfulService: UserService {
    
    private var nextPage: Int = 0
    private static let decoder = JSONDecoder()
    private static let background = DispatchQueue.global(qos: .default)
    
    enum Endpoint {
        case fetch(page: Int?)
        case create(user: UserDTO)
        case delete(id: String)
    }
    
    private func advancePage() {
        nextPage += 1
    }
    
    func fetchNextPage() -> AnyPublisher<[User], User.Error> {
        guard let request = Endpoint.fetch(page: nextPage).urlRequest else {
            return Fail<[User], User.Error>(error: .network).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: Self.background)
            .map(\.data)
            .tryMap{ data -> UserFetchResponseSuccessDTO in
                do {
                    return try Self.decoder.decode(UserFetchResponseSuccessDTO.self, from: data)
                } catch {
                    throw (try? Self.decoder.decode(UserReponseErrorDTO.self, from: data).error) ?? User.Error.network
                }
            }
            .map(\.data)
            .map{ $0.map{User(dto: $0)} }
            .mapError {
                switch $0 {
                case is URLError: return .network
                case is User.Error: return $0 as! User.Error
                default: return .network
                }
            }
            .receive(on: DispatchQueue.main)
            .handleEvents( receiveOutput: {[unowned self] _ in self.advancePage()})
            .eraseToAnyPublisher()
    }
    
    func delete(user: User) -> AnyPublisher<Void, User.Error> {
        guard let request = Endpoint.delete(id: user.id).urlRequest else {
            return Fail<Void, User.Error>(error: .network).eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: Self.background)
            .map(\.data)
            .tryMap{ data -> UserDeleteReponseSuccessDTO in
                do {
                    return try Self.decoder.decode(UserDeleteReponseSuccessDTO.self, from: data)
                } catch {
                    throw (try? Self.decoder.decode(UserReponseErrorDTO.self, from: data).error) ?? User.Error.network
                }
            }
            .map(\.code)
            .tryMap { code -> Void in
                guard case 200...202 = code else {
                    throw User.Error.network
                }
            }
            .mapError {
                switch $0 {
                case is URLError: return .network
                case is User.Error: return $0 as! User.Error
                default: return .network
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func add(user: User) -> AnyPublisher<User, User.Error> {
        guard let request = Endpoint.create(user: UserDTO(from: user)).urlRequest else {
            return Fail<User, User.Error>(error: .network).eraseToAnyPublisher()
        }

        return URLSession.shared
            .dataTaskPublisher(for: request)
            .receive(on: Self.background)
            .map(\.data)
            .tryMap{ data -> UserCreateReponseSuccessDTO in
                do {
                    return try Self.decoder.decode(UserCreateReponseSuccessDTO.self, from: data)
                } catch {
                    throw (try? Self.decoder.decode(UserReponseErrorDTO.self, from: data).error) ?? User.Error.network
                }
            }
            .map(\.data)
            .map{ User(dto: $0) }
            .mapError {
                switch $0 {
                case is URLError: return .network
                case is User.Error: return $0 as! User.Error
                default: return .network
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
