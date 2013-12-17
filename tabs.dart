import 'dart:html' as dom;
import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:intl/intl.dart';

@NgComponent(
    selector: 'tabs',
    templateUrl: 'tabs.html',
    applyAuthorStyles: true,
    publishAs: 'tabs'
)
class TabsComponent {
  static TabsController instance;

  List<PaneComponent> panes = [];

  TabsComponent() {
    instance = this;
  }

  void select(var pane) {
    for (var i = 0; i < panes.length; i++) {
      this.panes[i].selected = false;
    }
    pane.selected = true;
  }

  void addPane(PaneComponent pane) {
    if (this.panes.length == 0) {
      this.select(pane);
    }
    this.panes.add(pane);
  }
}

@NgComponent(
    selector: 'pane',
    templateUrl: 'pane.html',
    map: const {'title' : '@'},
    applyAuthorStyles: true,
    publishAs: 'pane'
)
class PaneComponent implements NgAttachAware {
  String title = '';
  bool selected = false;

  void attach() {
    TabsComponent.instance.addPane(this);
  }
}

@NgController(
    selector: '[id=tabs-app]',
    publishAs: 'TabsCtrl')
class TabsController {
  List<int> beerCounts = [0, 1, 2, 3, 4, 5, 6];
  String messageFormat;

  TabsController() {
    if (Intl.defaultLocale.toString() == 'sk_SK') {
    } else {  // en_US
//      messageFormat = '''${Intl.plural(beer_count, {
//                           '0': 'no beers',
//                           '1': 'one beer',
//                           'other': '$beer_count beers'
//                         })}''';
    }
  }

  String beerMessage(int count) => Intl.message(
       this.messageFormat,
       name: 'beer_count_message',
       args: [beer_count],
       desc: 'Description of how many beers there are.',
       examples: {'beer_count': 3});
}

class TabsModule extends Module {
  TabsModule() {
    type(TabsComponent);
    type(PaneComponent);
    type(TabsController);
  }
}

main() {
  ngBootstrap(module: new TabsModule(), selector: '#tabs-app');
}
