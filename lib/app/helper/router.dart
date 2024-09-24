/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/backend/binding/account_binding.dart';
import 'package:user/app/backend/binding/address_binding.dart';
import 'package:user/app/backend/binding/cart_binding.dart';
import 'package:user/app/backend/binding/categories_binding.dart';
import 'package:user/app/backend/binding/chat_list_binding.dart';
import 'package:user/app/backend/binding/checkout_binding.dart';
import 'package:user/app/backend/binding/complaints_binding.dart';
import 'package:user/app/backend/binding/contact_binding.dart';
import 'package:user/app/backend/binding/edit_profile_binding.dart';
import 'package:user/app/backend/binding/favourite_binding.dart';
import 'package:user/app/backend/binding/firebase_binding.dart';
import 'package:user/app/backend/binding/firebase_register_binding.dart';
import 'package:user/app/backend/binding/firebase_reset_binding.dart';
import 'package:user/app/backend/binding/give_reviews_binding.dart';
import 'package:user/app/backend/binding/home_binding.dart';
import 'package:user/app/backend/binding/in_offer_binding.dart';
import 'package:user/app/backend/binding/inbox_binding.dart';
import 'package:user/app/backend/binding/intro_binding.dart';
import 'package:user/app/backend/binding/language_binding.dart';
import 'package:user/app/backend/binding/location_binding.dart';
import 'package:user/app/backend/binding/login_binding.dart';
import 'package:user/app/backend/binding/new_address_binding.dart';
import 'package:user/app/backend/binding/new_card_binding.dart';
import 'package:user/app/backend/binding/offers_binding.dart';
import 'package:user/app/backend/binding/order_binding.dart';
import 'package:user/app/backend/binding/order_detail_binding.dart';
import 'package:user/app/backend/binding/pages_binding.dart';
import 'package:user/app/backend/binding/popular_binding.dart';
import 'package:user/app/backend/binding/product_binding.dart';
import 'package:user/app/backend/binding/refer_binding.dart';
import 'package:user/app/backend/binding/register_binding.dart';
import 'package:user/app/backend/binding/reset_password_binding.dart';
import 'package:user/app/backend/binding/search_binding.dart';
import 'package:user/app/backend/binding/splash_binding.dart';
import 'package:user/app/backend/binding/store_product_binding.dart';
import 'package:user/app/backend/binding/stores_binding.dart';
import 'package:user/app/backend/binding/stripe_pay_binding.dart';
import 'package:user/app/backend/binding/sub_cate_product_binding.dart';
import 'package:user/app/backend/binding/sub_category_binding.dart';
import 'package:user/app/backend/binding/tabs_binding.dart';
import 'package:user/app/backend/binding/top_picked_binding.dart';
import 'package:user/app/backend/binding/tracking_binding.dart';
import 'package:user/app/backend/binding/update_firebase_password_binding.dart';
import 'package:user/app/backend/binding/wallet_binding.dart';
import 'package:user/app/backend/binding/web_payment_binding.dart';
import 'package:user/app/view/account.dart';
import 'package:user/app/view/address.dart';
import 'package:user/app/view/app_pages.dart';
import 'package:user/app/view/cart.dart';
import 'package:user/app/view/category.dart';
import 'package:user/app/view/chats_list.dart';
import 'package:user/app/view/checkout.dart';
import 'package:user/app/view/complaints.dart';
import 'package:user/app/view/contacts.dart';
import 'package:user/app/view/deals.dart';
import 'package:user/app/view/edit_profile.dart';
import 'package:user/app/view/error.dart';
import 'package:user/app/view/favourite.dart';
import 'package:user/app/view/firebase.dart';
import 'package:user/app/view/firebase_register.dart';
import 'package:user/app/view/firebase_reset.dart';
import 'package:user/app/view/give_reviews.dart';
import 'package:user/app/view/history.dart';
import 'package:user/app/view/home.dart';
import 'package:user/app/view/inbox.dart';
import 'package:user/app/view/intro.dart';
import 'package:user/app/view/languages.dart';
import 'package:user/app/view/location.dart';
import 'package:user/app/view/login.dart';
import 'package:user/app/view/new_address.dart';
import 'package:user/app/view/new_card.dart';
import 'package:user/app/view/offers.dart';
import 'package:user/app/view/orders_details.dart';
import 'package:user/app/view/popular.dart';
import 'package:user/app/view/product.dart';
import 'package:user/app/view/refer.dart';
import 'package:user/app/view/register.dart';
import 'package:user/app/view/reset.dart';
import 'package:user/app/view/search.dart';
import 'package:user/app/view/splash.dart';
import 'package:user/app/view/store_products.dart';
import 'package:user/app/view/stores.dart';
import 'package:user/app/view/stripe_pay.dart';
import 'package:user/app/view/sub_category.dart';
import 'package:user/app/view/sub_cates_products.dart';
import 'package:user/app/view/tabs.dart';
import 'package:user/app/view/top_picked.dart';
import 'package:user/app/view/track.dart';
import 'package:user/app/view/update_password_firebase.dart';
import 'package:user/app/view/wallet.dart';
import 'package:user/app/view/web_payment.dart';

class AppRouter {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String location = '/location';
  static const String tabsRoutes = '/tabs';
  static const String homeRoutes = '/home';
  static const String category = '/category';
  static const String cartRoutes = '/cart';
  static const String history = '/history';
  static const String account = '/account';
  static const String search = '/search';
  static const String offers = '/offers';
  static const String stores = '/stores';
  static const String subCategory = '/sub_category';
  static const String topPicked = '/top_picked';
  static const String storeProducts = '/store_products';
  static const String checkout = '/checkout';
  static const String product = '/product';
  static const String favourite = '/favourite';
  static const String languagesRoutes = '/languages';
  static const String address = '/address';
  static const String loginRoutes = '/login';
  static const String register = '/register';
  static const String error = '/error';
  static const String popular = '/popular';
  static const String dealsRoutes = '/deals';
  static const String subCatesProducts = '/subcatesproducts';
  static const String apppages = '/app_pages';
  static const String firebaseVerification = '/firebase_verifications';
  static const String firebaseRegisterVerification = '/firebase_register_verification';
  static const String contacts = '/contacts';
  static const String referralRoutes = '/refer';
  static const String wallet = '/wallet';
  static const String addNewAddress = '/add_new_address';
  static const String editProfile = '/edit_profile';
  static const String stripePay = '/stripe_pay';
  static const String newCardStripe = '/new_card_stripe';
  static const String webPayment = '/web_payments';
  static const String orderDetails = '/order_details';
  static const String chatListRoutes = '/chat_list';
  static const String inboxRoutes = '/inbox';
  static const String complaints = '/complaints';
  static const String resetPassword = '/reset_password';
  static const String firebaseResetRoutes = '/firebase_reset';
  static const String updateFirebasePassword = '/update_firebase_password';
  static const String giveReviewsRoutes = '/give_reviews';
  static const String trackingRoutes = '/trackings';

  static String getInitialRoute() => initial;
  static String getSplashRoute() => splash;
  static String getLocationRoute() => location;
  static String getTabsRoute() => tabsRoutes;
  static String getHomeRoute() => homeRoutes;
  static String getCategoryRoute() => category;
  static String getCartRoute() => cartRoutes;
  static String getHistoryRoute() => history;
  static String getAccountRoute() => account;
  static String getSearchRoute() => search;
  static String getOffersRoute() => offers;
  static String getStoreRoutes() => stores;
  static String getSubCategoryRoute() => subCategory;
  static String getTopPickedRoute() => topPicked;
  static String getStoreProductsRoute() => storeProducts;
  static String getCheckoutRoute() => checkout;
  static String getProductRoutes() => product;
  static String getFavouriteRoute() => favourite;
  static String getLanguagesRoute() => languagesRoutes;
  static String getAddressRoute() => address;
  static String getLoginRoute() => loginRoutes;
  static String getRegisterRoute() => register;
  static String getErrorRoute() => error;
  static String getPopularRoute() => popular;
  static String getDealsRoute() => dealsRoutes;
  static String getSubCategoryProductsRoute() => subCatesProducts;
  static String getAppPagesRoute() => apppages;
  static String getFirebaseVerificationRoutes() => firebaseVerification;
  static String getFirebaseRegisterVerificationRoutes() => firebaseRegisterVerification;
  static String getContactRoutes() => contacts;
  static String getReferRoutes() => referralRoutes;
  static String getWalletRoutes() => wallet;
  static String getNewAddressRoutes() => addNewAddress;
  static String getEditProfileRoutes() => editProfile;
  static String getStripePayRoutes() => stripePay;
  static String getNewCardStripeRoutes() => newCardStripe;
  static String getWebPaymentsRoutes() => webPayment;
  static String getOrderDetailsRoutes() => orderDetails;
  static String getChatListRoutes() => chatListRoutes;
  static String getInboxRoutes() => inboxRoutes;
  static String getComplaintsRoutes() => complaints;
  static String getResetPasswordRoutes() => resetPassword;
  static String getFirebaseResetRoutes() => firebaseResetRoutes;
  static String getFirebaseUpdatePasswordRoutes() => updateFirebasePassword;
  static String getGiveReviewsRoutes() => giveReviewsRoutes;
  static String getTrackingRoutes() => trackingRoutes;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const IntroScreen(), binding: IntroBinding()),
    GetPage(name: splash, page: () => const SplashScreen(), binding: SplashBinding()),
    GetPage(name: location, page: () => const LocationScreen(), binding: LocationBinding(), opaque: true),
    GetPage(name: tabsRoutes, page: () => const TabScreen(), binding: TabsBinding()),
    GetPage(name: homeRoutes, page: () => const HomeScreen(), binding: HomeBindings()),
    GetPage(name: category, page: () => const CategoryScreen(), binding: CategorisBinding()),
    GetPage(name: cartRoutes, page: () => const CartScreen(), binding: CartBinding()),
    GetPage(name: history, page: () => const HistoryScreen(), binding: OrderBindings()),
    GetPage(name: account, page: () => const AccountScreen(), binding: AccountBinding()),
    GetPage(name: search, page: () => const SearchScreen(), binding: SearchBinding(), fullscreenDialog: true),
    GetPage(name: offers, page: () => const OffersScreen(), binding: OffersBinding()),
    GetPage(name: stores, page: () => const StoresScreen(), binding: StoresBinding()),
    GetPage(name: subCategory, page: () => const SubCategoryScreen(), binding: SubCategoryBindings(), opaque: true),
    GetPage(name: topPicked, page: () => const TopPickedScreen(), binding: TopPickedBinding()),
    GetPage(name: storeProducts, page: () => const StoreProductsScreen(), binding: StoreProductsBinding()),
    GetPage(name: checkout, page: () => const CheckoutScreen(), binding: CheckoutBinding()),
    GetPage(name: product, page: () => const ProductScreen(), binding: ProductBinding()),
    GetPage(name: favourite, page: () => const FavouriteScreen(), binding: FavouriteBinding()),
    GetPage(name: languagesRoutes, page: () => const LanguageScreen(), binding: LanguageBinding()),
    GetPage(name: address, page: () => const AddressScreen(), binding: AddressBinding()),
    GetPage(name: loginRoutes, page: () => const LoginScreen(), binding: LoginBinding()),
    GetPage(name: register, page: () => const RegisterScreen(), binding: RegisterBinding()),
    GetPage(name: error, page: () => const ErrorScreen()),
    GetPage(name: popular, page: () => const PopularScreen(), binding: PopularBinding()),
    GetPage(name: dealsRoutes, page: () => const DealScreen(), binding: InOfferBinding()),
    GetPage(name: subCatesProducts, page: () => const SubCatesProductScreen(), binding: SubCatesProductBinding()),
    GetPage(name: apppages, page: () => const AppPageScreen(), binding: AppPagesBinding()),
    GetPage(name: firebaseVerification, page: () => const FirebaseVerificationScreen(), binding: FirebaseBinding()),
    GetPage(name: firebaseRegisterVerification, page: () => const FirebaseRegisterScreen(), binding: FirebaseRegisterBinding()),
    GetPage(name: contacts, page: () => const ContactScreen(), binding: ContactBinding()),
    GetPage(name: referralRoutes, page: () => const ReferScreen(), binding: ReferBindings()),
    GetPage(name: wallet, page: () => const WalletScreen(), binding: WalletBinding()),
    GetPage(name: addNewAddress, page: () => const NewAddressScreen(), binding: AddNewAddressBinding()),
    GetPage(name: editProfile, page: () => const EditProfileScreen(), binding: EditProfileBinding()),
    GetPage(name: stripePay, page: () => const StripePayScreen(), binding: StripePayBinding()),
    GetPage(name: newCardStripe, page: () => const NewCardScreen(), binding: NewCardBinding()),
    GetPage(name: webPayment, page: () => const WebPaymentScreen(), binding: WebPaymentsBinding()),
    GetPage(name: orderDetails, page: () => const OrderDetailScreen(), binding: OrderDetailsBinding()),
    GetPage(name: chatListRoutes, page: () => const ChatListScreen(), binding: ChatListBinding()),
    GetPage(name: inboxRoutes, page: () => const InboxScreen(), binding: InboxBinding()),
    GetPage(name: complaints, page: () => const ComplaintScreen(), binding: ComplaintsBinding()),
    GetPage(name: resetPassword, page: () => const ResetPasswordScreen(), binding: ResetPasswordBinding()),
    GetPage(name: firebaseResetRoutes, page: () => const FirebaseResetScreen(), binding: FirebaseResetBinding()),
    GetPage(name: updateFirebasePassword, page: () => const UpdatePasswordFirebaseScreen(), binding: UpdateFirebasePasswordBindings()),
    GetPage(name: giveReviewsRoutes, page: () => const GiveReviewScreen(), binding: GiveReviewsBinding(), fullscreenDialog: true),
    GetPage(name: trackingRoutes, page: () => const TrackingScreen(), binding: TrackingBinding())
  ];
}
