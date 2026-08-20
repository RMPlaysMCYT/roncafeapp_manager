// This is a generated file - do not edit.
//
// Generated from roncafe_admin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'roncafe_admin.pb.dart' as $0;

export 'roncafe_admin.pb.dart';

@$pb.GrpcServiceName('admin.AdminService')
class AdminServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AdminServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CommandResponse> selectWindow(
    $0.WindowRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$selectWindow, request, options: options);
  }

  // method descriptors

  static final _$selectWindow =
      $grpc.ClientMethod<$0.WindowRequest, $0.CommandResponse>(
          '/admin.AdminService/SelectWindow',
          ($0.WindowRequest value) => value.writeToBuffer(),
          $0.CommandResponse.fromBuffer);
}

@$pb.GrpcServiceName('admin.AdminService')
abstract class AdminServiceBase extends $grpc.Service {
  $core.String get $name => 'admin.AdminService';

  AdminServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.WindowRequest, $0.CommandResponse>(
        'SelectWindow',
        selectWindow_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.WindowRequest.fromBuffer(value),
        ($0.CommandResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CommandResponse> selectWindow_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.WindowRequest> $request) async {
    return selectWindow($call, await $request);
  }

  $async.Future<$0.CommandResponse> selectWindow(
      $grpc.ServiceCall call, $0.WindowRequest request);
}
