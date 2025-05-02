import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

// Events
abstract class LocationEvent extends Equatable {
  const LocationEvent();
  @override
  List<Object> get props => [];
}

class FetchLocation extends LocationEvent {}

// States
abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final Position position;
  const LocationLoaded(this.position);
  @override
  List<Object> get props => [position];
}

class LocationError extends LocationState {
  final String message;
  const LocationError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<FetchLocation>(_onFetchLocation);
  }

  Future<void> _onFetchLocation(
      FetchLocation event, Emitter<LocationState> emit) async {
    emit(LocationLoading());
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const LocationError('Location services are disabled.'));
        return;
      }

      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(const LocationError('Location permission denied.'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(const LocationError(
            'Location permission permanently denied. Please enable it in settings.'));
        return;
      }

      // Fetch location
      Position position = await Geolocator.getCurrentPosition();
      emit(LocationLoaded(position));
    } catch (e) {
      emit(LocationError('Failed to fetch location: $e'));
    }
  }
}
