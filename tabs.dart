import 'dart:async';
import 'dart:math';
import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:intl/date_symbol_data_local.dart';
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

  void addPane(PaneComponent paneToAdd) {
    paneToAdd.selected = (this.panes.length == 0);
    this.panes.add(paneToAdd);
  }

  void selectPane(PaneComponent paneToSelect) {
    this.panes.forEach((PaneComponent pane) {
      pane.selected = (pane == paneToSelect);
    });
  }
}

@NgComponent(
    selector: 'pane',
    templateUrl: 'pane.html',
    cssUrl: 'pane.css',
    applyAuthorStyles: true,
    publishAs: 'pane',
    map: const {'title': '@'}
)
class PaneComponent {
  String title = '';
  bool selected = false;

  PaneComponent(TabsComponent tabs) {
    tabs.addPane(this);
  }
}

@NgController(
    selector: '.tabs-app',
    publishAs: 'controller',
    map: const {'foo': '@'}
)
class TabsController {
  List<int> beerCounts = [0, 1, 2, 3, 4, 5, 6];
  String foo;
  DateFormat dateFormat;
  NumberFormat numberFormat;
  NumberFormat currencyFormat;
  List<String> beerMessages;

  TabsController() {
    this.setLocale(Intl.defaultLocale);
  }

  setLocale(String locale) {
    locale = Intl.canonicalizedLocale(locale);
    this.dateFormat = new DateFormat('yMMMMEEEEd', locale);
    this.numberFormat = new NumberFormat('#,##0.###', locale);
    if (locale == 'sk') {
      this.currencyFormat = new NumberFormat('#,##0.00 \u20AC');
      this.beerMessages = ['\u017Eiadne pivo', '{} pivo', '{} piv\u00E1'];
      this.beerMessages.addAll(['{} piv\u00E1', '{} piv\u00E1', '{} p\u00EDv']);
    } else {
      this.currencyFormat = new NumberFormat('\$#,##0.00');
      this.beerMessages = ['no beers', '{} beer', '{} beers'];
    }
  }

  String formattedDate(String iso) => dateFormat.format(DateTime.parse(iso));

  String formattedNumber(num number) => numberFormat.format(number);

  String formattedCurrency(int amount) => currencyFormat.format(amount);

  String beerCountMessage(int count) =>
      this.beerMessages[min(count, this.beerMessages.length - 1)]
          .replaceAll('{}', count.toString());
}

class TabsModule extends Module {
  TabsModule() {
    type(PaneComponent);
    type(TabsComponent);
    type(TabsController);
  }
}

main() {
  Future.wait([initializeDateFormatting('en', null),
               initializeDateFormatting('sk', null)]).then((_) {
    ngBootstrap(module: new TabsModule(), selector: '.tabs-app');
  });
}
