// This is a generated file - do not edit.
//
// Generated from roncafe_admin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use windowRequestDescriptor instead')
const WindowRequest$json = {
  '1': 'WindowRequest',
  '2': [
    {'1': 'window_type', '3': 1, '4': 1, '5': 9, '10': 'windowType'},
  ],
};

/// Descriptor for `WindowRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List windowRequestDescriptor = $convert.base64Decode(
    'Cg1XaW5kb3dSZXF1ZXN0Eh8KC3dpbmRvd190eXBlGAEgASgJUgp3aW5kb3dUeXBl');

@$core.Deprecated('Use commandResponseDescriptor instead')
const CommandResponse$json = {
  '1': 'CommandResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CommandResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commandResponseDescriptor = $convert.base64Decode(
    'Cg9Db21tYW5kUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGA'
    'IgASgJUgdtZXNzYWdl');
