import 'dart:async';

import 'package:couponcom/models/coupons_model.dart';
import 'package:couponcom/api/services.dart';
import 'package:couponcom/bloc/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class CouponBloc implements BaseBloc {
  final _couponController = StreamController();
  final increaseController = StreamController();
  final _id = BehaviorSubject<int>();
  final _storeId = BehaviorSubject<int>();

//final _queryController =StreamController();
  Function(int) get getId => _id.sink.add;

  Function(int) get getStoreId => _storeId.sink.add;

  Stream<List<CouponModel>> get couponsListView async* {
    yield await Services.getCoupons();
  }

  Stream<List<CouponModel>> filterCouponsListView(query) {
    return Stream.fromFuture(Services.getCouponsFiltred(query));
  }

  CouponBloc() {
    couponsListView
        .distinct()
        .listen((list) => _couponController.add(list.length));
  }

  updateData() {
    print(_id.value);
    print(_storeId.value);
    Services.editCount(_id.value, _storeId.value);
  }

  @override
  ondispose() {
    //	_queryController.close();
    _couponController.close();
    increaseController.close();
    _id.close();
    _storeId.close();
  }
}
