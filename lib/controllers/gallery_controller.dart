import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery/api_requests/gallery_api_request.dart';
import 'package:image_gallery/model_class/gallery_model.dart';

class GalleryController extends GetxController {
  var isGalleryLoading = false.obs;
  var isMoreGalleryLoading = false.obs;
  int page = 1;
  GalleryModel? galleryModel;

  final scrollController = ScrollController();
  final searchController = TextEditingController();

  Timer? _debounce;

  double boxSize = 130;

  @override
  void onInit() {
    super.onInit();
    initScrollController();
    loadGallery("");
  }

  loadGallery(String searchQuery) async {
    try {
      page = 1;
      isGalleryLoading(true);
      galleryModel = await GalleryApiRequest.getGalleryImage(searchQuery: searchQuery);
      return galleryModel;
    } catch (error) {
      isGalleryLoading(false);
    } finally {
      isGalleryLoading(false);
    }
  }

  loadMoreGallery(String searchQuery) async {
    try {
      page++;
      isMoreGalleryLoading(true);
      GalleryModel tempGalleryModel = await GalleryApiRequest.getGalleryImage(searchQuery: searchQuery, page: page);
      if (tempGalleryModel != null) {
        for (int i = 0; i < tempGalleryModel.hits!.length; i++) {
          galleryModel!.hits!.add(tempGalleryModel.hits![i]);
        }
      }
      return galleryModel;
    } catch (error) {
      isMoreGalleryLoading(false);
    } finally {
      isMoreGalleryLoading(false);
    }
  }

  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      loadGallery(searchController.text);
    });
  }

  int getCrossAxisCount(BuildContext context) {
    if (getScreenWidth(context).toInt() < 360) {
      return 1;
    } else if (getScreenWidth(context).toInt() >= 1000) {
      return 6;
    } else {
      if (context.isPhone) {
        return 2;
      } else {
        return 4;
      }
    }
  }

  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  initScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isTop = scrollController.position.pixels == 0;
        if (!isTop) {
          loadMoreGallery(searchController.text);
        }
      }
    });
  }

  String displayNumberInKMB(int num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  Future<bool> backPressed(BuildContext buildContext) async {
    bool willLeave = false;
    await showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure want to exit?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            ElevatedButton(
              onPressed: () {
                willLeave = true;
                exit(0);
              },
              child: const Text("Yes"),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );

    return willLeave;
  }
}
