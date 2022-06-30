part of 'extensions.dart';

extension StringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  void toast() {
    if (isNullOrEmpty) {
      return;
    }
    //  showToast(this!);
    showToastWidget(Builder(builder: (BuildContext context) {
      final Color bgc = Theme.of(context).colorScheme.secondary;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[bgc, bgc.withOpacity(0.87)],
              ),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.024),
                  offset: const Offset(0, 1),
                  blurRadius: 3.0,
                  spreadRadius: 3.0,
                ),
              ],
            ),
            child: Text(
              this!,
              style: TextStyle(
                color:
                    bgc.computeLuminance() < 0.5 ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }));
  }

  ToastFuture loading() {
    return showToastWidget(Builder(builder: (BuildContext context) {
      final Color bgc = Theme.of(context).colorScheme.secondary;
      return Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Images.loading, width: 200),
              if (!isNullOrEmpty)
                Text(this!,
                    style: TextStyle(
                      fontSize: 18,
                      color: bgc.computeLuminance() < 0.5
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ))
            ],
          ),
        ),
      );
    }),
        position: ToastPosition.center,
        duration: const Duration(hours: 24),
        handleTouch: true);
  }

  String dateFormate({String newPattern = 'yyyy/MM'}) {
    if (isNullOrEmpty) {
      return '';
    }
    final String timeStr = this!.replaceAll('/', '-');
    final DateTime? time = DateTime.tryParse(timeStr); // 2012-02-27 13:27:00
    if (time == null) {
      return '';
    }
    return DateFormat(newPattern).format(time).toString();
  }


  Future<void> launchApp() async {
    if (isNullOrEmpty) {
      "链接为空".toast();
      return;
    }
    if (await canLaunchUrlString(this!)) {
      await launchUrlString(this!, mode: LaunchMode.externalApplication);
    }
  }
}
