import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:simple_note/business_logic/blocs/bloc/notes_bloc.dart';
import 'package:simple_note/data/dataproviders/dataprovider.dart';
import 'package:simple_note/data/dataproviders/httpclient.dart';

class ModuleContainer {
  static Injector? _injector;

  static Injector _initialise(Injector injector) {
    injector.map<IDataProvider>((i) => HttpClientImpl(), isSingleton: true);
    injector.map<NotesBloc>((i) => NotesBloc(i.get<IDataProvider>()),
        isSingleton: false);

    return injector;
  }

  static Injector getInjector() {
    return _injector ?? _initialise(Injector());
  }
}
