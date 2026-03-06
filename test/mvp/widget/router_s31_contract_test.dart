import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  GoRouter _router() {
    return GoRouter(
      initialLocation: '/task/task-1/settlement/preview',
      routes: [
        GoRoute(
          path: '/task/:taskId',
          builder: (_, __) => const SizedBox.shrink(),
          routes: [
            GoRoute(
              path: 'settlement/preview',
              name: 'S30',
              builder: (context, state) => _PushS31Button(taskId: state.pathParameters['taskId']!),
              routes: [
                GoRoute(
                  path: 'settlement/payment',
                  name: 'S31',
                  builder: (context, state) {
                    final taskId = state.pathParameters['taskId']!;
                    final extra = state.extra as Map<String, dynamic>? ?? {};
                    final checkPoint = extra['checkPointPoolBalance'] as double;
                    final mergeMap = extra['mergeMap'] as Map<String, List<String>>;

                    return Column(
                      children: [
                        Text('taskId=$taskId'),
                        Text('checkpoint=$checkPoint'),
                        Text('mergeHeads=${mergeMap.length}'),
                        Text('u1Children=${mergeMap['u1']?.join('|') ?? ''}'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  testWidgets('router contract: pushNamed(S31) should carry path + extra payload',
      (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: _router()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Go S31'));
    await tester.pumpAndSettle();

    expect(find.text('taskId=task-1'), findsOneWidget);
    expect(find.text('checkpoint=100.0'), findsOneWidget);
    expect(find.text('mergeHeads=2'), findsOneWidget);
    expect(find.text('u1Children=u2|u3'), findsOneWidget);
  });
}

class _PushS31Button extends StatelessWidget {
  const _PushS31Button({required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.pushNamed(
            'S31',
            pathParameters: {'taskId': taskId},
            extra: {
              'checkPointPoolBalance': 100.0,
              'mergeMap': {
                'u1': ['u2', 'u3'],
                'u4': <String>[],
              },
            },
          );
        },
        child: const Text('Go S31'),
      ),
    );
  }
}
