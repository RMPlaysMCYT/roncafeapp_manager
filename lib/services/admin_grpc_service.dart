// lib/services/admin_grpc_client.dart
import 'package:grpc/grpc.dart';
import '../generated/roncafe_admin.pbgrpc.dart';

class AdminGrpcClient {
  static final AdminGrpcClient _instance = AdminGrpcClient._internal();
  factory AdminGrpcClient() => _instance;
  AdminGrpcClient._internal();

  late ClientChannel _channel;
  late AdminServiceClient _stub;

  Future<void> connect() async {
    _channel = ClientChannel(
      'localhost',
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _stub = AdminServiceClient(_channel);
  }

  Future<void> selectWindow(String windowType) async {
    try {
      final request = WindowRequest()..windowType = windowType;
      final response = await _stub.selectWindow(request);
      print('gRPC Response: ${response.message}');
      if (!response.success) {
        // Handle the error reported by the server
        print('Error from server: ${response.message}');
      }
    } catch (e) {
      print('gRPC call failed: $e');
    }
  }

  void dispose() {
    _channel.shutdown();
  }
}
