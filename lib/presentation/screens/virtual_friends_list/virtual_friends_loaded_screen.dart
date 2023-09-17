import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kpopchat/core/constants/google_ads_id.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/core/utils/admob_services.dart';
import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/presentation/common_widgets/cached_image_widget.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/presentation/widgets/virtual_friends_list_screen_widgets/app_bar.dart';
import 'package:kpopchat/presentation/widgets/virtual_friends_list_screen_widgets/zero_virtual_friends_widget.dart';

class VirtualFriendsLoadedScreen extends StatefulWidget {
  final List<SchemaVirtualFriendModel> virtualFriends;
  const VirtualFriendsLoadedScreen({super.key, required this.virtualFriends});

  @override
  State<VirtualFriendsLoadedScreen> createState() =>
      _VirtualFriendsLoadedScreenState();
}

class _VirtualFriendsLoadedScreenState
    extends State<VirtualFriendsLoadedScreen> {
  ValueNotifier<BannerAd?> virtualFriendsListScreenBannerAd =
      ValueNotifier<BannerAd?>(null);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBannerAd();
  }

  void _loadBannerAd() async {
    virtualFriendsListScreenBannerAd.value = await AdMobServices
        .getBannerAdByGivingAdId(GoogleAdId.homeScreenBannerAdId)
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    List<SchemaVirtualFriendModel> virtualFriends = widget.virtualFriends;

    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: conversationsScreenAppBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: virtualFriendsListScreenBannerAd,
        builder: (context, value, child) {
          return CommonWidgets.buildBannerAd(value);
        },
      ),
      body: virtualFriends.isEmpty
          ? const ZeroVirtualFriendsWidget()
          : ListView.builder(
              itemCount: virtualFriends.length,
              itemBuilder: (context, index) {
                VirtualFriendModel friendData = virtualFriends[index].info!;

                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.chatScreen, arguments: friendData);
                  },
                  child: Center(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: deviceHeight * 0.4,
                            child: CachedImageWidget(
                                imageUrl: friendData.displayPictureUrl!),
                          ),
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                  decoration: const BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(
                                        5.0,
                                        5.0,
                                      ),
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0,
                                    ),
                                    BoxShadow(
                                      color: Colors.transparent,
                                      offset: Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ),
                                  ]),
                                  height: 80.h,
                                  width: double.infinity),
                              Padding(
                                padding:
                                    EdgeInsets.only(left: 10.w, bottom: 10.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.green[400],
                                              borderRadius:
                                                  BorderRadius.circular(10.r)),
                                          width: 55.w,
                                          height: 22.h,
                                          child: CustomText(
                                            text: "Active",
                                            size: 11.sp,
                                            isBold: true,
                                            textColor: Colors.white,
                                          ),
                                        ),
                                        CustomText(
                                          text:
                                              "${friendData.name}, ${friendData.age}",
                                          isBold: true,
                                          size: 20.h,
                                          textColor: Colors.white,
                                        ),
                                        CustomText(
                                          text:
                                              "Lives in ${friendData.city}, ${friendData.country}",
                                          size: 13.sp,
                                          textColor: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 8.h, right: 20.w),
                                        child: const Icon(
                                          Icons.message,
                                          color: Colors.white,
                                          size: 30,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
