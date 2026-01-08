
class Capex {
  double machineCost;
  double renovationCost;
  double licensingCost;

  Capex({
    this.machineCost = 0,
    this.renovationCost = 0,
    this.licensingCost = 0,
  });

  double get total => machineCost + renovationCost + licensingCost;
}

class Opex {

  // TOR says: "Harga Bahan Baku, Upah Tenaga Kerja, Listrik/Energi, Kemasan"
  // For simulation simplicity, we will treat these as "Variable Costs" per unit OR "Fixed Costs" per month.
  // Ideally:
  // Variable (Per unit): Raw Material, Packaging.
  // Fixed (Per month): Labor, Energy (can be variable too but often estimated monthly).
  
  // Let's assume a simplified mix based on standard FEASIBILITY STUDY:
  // Variable Costs (per unit): Raw Material, Packaging.
  // Fixed Costs (per month): Labor, Energy, Maintenance.
  
  double rawMaterialPerUnit;
  double packagingPerUnit;
  
  double laborCostPerMonth;
  double energyCostPerMonth;
  double otherFixedCostPerMonth;

  Opex({
    this.rawMaterialPerUnit = 0,
    this.packagingPerUnit = 0,
    this.laborCostPerMonth = 0,
    this.energyCostPerMonth = 0,
    this.otherFixedCostPerMonth = 0,
  });

  double variableCostPerUnit() => rawMaterialPerUnit + packagingPerUnit;
  double fixedCostPerMonth() => laborCostPerMonth + energyCostPerMonth + otherFixedCostPerMonth;
}

class ProductionData {
  double capacityPerMonth; // Max capacity or target sales
  double salesPricePerUnit;

  ProductionData({
    this.capacityPerMonth = 0,
    this.salesPricePerUnit = 0,
  });
}

class SimulationResult {
  final double bepUnit;
  final double bepRupiah;
  final double profitPerMonth;
  final double roiPercentage;
  final double totalRevisionRevenue;
  final double totalVariableCost;
  final double totalFixedCost;

  SimulationResult({
    required this.bepUnit,
    required this.bepRupiah,
    required this.profitPerMonth,
    required this.roiPercentage,
    required this.totalRevisionRevenue,
    required this.totalVariableCost,
    required this.totalFixedCost,
  });
}
