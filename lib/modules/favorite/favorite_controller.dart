import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:pure_live/common/index.dart';

class FavoriteController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final SettingsService settings = Get.find<SettingsService>();
  late TabController tabController;
  FavoriteController() {
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onInit() {
    super.onInit();
    // 初始化关注页
    syncRooms();

    // 监听settings rooms变化
    settings.favoriteRooms.listen((rooms) => syncRooms());

    // 定时自动刷新
    Timer.periodic(
      Duration(seconds: settings.autoRefreshTime.value),
      (timer) => onRefresh(),
    );
  }

  final onlineRooms = [].obs;
  final offlineRooms = [].obs;

  void syncRooms() {
    onlineRooms.clear();
    offlineRooms.clear();
    onlineRooms.addAll(settings.favoriteRooms
        .where((room) => room.liveStatus == LiveStatus.live));

    offlineRooms.addAll(settings.favoriteRooms
        .where((room) => room.liveStatus != LiveStatus.live));
  }

  Future<bool> onRefresh() async {
    bool hasError = false;
    List<Future<LiveRoom>> futures = [];
    for (final room in settings.favoriteRooms.value) {
      futures.add(Sites.of(room.platform!)
          .liveSite
          .getRoomDetail(roomId: room.roomId!));
    }

    try {
      final rooms = await Future.wait(futures);
      for (var room in rooms) {
        settings.updateRoom(room);
      }
      syncRooms();
    } catch (e) {
      log(e.toString(), name: 'syncRooms');
    }
    return hasError;
  }
}
