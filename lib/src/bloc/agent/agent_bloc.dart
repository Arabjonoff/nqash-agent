import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/model/client/client_model.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:naqsh_agent/src/utils/bus/rx_bus.dart';
import 'package:rxdart/rxdart.dart';

class AgentBloc {
  final Repository _repository = Repository();

  final _clientInfo = PublishSubject<List<ClientModel>>();

  Stream<List<ClientModel>> get getClient => _clientInfo.stream;

  getClients(id) async {
    HttpResult response = await _repository.getClient(id);
    if (response.isSuccess) {
      List<ClientModel> data =
          clientModelFromJson(json.encode(response.result));
      _clientInfo.sink.add(data);
    } else if (response.statusCode == -1) {
      RxBus.post('Internet error', tag: 'agent_bloc_get_clients');
    }
  }
}

final agentBloc = AgentBloc();
