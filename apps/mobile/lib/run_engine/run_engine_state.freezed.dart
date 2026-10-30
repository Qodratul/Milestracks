// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_engine_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RunEngineState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RunEngineState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RunEngineState()';
}


}

/// @nodoc
class $RunEngineStateCopyWith<$Res>  {
$RunEngineStateCopyWith(RunEngineState _, $Res Function(RunEngineState) __);
}


/// Adds pattern-matching-related methods to [RunEngineState].
extension RunEngineStatePatterns on RunEngineState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RunIdle value)?  idle,TResult Function( RunGenerating value)?  generating,TResult Function( RunReady value)?  ready,TResult Function( RunRunning value)?  running,TResult Function( RunPaused value)?  paused,TResult Function( RunFinishing value)?  finishing,TResult Function( RunCompleted value)?  completed,TResult Function( RunSafeStopped value)?  safeStopped,TResult Function( RunRejected value)?  rejected,TResult Function( RunFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RunIdle() when idle != null:
return idle(_that);case RunGenerating() when generating != null:
return generating(_that);case RunReady() when ready != null:
return ready(_that);case RunRunning() when running != null:
return running(_that);case RunPaused() when paused != null:
return paused(_that);case RunFinishing() when finishing != null:
return finishing(_that);case RunCompleted() when completed != null:
return completed(_that);case RunSafeStopped() when safeStopped != null:
return safeStopped(_that);case RunRejected() when rejected != null:
return rejected(_that);case RunFailed() when failed != null:
return failed(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RunIdle value)  idle,required TResult Function( RunGenerating value)  generating,required TResult Function( RunReady value)  ready,required TResult Function( RunRunning value)  running,required TResult Function( RunPaused value)  paused,required TResult Function( RunFinishing value)  finishing,required TResult Function( RunCompleted value)  completed,required TResult Function( RunSafeStopped value)  safeStopped,required TResult Function( RunRejected value)  rejected,required TResult Function( RunFailed value)  failed,}){
final _that = this;
switch (_that) {
case RunIdle():
return idle(_that);case RunGenerating():
return generating(_that);case RunReady():
return ready(_that);case RunRunning():
return running(_that);case RunPaused():
return paused(_that);case RunFinishing():
return finishing(_that);case RunCompleted():
return completed(_that);case RunSafeStopped():
return safeStopped(_that);case RunRejected():
return rejected(_that);case RunFailed():
return failed(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RunIdle value)?  idle,TResult? Function( RunGenerating value)?  generating,TResult? Function( RunReady value)?  ready,TResult? Function( RunRunning value)?  running,TResult? Function( RunPaused value)?  paused,TResult? Function( RunFinishing value)?  finishing,TResult? Function( RunCompleted value)?  completed,TResult? Function( RunSafeStopped value)?  safeStopped,TResult? Function( RunRejected value)?  rejected,TResult? Function( RunFailed value)?  failed,}){
final _that = this;
switch (_that) {
case RunIdle() when idle != null:
return idle(_that);case RunGenerating() when generating != null:
return generating(_that);case RunReady() when ready != null:
return ready(_that);case RunRunning() when running != null:
return running(_that);case RunPaused() when paused != null:
return paused(_that);case RunFinishing() when finishing != null:
return finishing(_that);case RunCompleted() when completed != null:
return completed(_that);case RunSafeStopped() when safeStopped != null:
return safeStopped(_that);case RunRejected() when rejected != null:
return rejected(_that);case RunFailed() when failed != null:
return failed(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  generating,TResult Function( TrackDto track)?  ready,TResult Function( RunDto run,  TrackDto track,  List<RunPointDto> points,  double distanceMeters,  int elapsedSeconds,  int reachedMilestones,  MilestoneDialogueDto? milestoneEvent)?  running,TResult Function( RunDto run,  TrackDto track,  List<RunPointDto> points,  double distanceMeters,  int elapsedSeconds,  int reachedMilestones,  MilestoneDialogueDto? milestoneEvent)?  paused,TResult Function()?  finishing,TResult Function( RunDto run,  bool syncPending)?  completed,TResult Function( RunDto run,  bool syncPending)?  safeStopped,TResult Function( RunDto run)?  rejected,TResult Function( String messageKey)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RunIdle() when idle != null:
return idle();case RunGenerating() when generating != null:
return generating();case RunReady() when ready != null:
return ready(_that.track);case RunRunning() when running != null:
return running(_that.run,_that.track,_that.points,_that.distanceMeters,_that.elapsedSeconds,_that.reachedMilestones,_that.milestoneEvent);case RunPaused() when paused != null:
return paused(_that.run,_that.track,_that.points,_that.distanceMeters,_that.elapsedSeconds,_that.reachedMilestones,_that.milestoneEvent);case RunFinishing() when finishing != null:
return finishing();case RunCompleted() when completed != null:
return completed(_that.run,_that.syncPending);case RunSafeStopped() when safeStopped != null:
return safeStopped(_that.run,_that.syncPending);case RunRejected() when rejected != null:
return rejected(_that.run);case RunFailed() when failed != null:
return failed(_that.messageKey);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  generating,required TResult Function( TrackDto track)  ready,required TResult Function( RunDto run,  TrackDto track,  List<RunPointDto> points,  double distanceMeters,  int elapsedSeconds,  int reachedMilestones,  MilestoneDialogueDto? milestoneEvent)  running,required TResult Function( RunDto run,  TrackDto track,  List<RunPointDto> points,  double distanceMeters,  int elapsedSeconds,  int reachedMilestones,  MilestoneDialogueDto? milestoneEvent)  paused,required TResult Function()  finishing,required TResult Function( RunDto run,  bool syncPending)  completed,required TResult Function( RunDto run,  bool syncPending)  safeStopped,required TResult Function( RunDto run)  rejected,required TResult Function( String messageKey)  failed,}) {final _that = this;
switch (_that) {
case RunIdle():
return idle();case RunGenerating():
return generating();case RunReady():
return ready(_that.track);case RunRunning():
return running(_that.run,_that.track,_that.points,_that.distanceMeters,_that.elapsedSeconds,_that.reachedMilestones,_that.milestoneEvent);case RunPaused():
return paused(_that.run,_that.track,_that.points,_that.distanceMeters,_that.elapsedSeconds,_that.reachedMilestones,_that.milestoneEvent);case RunFinishing():
return finishing();case RunCompleted():
return completed(_that.run,_that.syncPending);case RunSafeStopped():
return safeStopped(_that.run,_that.syncPending);case RunRejected():
return rejected(_that.run);case RunFailed():
return failed(_that.messageKey);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  generating,TResult? Function( TrackDto track)?  ready,TResult? Function( RunDto run,  TrackDto track,  List<RunPointDto> points,  double distanceMeters,  int elapsedSeconds,  int reachedMilestones,  MilestoneDialogueDto? milestoneEvent)?  running,TResult? Function( RunDto run,  TrackDto track,  List<RunPointDto> points,  double distanceMeters,  int elapsedSeconds,  int reachedMilestones,  MilestoneDialogueDto? milestoneEvent)?  paused,TResult? Function()?  finishing,TResult? Function( RunDto run,  bool syncPending)?  completed,TResult? Function( RunDto run,  bool syncPending)?  safeStopped,TResult? Function( RunDto run)?  rejected,TResult? Function( String messageKey)?  failed,}) {final _that = this;
switch (_that) {
case RunIdle() when idle != null:
return idle();case RunGenerating() when generating != null:
return generating();case RunReady() when ready != null:
return ready(_that.track);case RunRunning() when running != null:
return running(_that.run,_that.track,_that.points,_that.distanceMeters,_that.elapsedSeconds,_that.reachedMilestones,_that.milestoneEvent);case RunPaused() when paused != null:
return paused(_that.run,_that.track,_that.points,_that.distanceMeters,_that.elapsedSeconds,_that.reachedMilestones,_that.milestoneEvent);case RunFinishing() when finishing != null:
return finishing();case RunCompleted() when completed != null:
return completed(_that.run,_that.syncPending);case RunSafeStopped() when safeStopped != null:
return safeStopped(_that.run,_that.syncPending);case RunRejected() when rejected != null:
return rejected(_that.run);case RunFailed() when failed != null:
return failed(_that.messageKey);case _:
  return null;

}
}

}

/// @nodoc


class RunIdle implements RunEngineState {
  const RunIdle();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RunIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RunEngineState.idle()';
}


}




/// @nodoc


class RunGenerating implements RunEngineState {
  const RunGenerating();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RunGenerating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RunEngineState.generating()';
}


}




/// @nodoc


class RunReady implements RunEngineState {
  const RunReady(this.track);
  

 final  TrackDto track;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunReadyCopyWith<RunReady> get copyWith => _$RunReadyCopyWithImpl<RunReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RunReady&&(identical(other.track, track) || other.track == track));
}


@override
int get hashCode {
    return Object.hash(runtimeType,track);
}

@override
String toString() {
    return 'RunEngineState.ready(track: $track)';
}


}

/// @nodoc
abstract mixin class $RunReadyCopyWith<$Res> implements $RunEngineStateCopyWith<$Res> {
  factory $RunReadyCopyWith(RunReady value, $Res Function(RunReady) _then) = _$RunReadyCopyWithImpl;
@useResult
$Res call({
 TrackDto track
});


$TrackDtoCopyWith<$Res> get track;

}
/// @nodoc
class _$RunReadyCopyWithImpl<$Res>
    implements $RunReadyCopyWith<$Res> {
  _$RunReadyCopyWithImpl(this._self, this._then);

  final RunReady _self;
  final $Res Function(RunReady) _then;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? track = null,}) {
  return _then(RunReady(
null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as TrackDto,
  ));
}

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackDtoCopyWith<$Res> get track {
  
  return $TrackDtoCopyWith<$Res>(_self.track, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}

/// @nodoc


class RunRunning implements RunEngineState {
  const RunRunning({required this.run, required this.track, required  List<RunPointDto> points, required this.distanceMeters, required this.elapsedSeconds, required this.reachedMilestones, this.milestoneEvent}): _points = points;
  

 final  RunDto run;
 final  TrackDto track;
 final  List<RunPointDto> _points;
 List<RunPointDto> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

 final  double distanceMeters;
 final  int elapsedSeconds;
 final  int reachedMilestones;
 final  MilestoneDialogueDto? milestoneEvent;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunRunningCopyWith<RunRunning> get copyWith => _$RunRunningCopyWithImpl<RunRunning>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RunRunning&&(identical(other.run, run) || other.run == run)&&(identical(other.track, track) || other.track == track)&&const DeepCollectionEquality().equals(other.points, _points)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.reachedMilestones, reachedMilestones) || other.reachedMilestones == reachedMilestones)&&(identical(other.milestoneEvent, milestoneEvent) || other.milestoneEvent == milestoneEvent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,run,track,const DeepCollectionEquality().hash(_points),distanceMeters,elapsedSeconds,reachedMilestones,milestoneEvent);
}

@override
String toString() {
    return 'RunEngineState.running(run: $run, track: $track, points: $points, distanceMeters: $distanceMeters, elapsedSeconds: $elapsedSeconds, reachedMilestones: $reachedMilestones, milestoneEvent: $milestoneEvent)';
}


}

/// @nodoc
abstract mixin class $RunRunningCopyWith<$Res> implements $RunEngineStateCopyWith<$Res> {
  factory $RunRunningCopyWith(RunRunning value, $Res Function(RunRunning) _then) = _$RunRunningCopyWithImpl;
@useResult
$Res call({
 RunDto run, TrackDto track, List<RunPointDto> points, double distanceMeters, int elapsedSeconds, int reachedMilestones, MilestoneDialogueDto? milestoneEvent
});


$RunDtoCopyWith<$Res> get run;$TrackDtoCopyWith<$Res> get track;$MilestoneDialogueDtoCopyWith<$Res>? get milestoneEvent;

}
/// @nodoc
class _$RunRunningCopyWithImpl<$Res>
    implements $RunRunningCopyWith<$Res> {
  _$RunRunningCopyWithImpl(this._self, this._then);

  final RunRunning _self;
  final $Res Function(RunRunning) _then;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? run = null,Object? track = null,Object? points = null,Object? distanceMeters = null,Object? elapsedSeconds = null,Object? reachedMilestones = null,Object? milestoneEvent = freezed,}) {
  return _then(RunRunning(
run: null == run ? _self.run : run // ignore: cast_nullable_to_non_nullable
as RunDto,track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as TrackDto,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<RunPointDto>,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,reachedMilestones: null == reachedMilestones ? _self.reachedMilestones : reachedMilestones // ignore: cast_nullable_to_non_nullable
as int,milestoneEvent: freezed == milestoneEvent ? _self.milestoneEvent : milestoneEvent // ignore: cast_nullable_to_non_nullable
as MilestoneDialogueDto?,
  ));
}

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunDtoCopyWith<$Res> get run {
  
  return $RunDtoCopyWith<$Res>(_self.run, (value) {
    return _then(_self.copyWith(run: value));
  });
}/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackDtoCopyWith<$Res> get track {
  
  return $TrackDtoCopyWith<$Res>(_self.track, (value) {
    return _then(_self.copyWith(track: value));
  });
}/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MilestoneDialogueDtoCopyWith<$Res>? get milestoneEvent {
    if (_self.milestoneEvent == null) {
    return null;
  }

  return $MilestoneDialogueDtoCopyWith<$Res>(_self.milestoneEvent!, (value) {
    return _then(_self.copyWith(milestoneEvent: value));
  });
}
}

/// @nodoc


class RunPaused implements RunEngineState {
  const RunPaused({required this.run, required this.track, required  List<RunPointDto> points, required this.distanceMeters, required this.elapsedSeconds, required this.reachedMilestones, this.milestoneEvent}): _points = points;
  

 final  RunDto run;
 final  TrackDto track;
 final  List<RunPointDto> _points;
 List<RunPointDto> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

 final  double distanceMeters;
 final  int elapsedSeconds;
 final  int reachedMilestones;
 final  MilestoneDialogueDto? milestoneEvent;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunPausedCopyWith<RunPaused> get copyWith => _$RunPausedCopyWithImpl<RunPaused>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RunPaused&&(identical(other.run, run) || other.run == run)&&(identical(other.track, track) || other.track == track)&&const DeepCollectionEquality().equals(other.points, _points)&&(identical(other.distanceMeters, distanceMeters) || other.distanceMeters == distanceMeters)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.reachedMilestones, reachedMilestones) || other.reachedMilestones == reachedMilestones)&&(identical(other.milestoneEvent, milestoneEvent) || other.milestoneEvent == milestoneEvent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,run,track,const DeepCollectionEquality().hash(_points),distanceMeters,elapsedSeconds,reachedMilestones,milestoneEvent);
}

@override
String toString() {
    return 'RunEngineState.paused(run: $run, track: $track, points: $points, distanceMeters: $distanceMeters, elapsedSeconds: $elapsedSeconds, reachedMilestones: $reachedMilestones, milestoneEvent: $milestoneEvent)';
}


}

/// @nodoc
abstract mixin class $RunPausedCopyWith<$Res> implements $RunEngineStateCopyWith<$Res> {
  factory $RunPausedCopyWith(RunPaused value, $Res Function(RunPaused) _then) = _$RunPausedCopyWithImpl;
@useResult
$Res call({
 RunDto run, TrackDto track, List<RunPointDto> points, double distanceMeters, int elapsedSeconds, int reachedMilestones, MilestoneDialogueDto? milestoneEvent
});


$RunDtoCopyWith<$Res> get run;$TrackDtoCopyWith<$Res> get track;$MilestoneDialogueDtoCopyWith<$Res>? get milestoneEvent;

}
/// @nodoc
class _$RunPausedCopyWithImpl<$Res>
    implements $RunPausedCopyWith<$Res> {
  _$RunPausedCopyWithImpl(this._self, this._then);

  final RunPaused _self;
  final $Res Function(RunPaused) _then;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? run = null,Object? track = null,Object? points = null,Object? distanceMeters = null,Object? elapsedSeconds = null,Object? reachedMilestones = null,Object? milestoneEvent = freezed,}) {
  return _then(RunPaused(
run: null == run ? _self.run : run // ignore: cast_nullable_to_non_nullable
as RunDto,track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as TrackDto,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<RunPointDto>,distanceMeters: null == distanceMeters ? _self.distanceMeters : distanceMeters // ignore: cast_nullable_to_non_nullable
as double,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,reachedMilestones: null == reachedMilestones ? _self.reachedMilestones : reachedMilestones // ignore: cast_nullable_to_non_nullable
as int,milestoneEvent: freezed == milestoneEvent ? _self.milestoneEvent : milestoneEvent // ignore: cast_nullable_to_non_nullable
as MilestoneDialogueDto?,
  ));
}

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunDtoCopyWith<$Res> get run {
  
  return $RunDtoCopyWith<$Res>(_self.run, (value) {
    return _then(_self.copyWith(run: value));
  });
}/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackDtoCopyWith<$Res> get track {
  
  return $TrackDtoCopyWith<$Res>(_self.track, (value) {
    return _then(_self.copyWith(track: value));
  });
}/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MilestoneDialogueDtoCopyWith<$Res>? get milestoneEvent {
    if (_self.milestoneEvent == null) {
    return null;
  }

  return $MilestoneDialogueDtoCopyWith<$Res>(_self.milestoneEvent!, (value) {
    return _then(_self.copyWith(milestoneEvent: value));
  });
}
}

/// @nodoc


class RunFinishing implements RunEngineState {
  const RunFinishing();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RunFinishing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'RunEngineState.finishing()';
}


}




/// @nodoc


class RunCompleted implements RunEngineState {
  const RunCompleted(this.run, {this.syncPending = false});
  

 final  RunDto run;
@JsonKey() final  bool syncPending;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunCompletedCopyWith<RunCompleted> get copyWith => _$RunCompletedCopyWithImpl<RunCompleted>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RunCompleted&&(identical(other.run, run) || other.run == run)&&(identical(other.syncPending, syncPending) || other.syncPending == syncPending));
}


@override
int get hashCode {
    return Object.hash(runtimeType,run,syncPending);
}

@override
String toString() {
    return 'RunEngineState.completed(run: $run, syncPending: $syncPending)';
}


}

/// @nodoc
abstract mixin class $RunCompletedCopyWith<$Res> implements $RunEngineStateCopyWith<$Res> {
  factory $RunCompletedCopyWith(RunCompleted value, $Res Function(RunCompleted) _then) = _$RunCompletedCopyWithImpl;
@useResult
$Res call({
 RunDto run, bool syncPending
});


$RunDtoCopyWith<$Res> get run;

}
/// @nodoc
class _$RunCompletedCopyWithImpl<$Res>
    implements $RunCompletedCopyWith<$Res> {
  _$RunCompletedCopyWithImpl(this._self, this._then);

  final RunCompleted _self;
  final $Res Function(RunCompleted) _then;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? run = null,Object? syncPending = null,}) {
  return _then(RunCompleted(
null == run ? _self.run : run // ignore: cast_nullable_to_non_nullable
as RunDto,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunDtoCopyWith<$Res> get run {
  
  return $RunDtoCopyWith<$Res>(_self.run, (value) {
    return _then(_self.copyWith(run: value));
  });
}
}

/// @nodoc


class RunSafeStopped implements RunEngineState {
  const RunSafeStopped(this.run, {this.syncPending = false});
  

 final  RunDto run;
@JsonKey() final  bool syncPending;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunSafeStoppedCopyWith<RunSafeStopped> get copyWith => _$RunSafeStoppedCopyWithImpl<RunSafeStopped>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RunSafeStopped&&(identical(other.run, run) || other.run == run)&&(identical(other.syncPending, syncPending) || other.syncPending == syncPending));
}


@override
int get hashCode {
    return Object.hash(runtimeType,run,syncPending);
}

@override
String toString() {
    return 'RunEngineState.safeStopped(run: $run, syncPending: $syncPending)';
}


}

/// @nodoc
abstract mixin class $RunSafeStoppedCopyWith<$Res> implements $RunEngineStateCopyWith<$Res> {
  factory $RunSafeStoppedCopyWith(RunSafeStopped value, $Res Function(RunSafeStopped) _then) = _$RunSafeStoppedCopyWithImpl;
@useResult
$Res call({
 RunDto run, bool syncPending
});


$RunDtoCopyWith<$Res> get run;

}
/// @nodoc
class _$RunSafeStoppedCopyWithImpl<$Res>
    implements $RunSafeStoppedCopyWith<$Res> {
  _$RunSafeStoppedCopyWithImpl(this._self, this._then);

  final RunSafeStopped _self;
  final $Res Function(RunSafeStopped) _then;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? run = null,Object? syncPending = null,}) {
  return _then(RunSafeStopped(
null == run ? _self.run : run // ignore: cast_nullable_to_non_nullable
as RunDto,syncPending: null == syncPending ? _self.syncPending : syncPending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunDtoCopyWith<$Res> get run {
  
  return $RunDtoCopyWith<$Res>(_self.run, (value) {
    return _then(_self.copyWith(run: value));
  });
}
}

/// @nodoc


class RunRejected implements RunEngineState {
  const RunRejected(this.run);
  

 final  RunDto run;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunRejectedCopyWith<RunRejected> get copyWith => _$RunRejectedCopyWithImpl<RunRejected>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RunRejected&&(identical(other.run, run) || other.run == run));
}


@override
int get hashCode {
    return Object.hash(runtimeType,run);
}

@override
String toString() {
    return 'RunEngineState.rejected(run: $run)';
}


}

/// @nodoc
abstract mixin class $RunRejectedCopyWith<$Res> implements $RunEngineStateCopyWith<$Res> {
  factory $RunRejectedCopyWith(RunRejected value, $Res Function(RunRejected) _then) = _$RunRejectedCopyWithImpl;
@useResult
$Res call({
 RunDto run
});


$RunDtoCopyWith<$Res> get run;

}
/// @nodoc
class _$RunRejectedCopyWithImpl<$Res>
    implements $RunRejectedCopyWith<$Res> {
  _$RunRejectedCopyWithImpl(this._self, this._then);

  final RunRejected _self;
  final $Res Function(RunRejected) _then;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? run = null,}) {
  return _then(RunRejected(
null == run ? _self.run : run // ignore: cast_nullable_to_non_nullable
as RunDto,
  ));
}

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RunDtoCopyWith<$Res> get run {
  
  return $RunDtoCopyWith<$Res>(_self.run, (value) {
    return _then(_self.copyWith(run: value));
  });
}
}

/// @nodoc


class RunFailed implements RunEngineState {
  const RunFailed(this.messageKey);
  

 final  String messageKey;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunFailedCopyWith<RunFailed> get copyWith => _$RunFailedCopyWithImpl<RunFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is RunFailed&&(identical(other.messageKey, messageKey) || other.messageKey == messageKey));
}


@override
int get hashCode {
    return Object.hash(runtimeType,messageKey);
}

@override
String toString() {
    return 'RunEngineState.failed(messageKey: $messageKey)';
}


}

/// @nodoc
abstract mixin class $RunFailedCopyWith<$Res> implements $RunEngineStateCopyWith<$Res> {
  factory $RunFailedCopyWith(RunFailed value, $Res Function(RunFailed) _then) = _$RunFailedCopyWithImpl;
@useResult
$Res call({
 String messageKey
});




}
/// @nodoc
class _$RunFailedCopyWithImpl<$Res>
    implements $RunFailedCopyWith<$Res> {
  _$RunFailedCopyWithImpl(this._self, this._then);

  final RunFailed _self;
  final $Res Function(RunFailed) _then;

/// Create a copy of RunEngineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messageKey = null,}) {
  return _then(RunFailed(
null == messageKey ? _self.messageKey : messageKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
