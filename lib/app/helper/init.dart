/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/backend/api/api.dart';
import 'package:user/app/backend/parse/account_parse.dart';
import 'package:user/app/backend/parse/address_parse.dart';
import 'package:user/app/backend/parse/cart_parse.dart';
import 'package:user/app/backend/parse/categories_parse.dart';
import 'package:user/app/backend/parse/chats_list_parse.dart';
import 'package:user/app/backend/parse/checkout_parse.dart';
import 'package:user/app/backend/parse/complaints_parse.dart';
import 'package:user/app/backend/parse/contact_parse.dart';
import 'package:user/app/backend/parse/edit_profile_parse.dart';
import 'package:user/app/backend/parse/favourite_parse.dart';
import 'package:user/app/backend/parse/firebase_parse.dart';
import 'package:user/app/backend/parse/firebase_register_parse.dart';
import 'package:user/app/backend/parse/firebase_reset_parse.dart';
import 'package:user/app/backend/parse/give_reviews_parse.dart';
import 'package:user/app/backend/parse/home_parse.dart';
import 'package:user/app/backend/parse/in_offer_parse.dart';
import 'package:user/app/backend/parse/inbox_parse.dart';
import 'package:user/app/backend/parse/intro_parse.dart';
import 'package:user/app/backend/parse/language_parse.dart';
import 'package:user/app/backend/parse/location_parse.dart';
import 'package:user/app/backend/parse/login_parse.dart';
import 'package:user/app/backend/parse/new_address_parse.dart';
import 'package:user/app/backend/parse/new_card_parse.dart';
import 'package:user/app/backend/parse/offers_parse.dart';
import 'package:user/app/backend/parse/order_details_parser.dart';
import 'package:user/app/backend/parse/orders_parse.dart';
import 'package:user/app/backend/parse/pages_parse.dart';
import 'package:user/app/backend/parse/popular_parse.dart';
import 'package:user/app/backend/parse/product_parse.dart';
import 'package:user/app/backend/parse/refer_parse.dart';
import 'package:user/app/backend/parse/register_parse.dart';
import 'package:user/app/backend/parse/reset_password_parse.dart';
import 'package:user/app/backend/parse/search_parse.dart';
import 'package:user/app/backend/parse/splash_parse.dart';
import 'package:user/app/backend/parse/store_products_parse.dart';
import 'package:user/app/backend/parse/stores_parse.dart';
import 'package:user/app/backend/parse/stripe_parse.dart';
import 'package:user/app/backend/parse/sub_cate_product_parse.dart';
import 'package:user/app/backend/parse/sub_category_parse.dart';
import 'package:user/app/backend/parse/tabs_parse.dart';
import 'package:user/app/backend/parse/top_picked.dart';
import 'package:user/app/backend/parse/track_parse.dart';
import 'package:user/app/backend/parse/update_password_firebase_parse.dart';
import 'package:user/app/backend/parse/wallet_parse.dart';
import 'package:user/app/backend/parse/web_payment_parse.dart';
import 'package:user/app/controller/cart_controller.dart';
import 'package:user/app/controller/in_offers_controller.dart';
import 'package:user/app/controller/popular_controller.dart';
import 'package:user/app/controller/store_products_controller.dart';
import 'package:user/app/controller/sub_cate_product_controller.dart';
import 'package:user/app/controller/sub_category_controller.dart';
import 'package:user/app/controller/tabs_controller.dart';
import 'package:user/app/controller/theme_controller.dart';
import 'package:user/app/controller/top_picked_controller.dart';
import 'package:user/app/env.dart';
import 'package:user/app/helper/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    final sharedPref = await SharedPreferences.getInstance();

    Get.put(SharedPreferencesManager(sharedPreferences: sharedPref), permanent: true);

    Get.lazyPut(() => ApiService(appBaseUrl: Environments.apiBaseURL));

    // Parser LazyLoad
    Get.lazyPut(() => HomeParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => CategoriesParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => CartParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => OrderParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => AccountParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => TabsParser(sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => SplashParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => LocationParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => IntroParser(sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => SubCategoryParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => OfferParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => StoresParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => TopPickedParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => PopularParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => InOfferParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => StoreProductsParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => SearchParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => SubCatesProductParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => ProductParser(sharedPreferencesManager: Get.find(), apiService: Get.find()), fenix: true);

    Get.lazyPut(() => LoginParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => RegisterParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => AppPagesParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => FirebaseParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => FirebaseRegisterParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => ContactParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => ReferParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => FavouriParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => WalletParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => AddressParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => AddNewAddressParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => EditProfileParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => CheckoutParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => StripePayParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => NewCardParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => WebPaymentsParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => OrderDetailsParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => ChatListParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => InboxParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => ComplaintsParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => LanguagesParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => ResetPasswordParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => FirebaseResetParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => UpdatePasswordFirebaseParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => GiveReviewsParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => TrackParser(apiService: Get.find(), sharedPreferencesManager: Get.find()), fenix: true);

    Get.lazyPut(() => ThemeController(sharedPreferencesManager: Get.find()), fenix: true);
    Get.lazyPut(() => CartController(parser: Get.find()));
    Get.lazyPut(() => TabsController(parser: Get.find()));

    // For Refreshing the Products In Global Pages
    Get.lazyPut(() => TopPickedController(parser: Get.find()));
    Get.lazyPut(() => PopularController(parser: Get.find()));
    Get.lazyPut(() => InOffersController(parser: Get.find()));
    Get.lazyPut(() => StoreProductsController(parser: Get.find()));
    Get.lazyPut(() => SubCategoryController(parser: Get.find()));
    Get.lazyPut(() => SubCategoryController(parser: Get.find()));
    Get.lazyPut(() => SubCatesProductsController(parser: Get.find()));
  }
}
