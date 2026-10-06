/// Path constants matching Freedom Smile Postman collection + Express routes.
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const signup = '/auth/signup';
  static const login = '/auth/login';
  static const socialLogin = '/auth/social-login';
  static const verifyOtp = '/auth/verify-otp';
  static const sendOtp = '/auth/send-otp';
  static const forgotPassword = '/auth/forgot-password';
  static const createProfile = '/auth/create-profile';
  static const updateProfile = '/auth/update-profile';
  static const profile = '/auth/profile';
  static const sendPhoneOtp = '/auth/send-phone-otp';
  static const verifyPhone = '/auth/verify-phone';
  static const changePassword = '/auth/change-password';
  static const resetPassword = '/auth/reset-password';
  static const updateLocation = '/auth/update-location';
  static const notificationToggle = '/auth/notification-toggle';
  static const language = '/auth/language';
  static const logout = '/auth/logout';
  static const deleteAccount = '/auth/delete-account';

  // Public content
  static const faqs = '/content/faqs';
  static const languages = '/content/languages';
  static const rewardTiers = '/content/reward-tiers';
  static String cms(String slug) => '/content/cms/$slug';

  // Patient (User)
  static const userHome = '/user/home';
  static const userSettings = '/user/settings';
  static const userRetainer = '/user/retainer';
  static const userRetainerOrders = '/user/retainer/orders';
  static const userRetainerReorder = '/user/retainer/reorder';
  static const userWearMark = '/user/wear/mark';
  static const userWearStats = '/user/wear/stats';
  static const userFitCheck = '/user/fit-check';
  static const userReminders = '/user/reminders';
  static String userReminder(String id) => '/user/reminders/$id';
  static const userTipCategories = '/user/tip-categories';
  static const userTips = '/user/tips';
  static String userTip(String id) => '/user/tips/$id';
  static const userOrthodontists = '/user/orthodontists';
  static String userOrthodontist(String id) => '/user/orthodontists/$id';
  static String userOrthodontistSlots(String id) =>
      '/user/orthodontists/$id/slots';
  static const userAppointments = '/user/appointments';
  static String userAppointment(String id) => '/user/appointments/$id';
  static String userAppointmentCancel(String id) =>
      '/user/appointments/$id/cancel';
  static const userReferrals = '/user/referrals';
  static const userReferralsApply = '/user/referrals/apply';
  static const userNotifications = '/user/notifications';
  static String userNotification(String id) => '/user/notifications/$id';
  static String userNotificationRead(String id) =>
      '/user/notifications/$id/read';
  static String userNotificationAction(String id) =>
      '/user/notifications/$id/action';
  static const userChats = '/user/chats';
  static String userChat(String id) => '/user/chats/$id';
  static String userChatMessages(String id) => '/user/chats/$id/messages';

  // Orthodontist
  static const orthoProfile = '/orthodontist/profile';
  static const orthoAppointments = '/orthodontist/appointments';
  static String orthoAppointment(String id) => '/orthodontist/appointments/$id';
  static const orthoChats = '/orthodontist/chats';
  static String orthoChat(String id) => '/orthodontist/chats/$id';
  static String orthoChatMessages(String id) =>
      '/orthodontist/chats/$id/messages';

  // Admin
  static const adminDashboard = '/admin/dashboard';
  static const adminUsers = '/admin/users';
  static String adminUser(String id) => '/admin/users/$id';
  static const adminOrthodontists = '/admin/orthodontists';
  static String adminOrthodontist(String id) => '/admin/orthodontists/$id';
  static const adminAppointments = '/admin/appointments';
  static String adminAppointment(String id) => '/admin/appointments/$id';
  static const adminCategories = '/admin/categories';
  static String adminCategory(String id) => '/admin/categories/$id';
  static const adminTips = '/admin/tips';
  static String adminTip(String id) => '/admin/tips/$id';
  static const adminFaqs = '/admin/faqs';
  static String adminFaq(String id) => '/admin/faqs/$id';
  static const adminCms = '/admin/cms';
  static String adminCmsSlug(String slug) => '/admin/cms/$slug';
  static const adminRewards = '/admin/rewards';
  static String adminReward(String id) => '/admin/rewards/$id';
  static const adminReferrals = '/admin/referrals';
  static String adminReferral(String id) => '/admin/referrals/$id';
  static const adminNotifications = '/admin/notifications';
  static const adminRetainerOrders = '/admin/retainer-orders';
  static String adminRetainerOrder(String id) => '/admin/retainer-orders/$id';
  static const adminChats = '/admin/chats';
  static String adminChat(String id) => '/admin/chats/$id';
  static String adminChatMessages(String id) => '/admin/chats/$id/messages';

  // Seed
  static const seed = '/seed';
}
