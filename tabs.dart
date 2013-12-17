import 'dart:html' as dom;
import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:intl/intl.dart';

@NgComponent(
    selector: 'tabs',
    templateUrl: 'tabs.html',
    cssUrl: 'tabs.css',
    publishAs: 'tabs',
    visibility: NgDirective.DIRECT_CHILDREN_VISIBILITY
)
class TabsComponent {
  List<PaneComponent> panes = [];

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
    cssUrl: 'pane.css',
    applyAuthorStyles: true,
    publishAs: 'pane',
    map: const {'title' : '@'}
)
class PaneComponent {
  String title = '';
  bool selected = false;

  PaneComponent(TabsComponent tabs) {
    tabs.addPane(this);
  }
}

@NgController(
    selector: '[beer-counter]',
    publishAs: 'beerCounter')
class BeerCounter {
  List<int> beerCounts = [0, 1, 2, 3, 4, 5, 6];
  Function getMessage;

  BeerCounter() {
    if (Intl.defaultLocale.toString() == 'sk_SK') {
      this.getMessage = (beer_count) => Intl.plural(
          beer_count,
          zero: '\u017Eiadne pivo',
          one: '$beer_count pivo',
          few: '$beer_count piv\u00E1',
          other: '$beer_count p\u00EDv');
    } else {
      this.getMessage = (beer_count) => Intl.plural(
          beer_count,
          zero: 'no beers',
          one: '$beer_count beer',
          few: '$beer_count beers',
          other: '$beer_count beers');
    }
  }

}

class TabsModule extends Module {
  TabsModule() {
    type(TabsComponent);
    type(PaneComponent);
    type(BeerCounter);
  }
}

main() {
  ngBootstrap(module: new TabsModule(), selector: '#tabs-app');
}
