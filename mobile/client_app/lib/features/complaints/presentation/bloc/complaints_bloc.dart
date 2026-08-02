import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/complaint_entity.dart';
import '../../domain/usecases/complaints_usecases.dart';

part 'complaints_event.dart';
part 'complaints_state.dart';

class ComplaintsBloc extends Bloc<ComplaintsEvent, ComplaintsState> {
  ComplaintsBloc(
    this._getComplaints,
    this._getDetails,
    this._createComplaint,
    this._getUnreadCount,
    this._markAsRead,
  ) : super(const ComplaintsState()) {
    on<LoadComplaintsEvent>(_onLoad);
    on<LoadComplaintDetailsEvent>(_onLoadDetails);
    on<CreateComplaintEvent>(_onCreate);
    on<LoadComplaintUnreadCountEvent>(_onUnreadCount);
    on<ClearComplaintMessagesEvent>(_onClearMessages);
  }

  final GetComplaintsUseCase _getComplaints;
  final GetComplaintDetailsUseCase _getDetails;
  final CreateComplaintUseCase _createComplaint;
  final GetComplaintUnreadCountUseCase _getUnreadCount;
  final MarkComplaintAsReadUseCase _markAsRead;

  Future<void> _onLoad(
    LoadComplaintsEvent event,
    Emitter<ComplaintsState> emit,
  ) async {
    final services = state.services;
    final companies = state.companies;

    final hasLoaded = services.hasLoaded && companies.hasLoaded;

    final isBusy =
        services.isLoading ||
        services.isRefreshing ||
        companies.isLoading ||
        companies.isRefreshing;

    if (isBusy) {
      _complete(event.completer);
      return;
    }

    if (!event.refresh && !event.forceLoading && hasLoaded) {
      _complete(event.completer);
      return;
    }

    if (event.forceLoading) {
      emit(
        state.copyWith(
          services: const ComplaintTabState(isLoading: true),
          companies: const ComplaintTabState(isLoading: true),
        ),
      );
    } else {
      emit(
        state.copyWith(
          services: services.copyWith(
            isLoading: !hasLoaded,
            isRefreshing: event.refresh && hasLoaded,
            clearError: true,
          ),
          companies: companies.copyWith(
            isLoading: !hasLoaded,
            isRefreshing: event.refresh && hasLoaded,
            clearError: true,
          ),
        ),
      );
    }

    try {
      final result = await _getComplaints();

      emit(
        state.copyWith(
          services: ComplaintTabState(items: result.services, hasLoaded: true),
          companies: ComplaintTabState(
            items: result.companies,
            hasLoaded: true,
          ),
          unreadCount: result.unread,
        ),
      );
    } catch (error) {
      final message = _message(error);

      emit(
        state.copyWith(
          services: event.forceLoading
              ? ComplaintTabState(error: message, hasLoaded: true)
              : services.copyWith(
                  isLoading: false,
                  isRefreshing: false,
                  error: message,
                ),
          companies: event.forceLoading
              ? ComplaintTabState(error: message, hasLoaded: true)
              : companies.copyWith(
                  isLoading: false,
                  isRefreshing: false,
                  error: message,
                ),
        ),
      );
    } finally {
      _complete(event.completer);
    }
  }

  Future<void> _onLoadDetails(
    LoadComplaintDetailsEvent event,
    Emitter<ComplaintsState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoadingDetails: true,
        clearSelectedComplaint: true,
        clearDetailsError: true,
      ),
    );
    try {
      var complaint = await _getDetails(event.id);
      if (complaint.hasUnreadResponse) {
        try {
          await _markAsRead(event.id);
          complaint = complaint.copyWith(hasUnreadResponse: false);
          _replaceComplaint(complaint, emit);
          emit(
            state.copyWith(
              unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
            ),
          );
        } catch (_) {
          // Details remain usable when the independent read acknowledgement fails.
        }
      }
      emit(
        state.copyWith(
          selectedComplaint: complaint,
          isLoadingDetails: false,
          clearDetailsError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoadingDetails: false,
          detailsError: _message(error),
          clearSelectedComplaint: true,
        ),
      );
    }
  }

  Future<void> _onCreate(
    CreateComplaintEvent event,
    Emitter<ComplaintsState> emit,
  ) async {
    if (state.isCreating) return;
    emit(
      state.copyWith(
        isCreating: true,
        clearCreateError: true,
        createSucceeded: false,
      ),
    );
    try {
      final complaint = (await _createComplaint(
        type: event.type,
        id: event.targetId,
        title: event.title,
        body: event.body,
      )).copyWith(targetName: event.targetName);
      final current = state.listFor(event.type);
      emit(
        state
            .withList(
              event.type,
              current.copyWith(
                items: [
                  complaint,
                  ...current.items.where((item) => item.id != complaint.id),
                ],
                hasLoaded: true,
              ),
            )
            .copyWith(isCreating: false, createSucceeded: true),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isCreating: false,
          createError: _message(error),
          createSucceeded: false,
        ),
      );
    }
  }

  Future<void> _onUnreadCount(
    LoadComplaintUnreadCountEvent event,
    Emitter<ComplaintsState> emit,
  ) async {
    try {
      emit(state.copyWith(unreadCount: await _getUnreadCount()));
    } catch (_) {
      // The badge is best effort and must not replace page-level state.
    }
  }

  void _onClearMessages(
    ClearComplaintMessagesEvent event,
    Emitter<ComplaintsState> emit,
  ) {
    emit(
      state.copyWith(
        createSucceeded: false,
        clearCreateError: true,
        clearDetailsError: true,
      ),
    );
  }

  void _replaceComplaint(
    ComplaintEntity complaint,
    Emitter<ComplaintsState> emit,
  ) {
    final current = state.listFor(complaint.type);
    if (current.items.every((item) => item.id != complaint.id)) return;
    emit(
      state.withList(
        complaint.type,
        current.copyWith(
          items: current.items
              .map((item) => item.id == complaint.id ? complaint : item)
              .toList(growable: false),
        ),
      ),
    );
  }

  static String _message(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  static void _complete(Completer<void>? completer) {
    if (completer != null && !completer.isCompleted) completer.complete();
  }
}
