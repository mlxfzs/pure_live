import 'package:cached_network_image/cached_network_image.dart';
import 'package:pure_live/common/index.dart';
import 'package:pure_live/routes/app_navigation.dart';

class AreaCard extends StatelessWidget {
  const AreaCard({
    Key? key,
    required this.category
  }) : super(key: key);
  final LiveArea category;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(7.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: () => AppNavigator.toCategoryDetail(site: Sites.of(category.platform!),category: category),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Card(
                margin: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                elevation: 0,
                child: CachedNetworkImage(
                  imageUrl: category.areaPic!,
                  cacheManager: CustomCacheManager.instance,
                  fit: BoxFit.fill,
                  errorWidget: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.live_tv_rounded,
                      size: 38,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              title: Text(
                category.areaName!,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    category.typeName!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
