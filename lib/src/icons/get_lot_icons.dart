// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:models_weebi/weebi_models.dart'
    show ProxyArticle;

Icon getProxyIcons(ProxyArticle proxy) {
  if (proxy.id == null) {
    return const Icon(Icons.check_box_outline_blank, color: Colors.grey);
  } else if (proxy.id == 1) {
    return const Icon(Icons.looks_one, color: Colors.grey);
  } else if (proxy.id == 2) {
    return const Icon(Icons.looks_two, color: Colors.grey);
  } else if (proxy.id == 3) {
    return const Icon(Icons.looks_3, color: Colors.grey);
  } else if (proxy.id == 4) {
    return const Icon(Icons.looks_4, color: Colors.grey);
  } else if (proxy.id == 5) {
    return const Icon(Icons.looks_5, color: Colors.grey);
  } else if (proxy.id == 6) {
    return const Icon(Icons.looks_6, color: Colors.grey);
  } else
    return const Icon(Icons.check_box_outline_blank, color: Colors.grey);
}
