import 'package:flutter/material.dart';

class StatWidget extends StatelessWidget {
  final String title;
  final String statValue;
  final bool isLoading;
  final Future<void> Function()? fetchFunction;

  const StatWidget({
    super.key,
    required this.title,
    required this.statValue,
    required this.isLoading,
    required this.fetchFunction,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(statValue),
      trailing: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: fetchFunction,
            ),
    );
  }
}
