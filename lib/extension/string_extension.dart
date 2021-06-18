
part of 'extensions.dart';

extension StringExtension on String? {
   bool get isNullOrEmpty => this == null || this!.isEmpty;
   void toast() {
     if (isNullOrEmpty) {
       return;
     }
    //  showToast(this!);
     showToastWidget(Builder(builder: ( BuildContext context) {
          final Color bgc = Theme.of(context).accentColor;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[bgc, bgc.withOpacity(0.87)],
                  ),
                  borderRadius: const BorderRadius.all( Radius.circular(8.0)),
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
                    color: bgc.computeLuminance() < 0.5
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        }));
   }
}