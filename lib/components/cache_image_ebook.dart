import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheImageEbook extends StatelessWidget {
  const CacheImageEbook({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.fill,
        ),
        ),
      ),
      cacheManager: CacheManager(
        Config(
          'ebookCacheKey',
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 20,
        ),
      ),
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
