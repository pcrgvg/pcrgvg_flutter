import 'dart:convert';
import 'dart:io';

Future<void> main() async {
   var metaFile = File("releases/meta.json");
    HttpClient httpClient = HttpClient();
     var request = await httpClient.getUrl(Uri.parse(
      "https://api.github.com/repos/pcrgvg/pcrgvg_flutter/releases/latest"));
}