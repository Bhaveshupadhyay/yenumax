import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shawn/core/common/cubit/continue_watching_cubit.dart';
import 'package:shawn/core/common/cubit/watchlist_cubit.dart';
import 'package:shawn/core/service/token_api.dart';
import 'package:shawn/core/theme/theme.dart';
import 'package:shawn/features/about_content/presentation/cubit/episodes_cubit.dart';
import 'package:shawn/features/auth/presentation/screens/login.dart';
import 'package:shawn/features/dashboard/presentation/cubit/app_details_cubit.dart';
import 'package:shawn/features/dashboard/presentation/cubit/pageview_cubit.dart';
import 'package:shawn/features/dashboard/presentation/cubit/search_cubit.dart';
import 'package:shawn/features/dashboard/presentation/cubit/slider_cubit.dart';
import 'package:shawn/features/dashboard/presentation/screens/account.dart';
import 'package:shawn/features/dashboard/presentation/screens/search.dart';
import 'package:shawn/features/payment/presentation/screens/payment_screen.dart';
import 'package:shawn/features/subscription/presentation/cubit/subscription_cubit.dart';

import 'core/service/network_api.dart';
import 'features/dashboard/presentation/cubit/home_cubit.dart';
import 'features/dashboard/presentation/screens/home.dart';
import 'features/video_play/presentation/cubits/video_link_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenApi.clearOnFreshInstall();
  await TokenApi.getCookie();
  runApp(ScreenUtilInit(
    designSize: const Size(430, 932),
    minTextAdapt: true,
    splitScreenMode: true,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create)=>AppDetailsCubit()..loadAppData()),
        BlocProvider(create: (create)=>HomeCubit(api: DioApi())),
        BlocProvider(create: (create)=>SliderCubit()),
        BlocProvider(create: (create)=>SearchCubit()),
        BlocProvider(create: (create)=>PageViewCubit()),
        BlocProvider(create: (create)=>SubscriptionCubit()..getSubscription()),
        BlocProvider(create: (create)=>WatchlistCubit()),
        BlocProvider(create: (create)=>ContinueWatchingCubit()),
        BlocProvider(create: (BuildContext context)=>VideoLinkCubit())
      ],
      child: MaterialApp(
        title: 'Yenumax',
        theme: AppTheme.dark(),
        home:  const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _screens=[Home(), Search(), Account()];
  int _currentIndex=0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index){
          if(index==2){
            context.read<WatchlistCubit>().loadWatchList();
          }
          setState(() {
            _currentIndex=index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,),
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,),
            label: 'Search'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,),
            label: 'Account'
          ),
        ],
      ),
    );
  }
}

