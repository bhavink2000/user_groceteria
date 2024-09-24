/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Grocery Full App Flutter
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2024-present initappz.
*/
import 'package:get/get.dart';
import 'package:user/app/backend/models/delivery_options_model.dart';
import 'package:user/app/backend/models/delivery_time_model.dart';
import 'package:user/app/backend/models/language_model.dart';
import 'package:user/app/env.dart';
import 'package:jiffy/jiffy.dart';

class AppConstants {
  static const String appName = Environments.appName;
  static const String companyName = Environments.companyName;
  static const String defaultCurrencyCode = 'USD'; // your currency code in 3 digit
  static const String defaultCurrencySide = 'right'; // default currency position
  static const String defaultCurrencySymbol = '\$'; // default currency symbol
  static const int defaultMakeingOrder = 0; // 0=> from multiple stores // 1 = single store only
  static const String defaultSMSGateway = '1'; // 2 = firebase // 1 = rest
  static const int defaultVerificationForSignup = 0; // 0 = email // 1= phone
  static const int userLogin = 0;
  static const String defaultShippingMethod = 'km';
  static const String defaultLanguageApp = 'en';

  // API Routes
  static const String appSettings = 'api/v1/settings/getDefault';
  static const String activeCities = 'api/v1/cities/getActiveCities';
  static const String withCity = 'api/v1/home/searchWithCity';
  static const String withGeoLocation = 'api/v1/home/searchWithGeoLocation';
  static const String withZipcode = 'api/v1/home/searchWithZipCode';
  static const String getSubCategories = 'api/v1/subCategories/getFromCateId';
  static const String getCategories = 'api/v1/category/getHome';
  static const String getOffers = 'api/v1/banners/userBanners';
  static const String storesWithCity = 'api/v1/home/searchStoreWithCity';
  static const String storesWithGeoLocation = 'api/v1/home/searchStoreWithGeoLocation';
  static const String storeWithZipcode = 'api/v1/home/searchStoreWithZipCode';
  static const String getTopRated = 'api/v1/products/getTopRated';
  static const String getInOffers = 'api/v1/products/getInOffers';
  static const String getStoreProducts = 'api/v1/products/getByStoreId';
  static const String searchQuery = 'api/v1/products/searchQuery';
  static const String getProductsWithSubCategory = 'api/v1/products/getWithSubCategory';
  static const String getSubCategoriesProduct = 'api/v1/products/getWithSubCategoryId';
  static const String getSingleProduct = 'api/v1/products/getById';
  static const String updateFav = 'api/v1/favourite/update';
  static const String addToFav = 'api/v1/favourite/create';
  static const String pageContent = 'api/v1/pages/getContent';
  static const String register = 'api/v1/auth/create_account';
  static const String login = 'api/v1/auth/login';
  static const String loginWithPhonePassword = 'api/v1/auth/loginWithPhonePassword';
  static const String verifyPhone = 'api/v1/otp/verifyPhone';
  static const String verifyPhoneFirebase = 'api/v1/auth/verifyPhoneForFirebase';
  static const String openFirebaseVerification = 'api/v1/auth/firebaseauth?';
  static const String verifyOTP = 'api/v1/otp/verifyOTP';
  static const String loginWithMobileToken = 'api/v1/auth/loginWithMobileOtp';
  static const String sendVerificationMail = 'api/v1/sendVerificationOnMail';
  static const String sendVerificationSMS = 'api/v1/verifyPhoneSignup';
  static const String verifyMobileForeFirebase = 'api/v1/auth/verifyPhoneForFirebaseRegistrations';
  static const String redeemReferral = 'api/v1/referral/redeemReferral';
  static const String saveaContacts = 'api/v1/contacts/create';
  static const String sendMailToAdmin = 'api/v1/sendMailToAdmin';
  static const String logout = 'api/v1/auth/logout';
  static const String getProfileData = 'api/v1/profile/byId';
  static const String getMyFavList = 'api/v1/favourite/getMyFav';
  static const String getMyReferralCode = 'api/v1/referralcode/getMyCode';
  static const String getMyWallet = 'api/v1/profile/getMyWallet';
  static const String getMyAddress = 'api/v1/address/getByUid';
  static const String saveAddress = 'api/v1/address/addNew';
  static const String updateAddress = 'api/v1/address/updateMyAddress';
  static const String deleteAddress = 'api/v1/address/deleteMyAddress';
  static const String uploadImage = 'api/v1/uploadImage';
  static const String updateProfile = 'api/v1/profile/update';
  static const String cartStoreList = 'api/v1/stores/getStoresData';
  static const String getMyWalletBalance = 'api/v1/profile/getMyWalletBalance';
  static const String getCouponsList = 'api/v1/offers/getMyOffers';
  static const String getPaymentsList = 'api/v1/payments/getPayments';
  static const String createOrder = 'api/v1/orders/create';
  static const String getOrders = 'api/v1/orders/getByUid';
  static const String createStripeToken = 'api/v1/payments/createStripeToken';
  static const String addStripeCard = 'api/v1/payments/addStripeCards';
  static const String createStripeCustomer = 'api/v1/payments/createCustomer';
  static const String getStripeCards = 'api/v1/payments/getStripeCards';
  static const String stripeCheckout = 'api/v1/payments/createStripePayments';
  static const String payPalPayLink = 'api/v1/payments/payPalPay?amount=';
  static const String payTmPayLink = 'api/v1/payNow?amount=';
  static const String razorPayLink = 'api/v1/payments/razorPay?';
  static const String verifyRazorPayments = 'api/v1/payments/VerifyRazorPurchase?id=';
  static const String payWithInstaMojo = 'api/v1/payments/instamojoPay';
  static const String paystackCheckout = 'api/v1/payments/paystackPay?';
  static const String flutterwaveCheckout = 'api/v1/payments/flutterwavePay?';
  static const String getOrderDetails = 'api/v1/orders/getByOrderId';
  static const String getInvoice = 'api/v1/orders/printInvoice?id=';
  static const String getChatRooms = 'api/v1/chats/getChatRooms';
  static const String createChatRooms = 'api/v1/chats/createChatRooms';
  static const String getChatList = 'api/v1/chats/getById';
  static const String sendMessage = 'api/v1/chats/sendMessage';
  static const String getChatConversionList = 'api/v1/chats/getChatListBUid';
  static const String registerComplaints = 'api/v1/complaints/registerNewComplaints';
  static const String resetWithEmail = 'api/v1/auth/verifyEmailForReset';
  static const String verifyOTPForReset = 'api/v1/otp/verifyOTPReset';
  static const String updatePasswordWithToken = 'api/v1/password/updateUserPasswordWithEmail';
  static const String updatePasswordWithPhoneToken = 'api/v1/password/updateUserPasswordWithPhone';
  static const String updateOrderStatus = 'api/v1/orders/updateStatusUser';
  static const String generateTokenFromCreds = 'api/v1/otp/generateTempToken';
  static const String updatePasswordWithFirebase = 'api/v1/password/updatePasswordFromFirebase';
  static const String getStoreRatings = 'api/v1/ratings/getByStoreId';
  static const String saveStoreRatings = 'api/v1/ratings/saveStoreRatings';
  static const String getProductRatings = 'api/v1/ratings/getByProductId';
  static const String saveProductRatings = 'api/v1/ratings/saveProductRatings';
  static const String getDriverRatings = 'api/v1/ratings/getByDriverId';
  static const String saveDriverRatings = 'api/v1/ratings/saveDriversRatings';
  static const String getDriverInfo = 'api/v1/driverInfo/byId';
  static const String sendMailOrder = 'api/v1/orders/sendMailForOrders';
  // API Routes

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'عربي', countryCode: 'AE', languageCode: 'ar'),
    LanguageModel(imageUrl: '', languageName: 'हिन्दी', countryCode: 'IN', languageCode: 'hi'),
    LanguageModel(imageUrl: '', languageName: 'Español', countryCode: 'De', languageCode: 'es'),
  ];

  static List<DeliveryOptionModel> deliveryOptions = [
    DeliveryOptionModel(id: 'home', name: 'At Home', image: 'assets/images/home.png'),
    DeliveryOptionModel(id: 'store', name: 'Self Pickup', image: 'assets/images/store.png'),
  ];

  static List<DeliveryTimeModel> deliveryTimes = [
    DeliveryTimeModel(id: 'today', name: 'Today - '.tr + Jiffy().yMMMMd),
    DeliveryTimeModel(id: 'tomorrow', name: 'Tomorrow - '.tr + Jiffy().add(days: 1).yMMMMd),
  ];
}
