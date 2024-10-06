import 'package:app/src/modules/dashboard/data/datasources/audit_logs_datasource.dart';
import 'package:dio/dio.dart';

class AuditLogsUsecase {
  static Future<dynamic> call() async {
     final (result, error) = await AuditLogsDatasource(Dio()).fetchAuditLogs();

    if(error != null) {
      throw Exception(error);
    } else if(result == null) {
      throw Exception("Erro ao buscar os logs de auditoria");
    } else {
      return result;
    }

  }
}