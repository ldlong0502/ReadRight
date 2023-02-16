

import 'package:flutter/material.dart';

import '../util/api_request_status.dart';
import 'error_widget.dart';
import 'loading_widget.dart';

class BuildBody extends StatelessWidget {
  const BuildBody({super.key, required this.apiRequestStatus, required this.child, required this.reload});
  final APIRequestStatus apiRequestStatus;
  final Widget child;
  final Function reload;
  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
   Widget _buildBody() {
    switch (apiRequestStatus) {
      case APIRequestStatus.loading:
        return const LoadingWidget();
      case APIRequestStatus.unInitialized:
        return const LoadingWidget();
      case APIRequestStatus.connectionError:
        return MyErrorWidget(
          refreshCallBack: reload,
          isConnection: true,
        );
      case APIRequestStatus.error:
        return MyErrorWidget(
          refreshCallBack: reload,
          isConnection: false,
        );
      case APIRequestStatus.loaded:
        return child;
      default:
        return const LoadingWidget();
    }
  }
}