import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/presentation/common_widgets/cached_image_widget.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/presentation/widgets/friend_profile_widgets/friend_profile_appbar.dart';
import 'package:simple_tags/simple_tags.dart';

class VirtualFriendProfileScreen extends StatelessWidget {
  final VirtualFriendModel friendInfo;
  const VirtualFriendProfileScreen({super.key, required this.friendInfo});

  @override
  Widget build(BuildContext context) {
    List<String> hobbies =
        friendInfo.hobbies!.map((e) => e.toString()).toList();
    return Scaffold(
      appBar: buildFriendProfileAppBar(context),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Container(
                  width: double.infinity,
                  height: 300.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: const [BoxShadow(blurRadius: 15.0)],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: CachedImageWidget(
                          imageUrl: friendInfo.displayPictureUrl ?? "")),
                ),
                SizedBox(height: 20.h),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 7.h),
                          child: CircleAvatar(
                            backgroundColor: ColorConstants.successColor,
                            radius: 9.r,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: CustomText(
                            text: "${friendInfo.name}, ${friendInfo.age}",
                            textColor: Theme.of(context).primaryColor,
                            isBold: true,
                            size: 30.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Icon(Icons.home, size: 20.sp),
                    SizedBox(width: 7.w),
                    CustomText(
                      text:
                          "Lives in ${friendInfo.city}, ${friendInfo.country}",
                      size: 16.sp,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomText(
                  text: "Hobbies",
                  size: 18.sp,
                  isBold: true,
                  textColor: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 10.h),
                SimpleTags(
                  content: hobbies,
                  wrapSpacing: 8,
                  wrapRunSpacing: 8,
                  tagTextStyle: TextStyle(
                    fontSize: 12.sp,
                  ),
                  tagContainerPadding: const EdgeInsets.all(8),
                  tagContainerDecoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}