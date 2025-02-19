import 'package:dfunc/dfunc.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/tokens/token.dart';
import '../../../../core/tokens/token_list.dart';
import '../data/coingecko_client.dart';
import '../data/popular_token_cache.dart';

@injectable
class PopularTokenRepository {
  PopularTokenRepository({
    required MarketsCoingeckoClient coingeckoClient,
    required PopularTokenCache popularTokenCache,
    required TokenList tokenList,
  })  : _coingeckoClient = coingeckoClient,
        _cache = popularTokenCache,
        _tokenList = tokenList;

  final MarketsCoingeckoClient _coingeckoClient;
  final PopularTokenCache _cache;
  final TokenList _tokenList;

  static const _tokensCount = 10;

  AsyncResult<IMap<Token, double>> get({required String currency}) async {
    final cachedResult = await _cache.get();

    if (cachedResult != null && cachedResult.isNotEmpty) {
      return Either.right(cachedResult);
    }

    return refresh(currency: currency);
  }

  AsyncResult<IMap<Token, double>> refresh({required String currency}) =>
      _coingeckoClient
          .getMarketTokens(
            MarketsRequestDto(vsCurrency: currency, perPage: _tokensCount),
          )
          .toEither()
          .mapAsync(
            (responses) => responses.map(
              (r) => r
                  .toToken(_tokenList)
                  .let((t) => MapEntry(t, r.currentPrice ?? 0)),
            ),
          )
          .mapAsync(IMap.fromEntries)
          .doOnRightAsync(_cache.set);

  Future<void> clear() => _cache.remove();
}
