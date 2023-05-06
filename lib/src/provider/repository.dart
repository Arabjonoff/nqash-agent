import 'package:naqsh_agent/src/provider/app_provider.dart';

import '../model/http_result.dart';

class Repository{
  final AppProvider _provider = AppProvider();

  Future<HttpResult> register(name, surname, phone)=> _provider.register(name, surname, phone);
  Future<HttpResult> login(phone)=> _provider.login(phone);
  Future<HttpResult> activate(phone,code)=> _provider.activate(phone,code);
  Future<HttpResult> getWallet()=> _provider.getWallet();
  Future<HttpResult> getWalletDetail(id,date)=> _provider.getWalletDetail(id,date);
  Future<HttpResult> addWallet(name, valyute, balans,bg)=> _provider.addWallet(name, valyute, balans,bg);
  Future<HttpResult> addClients(name, phone, surname, summa_uzs, summa_usd, lastopiration_date, comment,id,balanceUzs,balanceUsd)=> _provider.addClients(name, phone, surname, summa_uzs, summa_usd, lastopiration_date, comment,id,balanceUzs,balanceUsd);
  Future<HttpResult> addExpense(date,walletId,summaUzs,summaUsd, cost,comment) => _provider.addExpense(date, walletId, summaUzs,summaUsd, cost, comment);
  Future<HttpResult> getClient(id)=> _provider.getClient(id);
  Future<HttpResult> getAgentDetail(id,date)=> _provider.getAgentDetail(id,date);
  Future<HttpResult> deleteClient(id)=> _provider.deleteClient(id);
  Future<HttpResult> deleteOperation(id)=> _provider.deleteOperation(id);
  Future<HttpResult> search(query)=> _provider.search(query);
  Future<HttpResult> clientId(id)=> _provider.clientId(id);
  Future<HttpResult> walletAll()=> _provider.walletAll();
  Future<HttpResult> courseAll()=> _provider.courseAll();
  Future<HttpResult> courseAdd(date, course)=> _provider.courseAdd(date, course);
  Future<HttpResult> categoryAdd(name)=> _provider.categoryAdd(name);
  Future<HttpResult> categoryGet()=> _provider.categoryGet();
  Future<HttpResult> categoryDelete(id)=> _provider.categoryDelete(id);
  Future<HttpResult> categoryUpdate(id,name)=> _provider.categoryUpdate(id,name);
  Future<HttpResult> addOperation(type,date,client_id,wallet_id,summa_uzs,summa_usd,which_debt,comment,accept)=> _provider.addOperation(type,date,client_id,wallet_id,summa_uzs,summa_usd,which_debt,comment,accept);
  Future<HttpResult> incomeAll(date,wallet)=> _provider.incomeAll(date,wallet);
  Future<HttpResult> expenseAll(date,wallet,cost)=> _provider.expenseAll(date,wallet,cost);
  Future<HttpResult> debtAll(date,wallet)=> _provider.debtAll(date,wallet);
  Future<HttpResult> deleteWallet(id)=> _provider.deleteWallet(id);
  Future<HttpResult> home()=> _provider.home();
  Future<HttpResult> profile()=> _provider.profile();
  Future<HttpResult> addCost(name)=> _provider.addCost(name);
  Future<HttpResult> deleteCost(id)=> _provider.deleteCost(id);
  Future<HttpResult> updateCost(id,name)=> _provider.updateCost(id,name);
  Future<HttpResult> getCost()=> _provider.getCost();
  Future<HttpResult> updateClient(id,name,phone,summa_uzs,summa_usd,lastopiration_date,comment,category_id)=> _provider.updateClient(id,name,phone,summa_uzs,summa_usd,lastopiration_date,comment,category_id);

}