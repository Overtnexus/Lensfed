class ApiConstants {
  static const String baseUrl = "http://192.168.1.43:5000";

  static const String addUnit = "/api/units/add-unit";
  static const String getUnits = "/api/units";
  static const String updateUnit = "/api/units/";   // + id
  static const String deleteUnit = "/api/units/";   // + id

  static const String addpayments = "/api/payments";
  static const String getpayments = "/api/payments";
  static const String updatepayments = "/api/payments/";   // + id
  static const String deletepayments = "/api/payments/";   // + id

  static const String addcheckinout = "/api/checkinout";
  static const String getcheckinout = "/api/checkinout";
  static const String updatecheckinout = "/api/checkinout/";   // + id
  static const String deletecheckinout = "/api/checkinout/";   // + id

  static const String addmembersshipreniew = "/api/membersshipreniew";
  static const String getmembersshipreniew = "/api/membersshipreniew";
  static const String updatemembersshipreniew = "/api/membersshipreniew/";   // + id
  static const String deletemembersshipreniew = "/api/membersshipreniew/"; 
    static const String checkmembership = "/api/check-membership/";


  static const String addmembers = "/api/addmembers";
  static const String getmembers = "/api/members";
  static const String updatemembers = "/api/members/";   // + id
  static const String deletemembers = "/api/members/"; 

  
  static const String add = "/api/addmembers";
  static const String get = "/api/members";
  static const String update = "/api/members/";   // + id
  static const String delete = "/api/members/"; 

  static const String addmeetings = "/api/addmeetings";
  static const String getmeetings = "/api/meetings";
  static const String updatemeetings = "/api/meetings/";   // + id
  static const String deletemeetings = "/api/meetings/"; 

  static const String addNotification = "/api/notifications/add-notification";
  static const String getNotification = "/api/notifications/get-all";
  static const String getNotificationRolewise = "/api/notifications/user/:role";
  static const String updateNotification = "/api/notifications/update/";   // + id
  static const String deleteNotification = "/api/notifications/delete/"; 
  static const String TokenNotification = "/api/save-device-token";

  static const String loginadmin = "/api/admin/login"; 
  static const String getnadmin = "/api/admins"; 
  static const String updateadmin = "/api/admins/update"; 

//////////////////MOBILE APP ///

  static const String registerapi = "/api/register";
  static const String loginapi = "/api/login";
  static const String updatepassword = "/api/updatePassword";   // + id
  static const String sendOTP = "/api/sendOtp"; 
  static const String verifyOTP = "/api/verifyOtp"; 
   static const String sendOTPforgot = "/api/forgot/sendOtp"; 
  static const String verifyOTPforgot = "/api/forgot/verifyOtp"; 

  static const String getAddapi = "/api/ads/list";
   static const String filterAddapi = "/api/ads/filter";
}
