# Pokemon App - Android VIPER Architecture


PokeAPIを使用したポケモン図鑑アプリです。Flutterプロジェクトの`open_project`をAndroid(Kotlin + Jetpack Compose)で再実装しました。


## アーキテクチャ


**VIPER (View, Interactor, Presenter, Entity, Router)**


詳細は [ARCHITECTURE.md](ARCHITECTURE.md) を参照してください。


## 技術スタック


- **言語**: Kotlin
- **UIフレームワーク**: Jetpack Compose
- **アーキテクチャパターン**: VIPER
- **依存性注入**: Hilt (Dagger)
- **非同期処理**: Kotlin Coroutines + Flow
- **ネットワーク**: Retrofit2 + OkHttp
- **画像読み込み**: Coil
- **ナビゲーション**: Jetpack Navigation Compose


## 機能


### 実装済み
- ✅ ポケモン一覧表示
- ✅ ポケモン詳細表示
- ✅ 検索機能（名前・ID）
- ✅ タイプ別カラー表示
- ✅ ステータス表示


### 未実装（Flutterプロジェクトでは不要としたもの）
- お気に入り機能


## プロジェクト構造


```
app/src/main/java/com/example/pokemonapp/
├── data/                      # Data Layer
│   ├── mapper/                # DTO → Entity 変換
│   ├── remote/                # API & DTO
│   └── repository/            # Repository 実装
├── domain/                    # Domain Layer
│   ├── entity/                # ドメインモデル
│   ├── interactor/            # ビジネスロジック (UseCase)
│   └── repository/            # Repository インターフェース
├── presentation/              # Presentation Layer
│   ├── pokemonlist/           # ポケモン一覧画面
│   │   ├── PokemonListView.kt
│   │   ├── PokemonListPresenter.kt
│   │   ├── PokemonListViewState.kt
│   │   └── PokemonListRouter.kt
│   ├── pokemondetail/         # ポケモン詳細画面
│   │   ├── PokemonDetailView.kt
│   │   ├── PokemonDetailPresenter.kt
│   │   ├── PokemonDetailViewState.kt
│   │   └── PokemonDetailRouter.kt
│   ├── navigation/            # ナビゲーション
│   └── theme/                 # テーマ設定
├── di/                        # 依存性注入モジュール
├── MainActivity.kt
└── PokemonApplication.kt
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


## Flutter vs Android の対応関係


| Flutter | Android VIPER |
|---------|---------------|
| Widget | View (Composable) |
| State (freezed) | ViewState (sealed interface) |
| StateNotifier | Presenter (ViewModel) |
| Repository | Repository |
| - | **Interactor** (独立したビジネスロジック層) |
| Provider | Hilt DI |
| go_router | Navigation Compose |


## セットアップ


### 必要要件
- Android Studio Hedgehog | 2023.1.1 以降
- JDK 17
- Android SDK 34
- Kotlin 1.9.20


### ビルド手順


1. プロジェクトをクローン/ダウンロード
2. Android Studioでプロジェクトを開く
3. Gradle Syncを実行
4. エミュレーターまたは実機でビルド＆実行


```bash
# コマンドラインでビルド
./gradlew assembleDebug


# インストール
./gradlew installDebug
```


## API


[PokeAPI](https://pokeapi.co/) を使用
- ベースURL: `https://pokeapi.co/api/v2/`
- エンドポイント:
 - `GET /pokemon?limit=151&offset=0` - ポケモン一覧
 - `GET /pokemon/{id}` - ポケモン詳細


## テスト


```bash
# Unit Test実行
./gradlew test


# UI Test実行
./gradlew connectedAndroidTest
```


## VIPERの利点（Flutter MVVMとの比較）


### 責務の分離
- **Interactor**: ビジネスロジックのみを担当
- **Presenter**: プレゼンテーションロジックのみを担当
- **Router**: ナビゲーションのみを担当


### テスタビリティ
各コンポーネントが独立しているため、個別にテスト可能


### 再利用性
Interactorは複数の画面で再利用可能


### 保守性
変更の影響範囲が限定的


## ライセンス


MIT License


## 参考資料


- [PokeAPI Documentation](https://pokeapi.co/docs/v2)
- [Jetpack Compose](https://developer.android.com/jetpack/compose)
- [Android App Architecture](https://developer.android.com/topic/architecture)
- [ARCHITECTURE.md](ARCHITECTURE.md) - VIPERアーキテクチャ詳細設計