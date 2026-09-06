import 'package:flutter/material.dart';
import '../../data/models/doctor_model.dart';
import '../../presentation/appointments/my_appointments_screen.dart';
import '../../presentation/auth/forgot_password/forgot_password_screen.dart';
import '../../presentation/auth/login/login_screen.dart';
import '../../presentation/auth/register/register_screen.dart';
import '../../presentation/booking/booking_confirmation_screen.dart';
import '../../presentation/booking/booking_cubit.dart';
import '../../presentation/booking/booking_details_screen.dart';
import '../../presentation/booking/select_date_screen.dart';
import '../../presentation/booking/select_time_screen.dart';
import '../../presentation/doctor_details/doctor_details_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/home/search_screen.dart';
import '../../presentation/profile/profile_screen.dart';
import '../../presentation/splash/splash_screen.dart';
import 'app_routes.dart';

/// Central place that maps route names to screens, including passing
/// typed arguments (DoctorModel, BookingCubit) between booking steps.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashScreen());

      case AppRoutes.login:
        return _page(const LoginScreen());

      case AppRoutes.register:
        return _page(const RegisterScreen());

      case AppRoutes.forgotPassword:
        return _page(const ForgotPasswordScreen());

      case AppRoutes.home:
        return _page(const HomeScreen());

      case AppRoutes.search:
        final category = settings.arguments as String?;
        return _page(SearchScreen(initialCategory: category));

      case AppRoutes.doctorDetails:
        final doctor = settings.arguments as DoctorModel;
        return _page(DoctorDetailsScreen(doctor: doctor));

      case AppRoutes.selectDate:
        final doctor = settings.arguments as DoctorModel;
        return _page(SelectDateScreen(doctor: doctor));

      case AppRoutes.selectTime:
        final cubit = settings.arguments as BookingCubit;
        return _page(SelectTimeScreen(bookingCubit: cubit));

      case AppRoutes.bookingDetails:
        final cubit = settings.arguments as BookingCubit;
        return _page(BookingDetailsScreen(bookingCubit: cubit));

      case AppRoutes.bookingConfirmation:
        final cubit = settings.arguments as BookingCubit;
        return _page(BookingConfirmationScreen(bookingCubit: cubit));

      case AppRoutes.myAppointments:
        return _page(const MyAppointmentsScreen());

      case AppRoutes.profile:
        return _page(const ProfileScreen());

      default:
        return _page(Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ));
    }
  }

  static MaterialPageRoute _page(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}
