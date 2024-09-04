import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MaterialApp(home: PackageStatusScreen()));
}

// Events
abstract class StatusEvent {}
class UpdateStatus extends StatusEvent {
  final String status;
  UpdateStatus(this.status);
}

// States
class StatusState {
  final String? currentStatus;
  final String? loadingStatus;
  
  StatusState({this.currentStatus, this.loadingStatus});
  
  StatusState copyWith({String? currentStatus, String? loadingStatus}) {
    return StatusState(
      currentStatus: currentStatus ?? this.currentStatus,
      loadingStatus: loadingStatus,
    );
  }
}

// BLoC
class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusState()) {
    on<UpdateStatus>((event, emit) async {
      emit(state.copyWith(loadingStatus: event.status));
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(currentStatus: event.status, loadingStatus: null));
    });
  }
}

// UI
class PackageStatusScreen extends StatelessWidget {
  const PackageStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Package Status')),
        body: Center(
          child: BlocConsumer<StatusBloc, StatusState>(
            listener: (context, state) {
              if (state.currentStatus != null && state.loadingStatus == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Status updated to: ${state.currentStatus}')),
                );
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusButton(context, state, 'Di Paket'),
                  const SizedBox(height: 10),
                  _buildStatusButton(context, state, 'Di Jalan'),
                  const SizedBox(height: 10),
                  _buildStatusButton(context, state, 'Terkirim ke Penerima'),
                  const SizedBox(height: 20),
                  if (state.currentStatus != null)
                    Text('Status saat ini: ${state.currentStatus}', 
                         style: const TextStyle(fontSize: 18)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context, StatusState state, String status) {
    bool isLoading = state.loadingStatus == status;
    return ElevatedButton(
      onPressed: isLoading 
        ? null 
        : () => context.read<StatusBloc>().add(UpdateStatus(status)),
      child: isLoading 
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Text(status),
    );
  }
}
