import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';
import '../model/Rental.dart';

class StripeService {
  static String secretKey =
      "sk_test_51OwSQoKZ4UctLDnykEKDlD1po60L6ccBh3y7H6kkHkQKU4Fi8gN0BTJWkNgEmzvGr6baoAoONKt01D80VialfHTE00IFbHs1j5";
  static String publishableKey =
      "pk_test_51OwSQoKZ4UctLDnyHh2wO9ZfjPT5Ek5ygy1eE4s4X7zLAq7vfziZZauuCmp2z69NJDer0qpfh3iyOkvw7efgu6JW00DOuEZixZ";

  static Future<dynamic> createCheckoutSession(
      List<Rental> productItems, int totalAmount, int days) async {
    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");
    String lineItems = "";
    int index = 0;
    productItems.forEach((rental) {
      var productPrice = ((((int.parse(rental.dailyCost))*days)* 100).round().toString());
      lineItems +=
          "&line_items[$index][price_data][product_data][name] =${rental.title}"
          "&line_items[$index][price_data][unit_amount]=$productPrice"
          "&line_items[$index][price_data][currency]=EUR"
          "&line_items[$index][quantity]=$totalAmount";
      index++;
    });
    final response = await http.post(url,
        body:
            'success_url=http://www.checkout.stripe.dev/success&mode=payment$lineItems',
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-type': 'application/x-www-form-urlencoded'
        });
    print(response.body);
    return json.decode(response.body)["id"];
  }

  static Future<dynamic> stripePaymentCheckout(
      productItems, subTotal, days, context, mounted,
      {onSuccess, onCancel, onError}) async {
    List<Rental> rentals = [];
    rentals.add(productItems);
    final String sessionId =
        await createCheckoutSession(rentals, subTotal, days);
    final result = await redirectToCheckout(
        context: context,
        sessionId: sessionId,
        publishableKey: publishableKey,
        successUrl: "https://www.checkout.stripe.dev/success",
        canceledUrl: "https://www.checkout.stripe.dev/cancel");
    if (mounted) {
      final text = result.when(
          redirected: () => 'Redirected Successfuly',
          success: () => onSuccess,
          canceled: () => onCancel,
          error: (e) => onError(e));
      return text;
    }
  }
}
