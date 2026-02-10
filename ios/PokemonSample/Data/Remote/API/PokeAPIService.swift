//
//  PokeAPIService.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//

import Foundation

/// PokeAPI のサービスクラス
protocol PokeAPIServiceProtocol {
    func getPokemonList(limit: Int, offset: Int) async throws -> PokemonListResponse
    func getPokemonDetail(id: Int) async throws -> PokemonDetailResponse
    func getPokemonDetailByName(name: String) async throws -> PokemonDetailResponse
}

class PokeAPIService: PokeAPIServiceProtocol {
    private let baseURL = "https://pokeapi.co/api/v2"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getPokemonList(limit: Int = 20, offset: Int = 0) async throws -> PokemonListResponse {
        let urlString = "\(baseURL)/pokemon?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidResponse
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.networkError
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(PokemonListResponse.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
    func getPokemonDetail(id: Int) async throws -> PokemonDetailResponse {
        let urlString = "\(baseURL)/pokemon/\(id)"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidResponse
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.networkError
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(PokemonDetailResponse.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
    func getPokemonDetailByName(name: String) async throws -> PokemonDetailResponse {
        let urlString = "\(baseURL)/pokemon/\(name)"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidResponse
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.networkError
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(PokemonDetailResponse.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}
