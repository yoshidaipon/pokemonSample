# iOS Pokemon VIPER Architecture


PokeAPIを使用したポケモン図鑑アプリ（iOS版）のVIPERアーキテクチャ設計書です。


## プロジェクト概要


Android版と同じ仕様のポケモン図鑑アプリをiOS（Swift + SwiftUI）で実装しています。


### 技術スタック
- **言語**: Swift 5.9+
- **UIフレームワーク**: SwiftUI
- **アーキテクチャパターン**: VIPER (View, Interactor, Presenter, Entity, Router)
- **依存性注入**: Manual DI (DependencyContainer)
- **非同期処理**: Swift Concurrency (async/await)
- **ネットワーク**: URLSession
- **画像読み込み**: AsyncImage
- **ナビゲーション**: NavigationStack


---


## VIPERアーキテクチャ設計


### アーキテクチャ概要


```
┌─────────────────────────────────────────────────────────────┐
│                        Presentation Layer                    │
├─────────────┬───────────────┬────────────────┬──────────────┤
│    View     │   Presenter   │     Router     │  ViewState   │
│  (SwiftUI)  │(@MainActor VO)│(NavigationPath)│    (enum)    │
└─────────────┴───────────────┴────────────────┴──────────────┘
                     │                                │
                     ▼                                ▼
┌─────────────────────────────────────────────────────────────┐
│                        Domain Layer                          │
├──────────────────────────┬──────────────────────────────────┤
│      Interactor          │          Entity                  │
│   (Business Logic)       │      (Domain Models)             │
└──────────────────────────┴──────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                         Data Layer                           │
├──────────────┬─────────────────┬────────────────────────────┤
│  Repository  │  Remote/Local   │      Data Models          │
│              │  Data Sources   │        (DTO)               │
└──────────────┴─────────────────┴────────────────────────────┘
```


### 各レイヤーの責務


#### 1. View (SwiftUI)
- **責務**: UIの描画とユーザー入力の受付
- **実装**:
 - SwiftUIのViewプロトコルに準拠
 - ViewStateを`@StateObject`で購読
 - ユーザーイベントをPresenterのメソッドに委譲
 - 宣言的UIで状態に基づいてUIを自動更新
- **依存**: Presenter、ViewState


```swift
struct PokemonListView: View {
   @StateObject var presenter: PokemonListPresenter
  
   var body: some View {
       // ViewStateに基づいてUIを描画
       switch presenter.viewState {
       case .loading:
           ProgressView()
       case .success(let pokemons, _, _):
           PokemonGridView(pokemons: pokemons)
       case .error(let message):
           ErrorView(message: message)
       default:
           EmptyView()
       }
   }
}
```


#### 2. Interactor (ビジネスロジック)
- **責務**: ビジネスロジックの実行、データの取得・加工
- **実装**:
 - UseCaseとして機能単位で分割
 - Repositoryからデータを取得
 - EntityをPresenterに返却
 - async/awaitによる非同期処理
- **依存**: Repository、Entity


```swift
class GetPokemonListInteractor {
   private let repository: PokemonRepository
  
   init(repository: PokemonRepository) {
       self.repository = repository
   }
  
   func execute(limit: Int = 20, offset: Int = 0) async -> Result<(pokemons: [Pokemon], hasMore: Bool)> {
       guard limit > 0, offset >= 0 else {
           return .failure(APIError.custom("Invalid parameters"))
       }
      
       return await repository.getPokemonList(limit: limit, offset: offset)
   }
}
```


#### 3. Presenter (プレゼンテーションロジック)
- **責務**: ViewとInteractorの橋渡し、ViewStateの管理
- **実装**:
 - `ObservableObject`に準拠
 - `@MainActor`でメインスレッド実行を保証
 - UIイベントを受け取りInteractorを呼び出し
 - EntityをViewStateに変換
 - `@Published`でViewStateを公開
- **依存**: Interactor、Router


```swift
@MainActor
class PokemonListPresenter: ObservableObject {
   @Published private(set) var viewState: PokemonListViewState = .initial
   @Published var searchQuery: String = ""
  
   private let getPokemonListInteractor: GetPokemonListInteractor
   private let searchPokemonInteractor: SearchPokemonInteractor
   private let router: AppRouter
  
   func loadInitialData() async {
       viewState = .loading
       let result = await getPokemonListInteractor.execute()
      
       switch result {
       case .success(let data):
           viewState = .success(pokemons: data.pokemons, hasMore: data.hasMore, isLoadingMore: false)
       case .failure(let error):
           viewState = .error(error.localizedDescription)
       }
   }
}
```


#### 4. Entity (ドメインモデル)
- **責務**: ビジネスドメインのデータ構造定義
- **実装**:
 - ドメイン層のstruct
 - ビジネスルールを含む
 - Data Layerのモデル(DTO)とは独立
 - Identifiable、Equatableに準拠


```swift
struct Pokemon: Identifiable, Equatable {
   let id: Int
   let name: String
   let url: String
  
   var imageUrl: String {
       "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
   }
  
   var displayName: String {
       name.prefix(1).uppercased() + name.dropFirst()
   }
}
```


#### 5. Router (ナビゲーション)
- **責務**: 画面遷移の制御
- **実装**:
 - NavigationStackを使用
 - NavigationPathで遷移を管理
 - DeepLink対応可能


```swift
@MainActor
class AppRouter: ObservableObject {
   @Published var path = NavigationPath()
  
   func navigateToPokemonDetail(pokemonName: String) {
       path.append(NavigationDestination.pokemonDetail(pokemonName: pokemonName))
   }
  
   func pop() {
       if !path.isEmpty {
           path.removeLast()
       }
   }
}
```


---


## プロジェクト構造


```
PokemonApp/
├── PokemonApp.swift           # アプリエントリーポイント
│
├── Presentation/              # Presentation Layer
│   ├── Navigation/
│   │   └── AppRouter.swift    # ナビゲーション管理
│   ├── PokemonList/           # ポケモン一覧画面
│   │   ├── PokemonListView.swift
│   │   ├── PokemonListPresenter.swift
│   │   └── PokemonListViewState.swift
│   └── PokemonDetail/         # ポケモン詳細画面
│       ├── PokemonDetailView.swift
│       ├── PokemonDetailPresenter.swift
│       └── PokemonDetailViewState.swift
│
├── Domain/                    # Domain Layer
│   ├── Entity/                # ドメインモデル
│   │   ├── Pokemon.swift
│   │   ├── PokemonDetail.swift
│   │   └── Result.swift
│   ├── Interactor/            # ビジネスロジック
│   │   ├── GetPokemonListInteractor.swift
│   │   ├── GetPokemonDetailInteractor.swift
│   │   └── SearchPokemonInteractor.swift
│   └── Repository/            # Repository Interface
│       └── PokemonRepository.swift
│
├── Data/                      # Data Layer
│   ├── Repository/            # Repository実装
│   │   └── PokemonRepositoryImpl.swift
│   ├── Remote/                # リモートデータソース
│   │   ├── API/
│   │   │   └── PokeAPIService.swift
│   │   └── DTO/               # Data Transfer Object
│   │       └── PokemonResponse.swift
│   └── Mapper/                # データ変換
│       └── PokemonMapper.swift
│
└── DI/                        # Dependency Injection
   └── DependencyContainer.swift
```


---


## データフロー


### 1. ユーザーアクション → データ取得 → UI更新


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
State Update (Presenter)
   ↓
UI Render (View - SwiftUI auto-refresh)
```


### 2. 無限スクロールの実装例


```swift
// View: スクロール位置を監視
LazyVGrid(columns: columns) {
   ForEach(pokemons) { pokemon in
       PokemonCard(pokemon: pokemon)
           .onAppear {
               // 最後から3番目で追加読み込み
               if index >= pokemons.count - 3, hasMore {
                   onLoadMore()
               }
           }
   }
}


// Presenter: 追加データを読み込み
func loadMorePokemons() async {
   guard case .success(let pokemons, let hasMore, _) = viewState,
         hasMore else { return }
  
   viewState = .success(pokemons: pokemons, hasMore: hasMore, isLoadingMore: true)
  
   let result = await getPokemonListInteractor.execute(limit: pageSize, offset: currentOffset)
  
   // 結果を既存リストに追加
   viewState = .success(
       pokemons: pokemons + newPokemons,
       hasMore: data.hasMore,
       isLoadingMore: false
   )
}
```


---


## 状態管理戦略


### ViewState設計


各画面のStateをenumで定義（Kotlinのsealed interfaceに相当）:


```swift
enum PokemonListViewState: Equatable {
   case initial
   case loading
   case success(
       pokemons: [Pokemon],
       hasMore: Bool,
       isLoadingMore: Bool
   )
   case error(String)
}
```


### 単方向データフロー


```
View → Event → Presenter → Interactor
 ↑                               ↓
 └──── ViewState ←── Update ← Result
```


---


## 依存性注入 (DependencyContainer)


### Manual DIパターン


AndroidのHiltと異なり、iOSではManual DIを採用:


```swift
class DependencyContainer {
   // Data Layer
   private lazy var apiService: PokeAPIServiceProtocol = {
       PokeAPIService()
   }()
  
   private lazy var pokemonRepository: PokemonRepository = {
       PokemonRepositoryImpl(apiService: apiService)
   }()
  
   // Domain Layer (Interactors)
   private lazy var getPokemonListInteractor: GetPokemonListInteractor = {
       GetPokemonListInteractor(repository: pokemonRepository)
   }()
  
   // Presenter Factory
   func makePokemonListPresenter(router: AppRouter) -> PokemonListPresenter {
       PokemonListPresenter(
           getPokemonListInteractor: getPokemonListInteractor,
           searchPokemonInteractor: searchPokemonInteractor,
           router: router
       )
   }
}
```


### Appでの使用


```swift
@main
struct PokemonApp: App {
   @StateObject private var appRouter = AppRouter()
   private let container = DependencyContainer()
  
   var body: some Scene {
       WindowGroup {
           NavigationStack(path: $appRouter.path) {
               PokemonListView(
                   presenter: container.makePokemonListPresenter(router: appRouter)
               )
               .navigationDestination(for: NavigationDestination.self) { destination in
                   // ルーティング
               }
           }
       }
   }
}
```


---


## Swift Concurrencyの活用


### async/awaitパターン


Kotlinのコルーチンに相当するSwiftのasync/await:


```swift
// Interactor
func execute() async -> Result<[Pokemon]> {
   return await repository.getPokemonList()
}


// Presenter
func loadInitialData() async {
   viewState = .loading
   let result = await interactor.execute()
  
   switch result {
   case .success(let data):
       viewState = .success(data)
   case .failure(let error):
       viewState = .error(error.localizedDescription)
   }
}


// View
.task {
   await presenter.loadInitialData()
}
```


---


## テスト戦略


### 1. Unit Test


#### Interactorのテスト
```swift
func testGetPokemonList_Success() async {
   // Given
   let mockRepo = MockPokemonRepository()
   let interactor = GetPokemonListInteractor(repository: mockRepo)
   mockRepo.pokemonListResult = .success((pokemons: [mockPokemon()], hasMore: true))
  
   // When
   let result = await interactor.execute()
  
   // Then
   XCTAssertNotNil(result.value)
   XCTAssertEqual(result.value?.pokemons.count, 1)
}
```


#### Presenterのテスト
```swift
@MainActor
func testLoadInitialData_Success() async {
   // Given
   let mockInteractor = MockGetPokemonListInteractor()
   let presenter = PokemonListPresenter(
       getPokemonListInteractor: mockInteractor,
       searchPokemonInteractor: mockSearchInteractor,
       router: mockRouter
   )
  
   // When
   await presenter.loadInitialData()
  
   // Then
   if case .success(let pokemons, _, _) = presenter.viewState {
       XCTAssertEqual(pokemons.count, 20)
   } else {
       XCTFail("Expected success state")
   }
}
```


### 2. UI Test (SwiftUI)


```swift
func testPokemonCardTap_NavigatesToDetail() {
   let app = XCUIApplication()
   app.launch()
  
   // ポケモンカードをタップ
   app.buttons["Bulbasaur"].tap()
  
   // 詳細画面が表示されることを確認
   XCTAssertTrue(app.navigationBars["Bulbasaur"].exists)
}
```


---


## Android vs iOS 実装対応表


| 機能 | Android (Kotlin) | iOS (Swift) |
|------|------------------|-------------|
| UI Framework | Jetpack Compose | SwiftUI |
| ViewModel | ViewModel + StateFlow | @MainActor ObservableObject + @Published |
| 状態定義 | sealed interface | enum (Equatable) |
| DI | Hilt (Dagger) | Manual DI |
| 非同期 | Coroutines + Flow | async/await + AsyncStream |
| ネットワーク | Retrofit2 | URLSession + Codable |
| 画像読み込み | Coil | AsyncImage |
| ナビゲーション | Navigation Compose | NavigationStack + NavigationPath |
| JSON解析 | Gson/Kotlinx Serialization | Codable |


---


## パフォーマンス最適化


### 1. リスト表示の最適化
- LazyVGridでの仮想化（遅延読み込み）
- Identifiableプロトコルで効率的な差分更新
- onAppearで無限スクロール実装


### 2. 画像読み込み
- AsyncImageでの非同期読み込み
- URLCacheによる自動キャッシュ


### 3. 状態管理
- @Publishedで最小限の再描画
- Equatableで不要な更新を防止


### 4. メモリ管理
- lazy varで遅延初期化
- weak/unowned参照で循環参照を防止


---


## SwiftUI + VIPER のベストプラクティス


### 1. @MainActor の使用
Presenterは必ず`@MainActor`を付与してUI更新をメインスレッドで実行:


```swift
@MainActor
class PokemonListPresenter: ObservableObject {
   @Published private(set) var viewState: PokemonListViewState = .initial
}
```


### 2. @Published の活用
ViewStateは`@Published`で自動的にViewに通知:


```swift
@Published private(set) var viewState: PokemonListViewState = .initial
```


### 3. Task での非同期呼び出し
ViewからPresenterの非同期メソッドを呼ぶ際は`Task`または`.task`を使用:


```swift
.task {
   await presenter.loadInitialData()
}


Button("Load More") {
   Task {
       await presenter.loadMorePokemons()
   }
}
```


### 4. Combine for Debounce
検索などのdebounce処理にはCombineを活用:


```swift
$searchQuery
   .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
   .sink { query in
       Task { await self.performSearch(query: query) }
   }
   .store(in: &cancellables)
```


---


## セキュリティ考慮事項


1. **API通信**: HTTPS必須、App Transport Securityで保護
2. **認証情報**: Keychainでの安全な保存
3. **個人情報**: Data Protectionクラスの使用
4. **API Key**: Info.plistまたは環境変数での管理
5. **難読化**: Release buildでのコンパイラ最適化


---


## エラーハンドリング戦略


### Result型の使用


```swift
enum Result<T> {
   case success(T)
   case failure(Error)
}


enum APIError: LocalizedError {
   case networkError
   case decodingError
   case invalidResponse
   case custom(String)
  
   var errorDescription: String? {
       switch self {
       case .networkError:
           return "ネットワークエラーが発生しました"
       case .decodingError:
           return "データの解析に失敗しました"
       case .invalidResponse:
           return "無効なレスポンスです"
       case .custom(let message):
           return message
       }
   }
}
```


---


## CI/CD パイプライン


### GitHub Actions推奨構成


1. **Pull Request時**
  - SwiftLint実行
  - Unit Test実行
  - テストカバレッジレポート


2. **Merge時 (develop)**
  - Full test suite実行
  - Debug IPA生成
  - TestFlightへデプロイ


3. **Release時 (main)**
  - Release IPA生成
  - App Store Connectへアップロード


---


## まとめ


このVIPERアーキテクチャ設計により、以下が実現できます:


✅ **関心の分離**: 各コンポーネントの責務が明確
✅ **テスタビリティ**: 各レイヤーが独立してテスト可能
✅ **保守性**: 変更の影響範囲が限定的
✅ **スケーラビリティ**: 機能追加が容易
✅ **再利用性**: InteractorやEntityの再利用が可能
✅ **SwiftUI連携**: ObservableObject + @Published で状態管理が自然
✅ **Swift Concurrency**: async/awaitで非同期処理が簡潔


Android版と同じ設計思想を保ちながら、SwiftとSwiftUIのベストプラクティスに従った実装となっています。
