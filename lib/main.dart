import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/blocs/reminder_bloc/reminder_bloc.dart';
import 'package:reminder/core/local_storage_repository.dart';
import 'package:reminder/core/repository_service.dart';
import 'package:reminder/values/strings.dart';
import 'package:reminder/styles/themes.dart';
import 'package:reminder/views/reminder_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferencesWithCache, SharedPreferencesWithCacheOptions;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocalStorageRepository repository = LocalStorageRepository(
    sharedPreference: await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    ),
  );

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runApp(MyApp(
    createReminderRepositoryService: () => RepositoryService(repository),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.createReminderRepositoryService,
  });

  final RepositoryService Function() createReminderRepositoryService;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<RepositoryService>(
      create: (_) => createReminderRepositoryService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ReminderBloc(repository: context.read<RepositoryService>())..add(LoadReminders()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: Strings.appName,
          theme: AppTheme.light,
          home: const ReminderListPage(),
        ),
      ),
    );
  }
}
