import 'dart:async';
import 'dart:io';

import 'package:amap_flutter_location_example/location.dart';
import 'package:amap_flutter_location_plus/amap_flutter_location.dart';
import 'package:amap_flutter_location_plus/amap_location_option.dart';
import 'package:permission_handler/permission_handler.dart';

///高德地图获取位置信息工具
class AMapGetCurrentLocation {
  static bool isInit = false;

  ///初始化(只需要调一次)
  static void init() {
    /// [hasShow] 隐私权政策是否弹窗展示告知用户
    AMapFlutterLocation.updatePrivacyShow(true, true);

    /// [hasAgree] 隐私权政策是否已经取得用户同意
    AMapFlutterLocation.updatePrivacyAgree(true);
    // 设置apikey
    AMapFlutterLocation.setApiKey(
        "1dbf56e2e8a4d0e4cdc2df9efd36bc71", "dfb64c0463cb53927914364b5c09aba0");
  }

  AMapGetCurrentLocation() {
    if (!isInit) {
      AMapGetCurrentLocation.init();
      isInit = true;
    }
  }

  void dispose() {
    stopLocation();
    if (_locationListener != null) {
      _locationListener?.cancel();
    }

    ///销毁定位
    _locationPlugin.destroy();
  }

  final AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
  //监听定位
  StreamSubscription<Map<String, Object>>? _locationListener;

  //获取定位信息的默认配置
  AMapLocationOption defaultLocationOption = AMapLocationOption(
    onceLocation: true, //是否单次定位
    needAddress: false, //是否需要返回逆地理信息
    locationTimeout: 10,
    reGeocodeTimeout: 10,
    geoLanguage: GeoLanguage.DEFAULT, //逆地理信息的语言类型
    desiredLocationAccuracyAuthorizationMode:
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy,
    locationInterval: 2000, //设置Android端连续定位的定位间隔
    locationMode: AMapLocationMode.Hight_Accuracy, //设置Android端的定位模式
    distanceFilter: -1, //设置iOS端的定位最小更新距离
    desiredAccuracy: DesiredAccuracy.BestForNavigation, //设置iOS端期望的定位精度
    pausesLocationUpdatesAutomatically: false, //设置iOS端是否允许系统暂停定位
  );

  /// 使用高德定位Flutter api获取单次定位信息
  Future<Location?> getOnceLocation({
    AMapLocationMode? locationMode,
    DesiredAccuracy? desiredAccuracy,
    Duration? timeout,
  }) async {
    Completer<Location?> completer = Completer();
    // 动态申请定位权限
    await requestPermission();
    //iOS 获取native精度类型
    if (Platform.isIOS) {
      await requestAccuracyAuthorization(_locationPlugin);
    }

    // 设置iOS期望定位精度
    defaultLocationOption.desiredAccuracy =
        desiredAccuracy ?? DesiredAccuracy.HundredMeters;
    // ios14高精度定位
    defaultLocationOption.fullAccuracyPurposeKey = "ClockInLocationScene";
    // 设置Android定位模式
    defaultLocationOption.locationMode =
        locationMode ?? AMapLocationMode.Hight_Accuracy;
    // setIosHighAccuracy(iosHighAccuracy);
    // setAndroidHighAccuracy(androidHighAccuracy);
    //设置定位参数
    defaultLocationOption.locationTimeout =
        timeout != null ? timeout.inSeconds : 10;
    //将定位参数设置给定位插件
    _locationPlugin.setLocationOption(defaultLocationOption);
    //设置定位监听
    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      //result即为定位结果
      print("高德定位 Flutter 插件 ---- AMapLocation ---");
      print(result);
      if (result["errorCode"] == null) {
        Location location = Location.fromJson(result);
        // 关闭监听，否则无法重新添加监听
        if (!completer.isCompleted) {
          completer.complete(location);
        }
      } else {
        // 获取位置错误
        print(result["errorInfo"]);
        // 关闭监听，否则无法重新添加监听
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      }
    });
    //开始定位
    _locationPlugin.startLocation();
    return completer.future;
  }

  ///停止定位
  void stopLocation() {
    _locationPlugin.stopLocation();
  }

  ///获取iOS native的accuracyAuthorization类型
  static Future<AMapAccuracyAuthorization> requestAccuracyAuthorization(
      AMapFlutterLocation locationPlugin) async {
    AMapAccuracyAuthorization currentAccuracyAuthorization =
        await locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      print("精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      print("模糊定位类型");
    } else {
      print("未知定位类型");
    }

    return currentAccuracyAuthorization;
  }

  /// 动态申请定位权限
  static Future<bool> requestPermission() async {
    //SDK在Android 6.0下需要进行运行检测的权限如下：
    // Manifest.permission.ACCESS_COARSE_LOCATION,
    // Manifest.permission.ACCESS_FINE_LOCATION,
    // Manifest.permission.WRITE_EXTERNAL_STORAGE,
    // Manifest.permission.READ_EXTERNAL_STORAGE,
    // Manifest.permission.READ_PHONE_STATE

    // 申请定位权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      print("定位权限申请通过");
    } else {
      print("定位权限申请不通过");
    }
    // 申请存储权限
    bool hasStoragePermission = await requestStoragePermission();
    if (hasStoragePermission) {
      print("存储权限申请通过");
    } else {
      print("存储权限申请不通过");
    }

    return hasLocationPermission;
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  static Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  /// 申请存储权限
  static Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
