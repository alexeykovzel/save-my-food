import 'package:flutter/material.dart';
import 'package:save_my_food/theme.dart';

class LoadingHandler extends StatefulWidget {
  final Future Function() future;
  final Widget Function() loading;
  final Widget Function(BuildContext, dynamic) builder;

  const LoadingHandler({
    Key? key,
    required this.future,
    required this.loading,
    required this.builder,
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
      child: Center(
        child: CircularProgressIndicator(
          color: HexColor.pink.get(),
        ),
      ),
    );
  }
}
