import 'dart:convert';

import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/model/wallet/wallet_model.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

class WalletBloc {
  Repository _repository = Repository();

  final _walletInfo = PublishSubject<List<WalletModel>>();

  Stream<List<WalletModel>> get getWalletInfo => _walletInfo.stream;

  getWallet() async {
    HttpResult response = await _repository.getWallet();
    if (response.isSuccess) {
      List<WalletModel> data = walletModelFromJson(
        json.encode(response.result),
      );
      _walletInfo.sink.add(data);
    }
  }

  updateWallet(){
    getWallet();
  }
}

final walletBloc = WalletBloc();
