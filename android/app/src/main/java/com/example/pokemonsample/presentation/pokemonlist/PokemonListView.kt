package com.example.pokemonsample.presentation.pokemonlist
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyGridState
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.lazy.grid.rememberLazyGridState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.viewmodel.CreationExtras
import coil.compose.AsyncImage
import com.example.pokemonsample.domain.entity.Pokemon
import retrofit2.http.Query

/**
 * ポケモン一覧画面のView
 * Jetpack Compose による宣言的UI
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PokemonListScreen(presenter: PokemonListPresenter = hiltViewModel()) {
    val viewState by presenter.viewState.collectAsState()
    var searchQuery by remember { mutableStateOf("") }
    val listState = rememberLazyGridState()

    // 無限スクロール
    LaunchedEffect(listState) {
        snapshotFlow { listState.layoutInfo }
            .collect { layoutInfo ->
                val currentState = presenter.viewState.value
                if (currentState is PokemonListViewState.Success &&
                    !currentState.isLoadingMore &&
                    currentState.hasMore) {

                    val lastVisibleItem = layoutInfo.visibleItemsInfo.lastOrNull()
                    val totalItems = layoutInfo.totalItemsCount

                    // 最後から3アイテム以内に到達したら次のページを読み込み
                    if (lastVisibleItem != null && lastVisibleItem.index >= totalItems - 3) {
                        presenter.loadMorePokemon()
                    }
                }
            }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Pokemon List") },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.primary,
                    titleContentColor = MaterialTheme.colorScheme.onPrimary
                )
            )
        }
    ) {
        paddingValues ->
        Column(modifier = Modifier.padding(paddingValues)) {
            // 検索バー
            SearchBar(
                query = searchQuery,
                onQueryChange = { query ->
                    searchQuery = query
                    presenter.onSearchQueryChanged(query)
                },
                modifier = Modifier.fillMaxWidth().padding(16.dp)
            )
            // コンテンツ
        }
    }
}

@Composable
private fun SearchBar(
    query: String,
    onQueryChange: (String) -> Unit,
    modifier: Modifier = Modifier
) {
    OutlinedTextField(
        value = query,
        onValueChange = onQueryChange,
        modifier = modifier,
        placeholder = { Text("Search Pokemon ...") },
        leadingIcon = {
            Icon(
                imageVector = Icons.Default.Search,
                contentDescription = "Search"
            )
        },
        singleLine = true,
        colors = OutlinedTextFieldDefaults.colors(
            focusedBorderColor = MaterialTheme.colorScheme.primary,
            unfocusedBorderColor = MaterialTheme.colorScheme.outline
        )
    )
}

@Composable
private fun PokemonGrid(
    pokemonList: List<PokemonViewData>,
    isLoadingMore: Boolean,
    onPokemonClick: (Int) -> Unit,
    onRefresh: () -> Unit,
    listState: LazyGridState
) {
    if (pokemonList.isEmpty()) {
        EmptyContent()
    } else {
        LazyVerticalGrid(
            columns = GridCells.Fixed(2),
            state = listState,
            contentPadding = PaddingValues(16.dp),
            horizontalArrangement = Arrangement.spacedBy(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            items(pokemonList) { pokemon ->
                PokemonCard(pokemon = pokemon, onClick = { onPokemonClick(pokemon.id) })
            }
            // ローディングインジケーター表示
            if (isLoadingMore) {
                item {
                    Box(
                        modifier = Modifier.fillMaxWidth().padding(16.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        CircularProgressIndicator()
                    }
                }
            }
        }
    }
}

@Composable
private fun PokemonCard(
    pokemon: PokemonViewData,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth().aspectRatio(1f).clickable(onClick = onClick),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
    ) {
        Column(
            modifier = Modifier.fillMaxSize().padding(8.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // ポケモン画像
            AsyncImage(
                model = pokemon.imageUrl,
                contentDescription = pokemon.displayName,
                modifier = Modifier.size(100.dp).padding(8.dp),
                contentScale = ContentScale.Fit
            )
            // ID
            Text(
                text = pokemon.idFormatted,
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
            // 名前
            Text(
                text = pokemon.displayName,
                style = MaterialTheme.typography.bodyMedium,
                textAlign = TextAlign.Center,
                maxLines = 1
            )
        }
    }
}

@Composable
private fun LoadingContent() {
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        CircularProgressIndicator()
    }
}

@Composable
private fun ErrorContent(
    message: String,
    onRetry: () -> Unit
) {
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            Text(
                text = message,
                style = MaterialTheme.typography.bodyMedium,
                textAlign = TextAlign.Center,
                modifier = Modifier.padding(horizontal = 32.dp)
            )
            Button(onClick = onRetry) {
                Text("Retry")
            }
        }
    }
}

@Composable
private fun EmptyContent() {
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        Text(
            text = "No Pokemon found",
            style = MaterialTheme.typography.bodyMedium,
            textAlign = TextAlign.Center
        )
    }
}