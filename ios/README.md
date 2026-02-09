# Pokemon App - iOS VIPER Architecture


PokeAPIを使用したポケモン図鑑アプリ（iOS版）です。Android版と同じ仕様でVIPERアーキテクチャを採用しています。


## アーキテクチャ


**VIPER (View, Interactor, Presenter, Entity, Router)**


## 技術スタック


- **言語**: Swift
- **UIフレームワーク**: SwiftUI
- **アーキテクチャパターン**: VIPER
- **依存性注入**: Manual DI (DependencyContainer)
- **非同期処理**: Swift Concurrency (async/await)
- **ネットワーク**: URLSession
- **画像読み込み**: AsyncImage (SwiftUI標準)
- **ナビゲーション**: NavigationStack (SwiftUI)


## 機能


### 実装済み
- ✅ ポケモン一覧表示（無限スクロール）
- ✅ ポケモン詳細表示
- ✅ 検索機能（名前・ID）
- ✅ タイプ別カラー表示
- ✅ ステータス表示
- ✅ Shiny Form表示


## プロジェクト構造


```
PokemonApp/
├── PokemonApp.swift           # アプリエントリーポイント
├── DI/
│   └── DependencyContainer.swift
├── Data/                      # Data Layer
│   ├── Mapper/                # DTO → Entity 変換
│   ├── Remote/                # API & DTO
│   │   ├── API/
│   │   │   └── PokeAPIService.swift
│   │   └── DTO/
│   │       └── PokemonResponse.swift
│   └── Repository/            # Repository 実装
│       └── PokemonRepositoryImpl.swift
├── Domain/                    # Domain Layer
│   ├── Entity/                # ドメインモデル
│   │   ├── Pokemon.swift
│   │   ├── PokemonDetail.swift
│   │   └── Result.swift
│   ├── Interactor/            # ビジネスロジック (UseCase)
│   │   ├── GetPokemonListInteractor.swift
│   │   ├── GetPokemonDetailInteractor.swift
│   │   └── SearchPokemonInteractor.swift
│   └── Repository/            # Repository インターフェース
│       └── PokemonRepository.swift
└── Presentation/              # Presentation Layer
   ├── Navigation/
   │   └── AppRouter.swift
   ├── PokemonList/           # ポケモン一覧画面
   │   ├── PokemonListView.swift
   │   ├── PokemonListPresenter.swift
   │   └── PokemonListViewState.swift
   └── PokemonDetail/         # ポケモン詳細画面
       ├── PokemonDetailView.swift
       ├── PokemonDetailPresenter.swift
       └── PokemonDetailViewState.swift
```


## VIPERアーキテクチャのデータフロー


```
User Action (View)
   ↓
Event Handler (Presenter)
   ↓
Business Logic (Interactor)
   ↓
Data Access (Repository)
   ↓ ← PokeAPI
Result Processing (Interactor)
   ↓
Entity → ViewState 変換 (Presenter)
   ↓
UI Render (View)
```


## Android vs iOS の実装対応


| Android | iOS |
|---------|-----|
| Jetpack Compose | SwiftUI |
| ViewModel | @MainActor ObservableObject |
| StateFlow | @Published |
| sealed interface | enum |
| Hilt DI | Manual DI (DependencyContainer) |
| Coroutines | async/await |
| Retrofit2 | URLSession |
| Coil | AsyncImage |
| Navigation Compose | NavigationStack |


## セットアップ


### 必要要件
- Xcode 15.0 以降
- iOS 17.0 以降
- Swift 5.9


### ビルド手順


#### Xcodeでビルド・実行
1. プロジェクトをXcodeで開く
  ```bash
  open PokemonApp.xcodeproj
  ```
2. シミュレーターまたは実機を選択（iPhone 17以降推奨）
3. ⌘R でビルド＆実行


#### コマンドラインでビルド・実行
```bash
# ビルド
xcodebuild -project PokemonApp.xcodeproj -scheme PokemonApp -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17' build


# シミュレーターで起動
xcrun simctl boot "iPhone 17"  # シミュレーターを起動
xcrun simctl install booted ./build/Build/Products/Debug-iphonesimulator/PokemonApp.app  # アプリをインストール
xcrun simctl launch booted com.iti.develop.PokemonApp  # アプリを起動
```


### 注意事項
- プロジェクトには `PokemonApp.swift` が本体のAppファイルです
- `ContentView.swift` と `PokemonAppApp.swift` は自動生成ファイルのため削除済みです
- iOS 26.1 (Xcode最新版) でテスト済み


## API


[PokeAPI](https://pokeapi.co/) を使用
- ベースURL: `https://pokeapi.co/api/v2/`
- エンドポイント:
 - `GET /pokemon?limit=20&offset=0` - ポケモン一覧
 - `GET /pokemon/{name}` - ポケモン詳細


## VIPERの利点


### 責務の分離
- **View**: UIの描画のみ
- **Interactor**: ビジネスロジックのみ
- **Presenter**: プレゼンテーションロジックとState管理
- **Entity**: ドメインモデル
- **Router**: ナビゲーション制御


### テスタビリティ
各コンポーネントが独立しているため、個別にテスト可能


### 再利用性
Interactorは複数の画面で再利用可能


### 保守性
変更の影響範囲が限定的


## SwiftUI + VIPER のポイント


1. **@MainActor**: Presenterに付与してメインスレッドで実行
2. **ObservableObject**: SwiftUIの状態管理と統合
3. **@Published**: ViewStateの変更を自動的にViewに通知
4. **async/await**: Swift Concurrencyで非同期処理を簡潔に記述
5. **NavigationStack**: iOS 16+の新しいナビゲーションシステム


## ライセンス


MIT License


## 参考資料


- [PokeAPI Documentation](https://pokeapi.co/docs/v2)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)