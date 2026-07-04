import 'package:depi_project/core/routing/routes.dart';
import 'package:depi_project/features/home_view/presentation/views/home_view.dart';
import 'package:depi_project/features/details/presentation/view/details_screen.dart';
import 'package:flutter/material.dart';

import '../../features/Auth/presentation/view/forget password/forget_password.dart';
import '../../features/Auth/presentation/view/email verifiy/VerifyEmailPage_mobile_layout.dart';
import '../../features/Auth/presentation/view/Sign in/sign_in.dart';
import '../../features/Auth/presentation/view/sign up/sign_up.dart';
import '../../features/my_visit_places/data/model.dart';
import '../../features/profile/view/profile.dart';
import '../../features/notification/presentation/view/notification_screen.dart';
import '../../features/display_map/view/page_map.dart';
import '../../features/my_visit_places/presentation/view/saved_screen.dart';
import '../../features/my_visit_places/presentation/view/trips_screen.dart';
import '../../features/my_visit_places/presentation/view/create_trip_screen.dart';
import '../../features/my_visit_places/presentation/view/trip_details_screen.dart';

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    debugPrint("CURRENT ROUTE = ${settings.name}");

    switch (settings.name) {
      case Routes.signIn:
        return MaterialPageRoute(builder: (_) => const SignIn());
      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUp());
      case Routes.forgetPass:
        return MaterialPageRoute(builder: (_) => const ForgetPassword());
      case Routes.homePage:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.verifyEmail:
        return MaterialPageRoute(builder: (_) => const VerifyEmailPage());
      case Routes.notif:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const Profile());
      case Routes.details:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final PlaceModel place;
        if (args['place'] is PlaceModel) {
          place = args['place'];
        } else {
          place = PlaceModel(
            id: args['id']?.toString() ?? '',
            name: args['name'] ?? '',
            image: args['image'] ?? '',
            location: args['location'] ?? 'Egypt',
            rating: (args['rating'] ?? 4.5).toDouble(),
            category: args['category'] ?? 'general',
            description: args['description'] ?? '',
          );
        }
        return MaterialPageRoute(builder: (_) => DetailsScreen(place: place));
      case Routes.page_map:
        final args =
            settings.arguments as Map<String, dynamic>? ??
            {'lat': 30.0444, 'lon': 31.2357};
        return MaterialPageRoute(
          builder: (_) =>
              MapPage(lat: args['lat'] ?? 30.0444, lon: args['lon'] ?? 31.2357),
        );
      case Routes.savedPlaces:
        return MaterialPageRoute(builder: (_) => const SavedScreen());
      case Routes.createTrip:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => CreateTripScreen(
            trip: args['trip'],
            tripIndex: args['tripIndex'],
          ),
        );
      case Routes.trips:
        return MaterialPageRoute(builder: (_) => const TripsScreen());
      case Routes.tripDetails:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => TripDetailsScreen(tripData: args['tripData'] ?? {}),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                "Not found page",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
    }
  }
}
