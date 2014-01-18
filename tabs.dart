import 'dart:async';
import 'messages_all.dart';
import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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

@NgController(
    selector: '[tabs-controller]',
    publishAs: 'controller')
class TabsController {
  List<int> beerCounts = [0, 1, 2, 3, 4, 5, 6];
  String locale;
  DateFormat dateFormat;
  NumberFormat currencyFormat;
  NumberFormat numberFormat;

  TabsController(): this.withLocale('sk');

  TabsController.withLocale(String locale) {
    this.locale = Intl.canonicalizedLocale(locale);
    dateFormat = new DateFormat(DateFormat.YEAR_MONTH_WEEKDAY_DAY, this.locale);
    currencyFormat =
        new NumberFormat(Intl.message(
            '\$#,##0.00',
            name: 'currency_format',
            args: [],
            desc: 'NumberFormat format string for currency amounts',
            locale: this.locale), this.locale);
    numberFormat =
        new NumberFormat(Intl.message(
            '#,##0.###',
            name: 'number_format',
            args: [],
            desc: 'NumberFormat format string for non-currency numbers',
            locale: this.locale), this.locale);
  }

  String beerCountMessage(int count) =>
      Intl.plural(
          count,
          zero: 'no beers',
          one: '$count beer',
          few: '$count beers',
          other: '$count beers',
          args: [count],
          name: 'beer_count_message',
          desc: 'Indicates how many beers there are',
          locale: this.locale);

  String formattedDate(String isoDate) =>
      dateFormat.format(DateTime.parse(isoDate));

  String formattedCurrency(int amount) => currencyFormat.format(amount);

  String formattedNumber(num number) => numberFormat.format(number);
}

class TabsModule extends Module {
  TabsModule() {
    type(PaneComponent);
    type(TabsComponent);
    type(TabsController);
  }
}

main() {
  Future.wait([initializeMessages('en'),
               initializeDateFormatting('en', null),
               initializeMessages('sk'),
               initializeDateFormatting('sk', null)]).then((_) {
    ngBootstrap(module: new TabsModule(), selector: '#tabs-app');
  });
}
