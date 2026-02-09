//
//  PokemonListView.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/05.
//
import SwiftUI

/// ポケモン一覧画面のView
struct PokemonListView: View {
    @StateObject var presenter: PokemonListPresenter
    @State private var hasLoaded = false

    var body: some View {
        VStack(spacing: 0) {
            // 検索バー
            SearchBar(text: $presenter.searchQuery)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            // コンテンツ
            content
        }
        .navigationTitle("Pokemon")
        .task {
            if !hasLoaded {
                await presenter.loadInitialData()
                hasLoaded = true
            }
        }
    }
        
    @ViewBuilder
    private var content: some View {
        switch presenter.viewState {
        case .initial:
            Color.clear
            
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .success(let pokemons, let hasMore, let isLoadingMore):
            PokemonGridView(
                pokemons: pokemons,
                hasMore: hasMore,
                isLoadingMore: isLoadingMore) { pokemon in
                    presenter.onPokemonTapped(pokemon)
                } onLoadMore: {
                    Task {
                        await presenter.loadMorePokemons()
                    }
                }

        case .error(let message):
            ErrorView(
                message: message,
                onRetry: {
                    Task {
                        await presenter.onRetryTapped()
                    }
                }
            )
        }
    }
}


/// 検索バー
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        TextField("Search Pokemon", text: $text)
            .textFieldStyle(PlainTextFieldStyle())
    }
}

/// ポケモン一覧グリッド
struct PokemonGridView: View {
    let pokemons: [Pokemon]
    let hasMore: Bool
    let isLoadingMore: Bool
    let onPokemonTapped: (Pokemon) -> Void
    let onLoadMore: () -> Void
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(pokemons) { pokemon in
                    PokemonCard(pokemon: pokemon)
                        .onTapGesture {
                            onPokemonTapped(pokemon)
                        }
                        .onAppear() {
                            // 最後から3番目の要素が表示されたら追加読み込み
                            if let index = pokemons.firstIndex(where: { $0.id == pokemon.id }),
                               index >= pokemons.count - 3,
                               hasMore && !isLoadingMore {
                                onLoadMore()
                            }
                        }
                }
                
                // ローディングインジケーター
                if isLoadingMore {
                    VStack {
                        ProgressView()
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    .gridCellColumns(2)
                }
            }
            .padding(16)
        }
    }
}

/// ポケモンカード
struct PokemonCard: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack(spacing: 8) {
            // ポケモンの画像
            AsyncImage(url: URL(string: pokemon.imageUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 120, height: 120)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            
            // ポケモン情報
            VStack(spacing: 4) {
                Text(pokemon.idFormatted)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(pokemon.displayName)
                    .font(.headline)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

/// エラー表示
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
    
