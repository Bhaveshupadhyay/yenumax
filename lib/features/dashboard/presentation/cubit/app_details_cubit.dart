import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shawn/core/common/state/data_state.dart';
import 'package:shawn/features/dashboard/model/app_details_model.dart';

class AppDetailsCubit extends Cubit<DataState>{
  AppDetailsCubit():super(DataInitial());

  Future<void> loadAppData() async {
    emit(DataLoading());
    final packageInfo= await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    emit(DataLoaded<AppDetailsModel>(
        data: AppDetailsModel(appName: appName, packageName: packageName,
            version: version, buildNumber: buildNumber)));


  }

}
