import 'package:get/get.dart';
import 'package:pure_live/common/index.dart';
import 'package:pure_live/modules/areas/areas_list_controller.dart';

class AreasController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  int index = 0;
  AreasController() {
    final preferPlatform = Get.find<SettingsService>().preferPlatform.value;
    final pIndex = Sites.supportSites.indexWhere((e) => e.id == preferPlatform);
    tabController = TabController(
      initialIndex: pIndex == -1 ? 0 : pIndex,
      length: Sites.supportSites.length,
      vsync: this,
    );
    index = pIndex == -1 ? 0 : pIndex;
    tabController.animation?.addListener(() {
      var currentIndex = (tabController.animation?.value ?? 0).round();
      if (index == currentIndex) {
        return;
      }
      index = currentIndex;
      var controller =
          Get.find<AreasListController>(tag: Sites.supportSites[index].id);

      if (controller.list.isEmpty) {
        controller.loadData();
      }
    });
  }

  @override
  void onInit() async {
    for (var site in Sites.supportSites) {
      Get.put(AreasListController(site), tag: site.id);
      var controller =
          Get.find<AreasListController>(tag: site.id);
      if (controller.list.isEmpty) {
        controller.loadData();
      }
    }

    super.onInit();
  }
}
