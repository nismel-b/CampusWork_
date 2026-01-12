import 'package:go_router/go_router.dart';
import 'package:campuswork/auth/auth_service.dart';
import 'package:campuswork/model/user.dart';
import 'package:campuswork/auth/login_page.dart';
import 'package:campuswork/auth/register_page.dart';
import 'package:campuswork/screen/screen_student/dashboard/dashboard.dart';
import 'package:campuswork/screen/screen_student/projects/projects_list_page.dart';
import 'package:campuswork/screen/screen_student/projects/create_project.dart';
import 'package:campuswork/screen/screen_student/profile/student_profile_page.dart';
import 'package:campuswork/screen/screen_student/team/team_page.dart';
import 'package:campuswork/screen/screen_student/courses/courses_page.dart';
import 'package:campuswork/screen/screen_lecturer/dashboard/dashboard.dart';
import 'package:campuswork/screen/screen_admin/dashboard/dashboard.dart';
import 'package:campuswork/screen/profile/profile_settings.dart';
import 'package:campuswork/screen/surveys/create_survey_page.dart';
import 'package:campuswork/screen/collaboration/collaboration_requests_page.dart';
import 'package:campuswork/screen/common_screen/notifications_pages.dart';
import 'package:campuswork/screen/common_screen/feed_page.dart';
import 'package:campuswork/screen/common_screen/create_post_page.dart';
import 'package:campuswork/splash_screen/splash_screen.dart';
import 'package:campuswork/onboarding_screen.dart';
import 'package:campuswork/screen/tutorial/tutorial_screen.dart';
import 'package:campuswork/services/tutorial_service.dart';
import 'package:campuswork/utils/page_transitions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campuswork/screen/home/home_page.dart';
import 'package:campuswork/screen/messages/messages_page.dart';
import 'package:campuswork/widgets/main_navigation.dart';

final router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    // Allow splash screen to show first
    if (state.uri.path == '/splash') {
      return null;
    }

    // Allow onboarding screen
    if (state.uri.path == '/onboarding') {
      return null;
    }

    // Allow tutorial screens
    if (state.uri.path.startsWith('/tutorial/')) {
      return null;
    }

    final isLoggedIn = AuthService().isLoggedIn;
    final currentUser = AuthService().currentUser;

    if (!isLoggedIn && state.uri.path != '/' && state.uri.path != '/register') {
      return '/';
    }

    if (isLoggedIn && (state.uri.path == '/' || state.uri.path == '/student-dashboard' || state.uri.path == '/lecturer-dashboard' || state.uri.path == '/admin-dashboard')) {
      return '/main';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => PageTransitions.rotationScaleTransition(
        const SplashScreen(),
        state,
      ),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => PageTransitions.fadeTransition(
        const OnboardingScreen(),
        state,
      ),
    ),
    GoRoute(
      path: '/tutorial/:role',
      pageBuilder: (context, state) {
        final roleString = state.pathParameters['role']!;
        final userRole = UserRole.values.firstWhere(
          (role) => role.name == roleString,
          orElse: () => UserRole.student,
        );
        return PageTransitions.slideTransition(
          TutorialScreen(userRole: userRole),
          state,
        );
      },
    ),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => PageTransitions.fadeTransition(
        const LoginPage(),
        state,
      ),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => PageTransitions.slideTransition(
        const RegisterPage(),
        state,
      ),
    ),
    GoRoute(
      path: '/main',
      pageBuilder: (context, state) => PageTransitions.fadeTransition(
        const MainNavigation(),
        state,
      ),
    ),
    GoRoute(
      path: '/student-dashboard',
      pageBuilder: (context, state) => PageTransitions.scaleTransition(
        const StudentDashboard(),
        state,
      ),
    ),
    GoRoute(
      path: '/lecturer-dashboard',
      pageBuilder: (context, state) => PageTransitions.scaleTransition(
        const LecturerDashboard(),
        state,
      ),
    ),
    GoRoute(
      path: '/admin-dashboard',
      pageBuilder: (context, state) => PageTransitions.scaleTransition(
        const AdminDashboard(),
        state,
      ),
    ),
    GoRoute(
      path: '/projects',
      pageBuilder: (context, state) => PageTransitions.slideTransition(
        ProjectsListPage(currentUser: AuthService().currentUser!),
        state,
      ),
    ),
    GoRoute(
      path: '/create-project',
      pageBuilder: (context, state) => PageTransitions.slideUpTransition(
        const CreateProjectPage(),
        state,
      ),
    ),
    GoRoute(
      path: '/my-projects',
      pageBuilder: (context, state) => PageTransitions.slideTransition(
        ProjectsListPage(currentUser: AuthService().currentUser!),
        state,
      ),
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) => PageTransitions.slideTransition(
        const NotificationsPage(),
        state,
      ),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => PageTransitions.slideTransition(
        StudentProfilePage(currentUser: AuthService().currentUser!),
        state,
      ),
    ),
    GoRoute(
      path: '/settings',
      pageBuilder: (context, state) => PageTransitions.slideTransition(
        ProfileSettingsPage(currentUser: AuthService().currentUser!),
        state,
      ),
    ),
    GoRoute(
      path: '/profile-settings',
      pageBuilder: (context, state) {
        final user = state.extra as User?;
        return PageTransitions.slideTransition(
          ProfileSettingsPage(currentUser: user ?? AuthService().currentUser!),
          state,
        );
      },
    ),
    GoRoute(
      path: '/team',
      pageBuilder: (context, state) => PageTransitions.slideTransition(
        TeamPage(currentUser: AuthService().currentUser!),
        state,
      ),
    ),
    GoRoute(
      path: '/courses',
      pageBuilder: (context, state) => PageTransitions.slideTransition(
        CoursesPage(currentUser: AuthService().currentUser!),
        state,
      ),
    ),
    GoRoute(
      path: '/feed',
      pageBuilder: (context, state) => PageTransitions.slideTransition(
        const FeedPage(),
        state,
      ),
    ),
    GoRoute(
      path: '/create-post',
      pageBuilder: (context, state) => PageTransitions.slideUpTransition(
        const CreatePostPage(),
        state,
      ),
    ),
    GoRoute(
      path: '/create-survey',
      pageBuilder: (context, state) => PageTransitions.slideUpTransition(
        CreateSurveyPage(currentUser: AuthService().currentUser!),
        state,
      ),
    ),
    GoRoute(
      path: '/collaboration-requests',
      pageBuilder: (context, state) => PageTransitions.slideTransition(
        CollaborationRequestsPage(currentUser: AuthService().currentUser!),
        state,
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => PageTransitions.fadeTransition(
        const HomePage(),
        state,
      ),
    ),
    GoRoute(
      path: '/messages',
      pageBuilder: (context, state) => PageTransitions.slideTransition(
        const MessagesPage(),
        state,
      ),
    ),
  ],
);
