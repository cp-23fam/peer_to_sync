import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends ConsumerWidget {
  const AsyncValueWidget({
    required this.asyncValue,
    required this.onData,
    this.onError,
    this.onLoading,
    super.key,
  });

  final AsyncValue<T> asyncValue;
  final Widget Function(T data) onData;
  final Widget Function(Object e, StackTrace st)? onError;
  final Widget Function()? onLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return asyncValue.when(
      data: onData,
      error:
          onError ??
          (error, stackTrace) {
            debugPrint(stackTrace.toString());

            return Center(child: Text(error.toString()));
          },
      loading:
          onLoading ?? () => const Center(child: CircularProgressIndicator()),
    );
  }
}
