import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/constants.dart';
import '../../error/failure_widget.dart';
import '../../utils/loading_widget.dart';
import '../bloc/timing_bloc.dart';

class PrayerTimingScreen extends StatelessWidget {
  const PrayerTimingScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimingBloc(),
      child: TimingScreenScaffold(),
    );
  }
}

class TimingScreenScaffold extends StatefulWidget {
  const TimingScreenScaffold();

  @override
  State<TimingScreenScaffold> createState() => _TimingScreenScaffoldState();
}

class _TimingScreenScaffoldState extends State<TimingScreenScaffold> {
  @override
  void didChangeDependencies() {
    BlocProvider.of<TimingBloc>(context).add(RequestTiming());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('prayer timing'),
      ),
      body: BlocBuilder<TimingBloc, TimingState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: kAnimationDuration,
            reverseDuration: Duration.zero,
            switchInCurve: kAnimationCurve,
            child: (state is TimingLoading)
                ? LoadingWidget()
                : (state is TimingLoaded)
                    ? Column(
                        children: [
                          Text(state.timing.data.timings.asr),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              '123',
                            ),
                          )
                        ],
                      )
                    : (state is TimingFailed)
                        ? FailureWidget(
                            state.failure,
                            () {
                              BlocProvider.of<TimingBloc>(context).add(
                                RequestTiming(),
                              );
                            },
                          )
                        : Container(),
          );
        },
      ),
    );
  }
}