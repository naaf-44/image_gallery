import 'dart:convert';

import 'package:image_gallery/api_requests/api_requests.dart';
import 'package:image_gallery/constants/api_urls.dart';
import 'package:image_gallery/model_class/gallery_model.dart';

class GalleryApiRequest {
  static getGalleryImage({String searchQuery = "", int page = 1}) async {
    var response = await ApiRequest.getRequest(
        "${ApiUrls.baseUrl}${ApiUrls.authKey}${ApiUrls.searchQuery.replaceAll("{searchQuery}", searchQuery)}${ApiUrls.page.replaceAll("{page}", page.toString())}");
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      GalleryModel galleryModel = GalleryModel.fromJson(responseBody);
      return galleryModel;
    } else {
      return null;
    }
  }
}
