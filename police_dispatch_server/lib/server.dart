import 'package:police_dispatch_server/src/generated/serverpod.dart';
import 'package:police_dispatch_server/src/tasks/simulation_task.dart';

/// Server entry point used by the generated Serverpod bootstrap.
void run(List<String> args) async {
  final pod = Serverpod(args);

  final simulation = SimulationTask(pod);
  simulation.start();

  await pod.start();
}
