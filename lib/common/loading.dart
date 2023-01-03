import 'package:flutter/material.dart';

class LoadingHandler extends StatefulWidget {
  final Widget Function(BuildContext, dynamic) builder;
  final Widget Function() loading;
  final Future Function() future;

  const LoadingHandler({
    Key? key,
    required this.builder,
    required this.loading,
    required this.future,
  }) : super(key: key);

  @override
  State<LoadingHandler> createState() => _LoadingHandlerState();
}

class _LoadingHandlerState extends State<LoadingHandler> {
  late final Future _future;

  @override
  void initState() {
    _future = widget.future();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) =>
      snapshot.connectionState == ConnectionState.done
          ? widget.builder(context, snapshot.data)
          : widget.loading(),
    );
  }
}

class CircularLoading extends StatelessWidget {
  final double topPadding;

  const CircularLoading({Key? key, this.topPadding = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}