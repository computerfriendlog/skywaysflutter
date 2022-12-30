
class PaymentCard{
  String? card_id, cardnumber;
  String? exp_month, exp_year;
  String? cvc, cardtype;


  PaymentCard({
    this.cardtype,
    this.exp_month,
    this.cardnumber,
    this.exp_year,
    this.cvc,
    this.card_id,
  });

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    return PaymentCard(
      cardtype: json['cardtype'] as String ?? '',
      exp_month: json['exp_month'] as String ?? '',
      cardnumber: json['cardnumber'] as String ?? '',
      exp_year: json['exp_year'] as String ?? '',
      cvc: json['cvc'] as String ?? '',
      card_id: json['card_id'] as String ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cardtype'] = cardtype;
    data['exp_month'] = exp_month;
    data['cardnumber'] = cardnumber;
    data['exp_year'] = exp_year;
    data['cvc'] = cvc;
    data['card_id'] = card_id;
    return data;
  }
}