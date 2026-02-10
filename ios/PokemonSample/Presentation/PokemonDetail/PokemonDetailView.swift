//
//  PokemonDetailView.swift
//  PokemonSample
//
//  Created by ponro on 2026/02/09.
//

import SwiftUI

/// ポケモン詳細画面のView
struct PokemonDetailView: View {
    @StateObject var presenter: PokemonDetailPresenter
    
    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await presenter.loadPokemonDetail()
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
        case .success(let pokemon):
            PokemonDetailContent(pokemon: pokemon)
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

/// ポケモン詳細コンテンツ
struct PokemonDetailContent: View {
    let pokemon: PokemonDetail
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // ヘッダー（画像とID）
                PokemonHeader(pokemon: pokemon)
                
                // タイプ
                PokemonTypes(types: pokemon.types)
                
                // 基本情報
                PokemonBasicInfo(pokemon: pokemon)
                
                // ステータス
                PokemonStats(stats: pokemon.stats)
                
                // Shiny Form
                if let shinyUrl = pokemon.sprites.frontShiny {
                    PokemonShinyForm(shinyUrl: shinyUrl)
                }
            }
            .padding(16)
        }
        .navigationTitle(pokemon.displayName)
    }
}

/// ヘッダー（画像とID）
struct PokemonHeader: View {
    let pokemon: PokemonDetail
    
    var body: some View {
        VStack(spacing: 12) {
            // ID
            Text(pokemon.idFormatted)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                
            // 画像
            AsyncImage(url: URL(string: pokemon.sprites.frontDefault ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 200, height: 200)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            LinearGradient(
                colors: [
                    pokemon.types.first.map { typeColor(for: $0.name) } ?? .gray.opacity(0.2),
                    Color(.systemBackground)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(16)
    }
}

/// タイプ表示
struct PokemonTypes: View {
    let types: [PokemonType]
    
    var body: some View {
        HStack {
            ForEach(types.sorted(by: { $0.slot < $1.slot }), id: \.name) { type in
                Text(type.displayName)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(typeColor(for: type.name))
                    .cornerRadius(20)
            }
        }
    }
}

/// 基本情報カード
struct PokemonBasicInfo: View {
    let pokemon: PokemonDetail
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Basic Info").font(.headline)
            
            Divider()
            
            InfoRow(label: "Height", value: pokemon.heightInMeters)
            InfoRow(label: "Weight", value: pokemon.weightInKg)
            
            if !pokemon.abilities.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Abilities")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ForEach(pokemon.abilities, id: \.self) { ability in
                        Text("• \(ability)").font(.body)
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

}

/// ステータス表示
struct PokemonStats: View {
    let stats: [PokemonStat]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Stats").font(.headline)
            
            Divider()
            
            ForEach(stats, id: \.name) { stat in
                StatBar(stat: stat)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

/// ステータスバー
struct StatBar: View {
    let stat: PokemonStat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(stat.displayName)
                    .font(.subheadline)
                    .frame(maxWidth: 100, alignment: .leading)
                
                Text("\(stat.baseStat)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 40, alignment: .trailing)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        Rectangle()
                            .fill(statColor(for: stat.baseStat))
                            .frame(width: geometry.size.width * stat.percentage, height: 8)
                    }
                    .cornerRadius(4)
                }
                .frame(height: 8)
            }
        }
    }
    
    private func statColor(for value: Int) -> Color {
        switch value {
        case 0..<50: return .red
        case 50..<80: return .orange
        case 80..<120: return .yellow
        default: return .green
        }
    }
}

/// Shiny Form
struct PokemonShinyForm: View {
    let shinyUrl: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Shiny Form").font(.headline)
            
            Divider()
            
            AsyncImage(url: URL(string: shinyUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 150, height: 150)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

/// 情報行
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

/// タイプカラーマッピング
func typeColor(for type: String) -> Color {
    switch type.lowercased() {
    case "normal": return Color(red: 168/255, green: 168/255, blue: 120/255)
    case "fire": return Color(red: 240/255, green: 128/255, blue: 48/255)
    case "water": return Color(red: 104/255, green: 144/255, blue: 240/255)
    case "electric": return Color(red: 248/255, green: 208/255 , blue: 48/255)
    case "grass": return Color(red: 120/255, green: 200/255, blue: 80/255)
    case "ice": return Color(red: 152/255, green: 216/255, blue: 216/255)
    case "fighting": return Color(red: 192/255, green: 48/255, blue: 40/255)
    case "poison": return Color(red: 160/255, green: 64/255, blue: 160/255)
    case "ground": return Color(red: 224/255, green: 192/255, blue: 104/255)
    case "flying": return Color(red: 168/255, green: 144/255, blue: 240/255)
    case "psychic": return Color(red: 248/255, green: 88/255, blue: 136/255)
    case "bug": return Color(red: 168/255, green: 184/255, blue: 32/255)
    case "rock": return Color(red: 184/255, green: 160/255, blue: 56/255)
    case "ghost": return Color(red: 112/255, green: 88/255, blue: 152/255)
    case "dragon": return Color(red: 112/255, green: 56/255, blue: 248/255)
    case "dark": return Color(red: 112/255, green: 88/255, blue: 72/255)
    case "steel": return Color(red: 184/255, green: 184/255, blue: 208/255)
    case "fairy": return Color(red: 238/255, green: 153/255, blue: 172/255)
    default: return .gray
    }
}
