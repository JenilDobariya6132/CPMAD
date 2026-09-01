class ElectricityBill {
  String consumerName;
  double units;

  static const double fixedCharge = 100;

  ElectricityBill({
    required this.consumerName,
    required this.units,
  });

  // Calculate electricity charge according to slabs
  double calculateEnergyCharge() {
    double charge = 0;

    if (units <= 100) {
      charge = units * 3;
    } else if (units <= 200) {
      charge = (100 * 3) + ((units - 100) * 5);
    } else if (units <= 400) {
      charge =
          (100 * 3) +
          (100 * 5) +
          ((units - 200) * 7);
    } else {
      charge =
          (100 * 3) +
          (100 * 5) +
          (200 * 7) +
          ((units - 400) * 9);
    }

    return charge;
  }

  // Calculate total bill
  double calculateTotalBill() {
    return calculateEnergyCharge() + fixedCharge;
  }

  // Get slab description
  String getSlab() {
    if (units <= 100) {
      return 'Slab 1: 0–100 units';
    } else if (units <= 200) {
      return 'Slab 2: 101–200 units';
    } else if (units <= 400) {
      return 'Slab 3: 201–400 units';
    } else {
      return 'Slab 4: Above 400 units';
    }
  }
}