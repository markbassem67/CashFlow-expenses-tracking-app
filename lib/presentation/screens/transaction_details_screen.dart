import 'package:flutter/material.dart';

import '../widgets/arc_container.dart';

class TransactionDetails extends StatelessWidget {
  const TransactionDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          Stack(
            children: [ArcContainer(height: 287).buildArcContainer(context)],
          ),
        ],
      ),
    );
  }
}
