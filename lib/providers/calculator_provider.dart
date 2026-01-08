
import 'package:flutter/material.dart';
import '../models/simulation_data.dart';

class CalculatorProvider with ChangeNotifier {
  Capex capex = Capex();
  Opex opex = Opex();
  ProductionData productionData = ProductionData();
  SimulationResult? result;

  void updateCapex({double? machine, double? renovation, double? licensing}) {
    if (machine != null) capex.machineCost = machine;
    if (renovation != null) capex.renovationCost = renovation;
    if (licensing != null) capex.licensingCost = licensing;
    calculate();
    notifyListeners();
  }

  void updateOpex({
    double? rawMaterial,
    double? packaging,
    double? labor,
    double? energy,
    double? other,
  }) {
    if (rawMaterial != null) opex.rawMaterialPerUnit = rawMaterial;
    if (packaging != null) opex.packagingPerUnit = packaging;
    if (labor != null) opex.laborCostPerMonth = labor;
    if (energy != null) opex.energyCostPerMonth = energy;
    if (other != null) opex.otherFixedCostPerMonth = other;
    calculate();
    notifyListeners();
  }

  void updateProduction({double? capacity, double? price}) {
    if (capacity != null) productionData.capacityPerMonth = capacity;
    if (price != null) productionData.salesPricePerUnit = price;
    calculate();
    notifyListeners();
  }

  void calculate() {
    double totalCapex = capex.total;
    
    double variableCostPerUnit = opex.variableCostPerUnit();
    double totalFixedCost = opex.fixedCostPerMonth();
    
    double pricePerUnit = productionData.salesPricePerUnit;
    double capacity = productionData.capacityPerMonth;
    
    // Revenue & Costs
    double totalRevenue = pricePerUnit * capacity;
    double totalVariableCost = variableCostPerUnit * capacity;
    
    // Profit
    double profit = totalRevenue - (totalVariableCost + totalFixedCost);
    
    // BEP Calculation
    double contributionMarginUnit = pricePerUnit - variableCostPerUnit;
    double bepUnit = 0;
    double bepRupiah = 0;
    
    if (contributionMarginUnit > 0) {
      bepUnit = totalFixedCost / contributionMarginUnit;
      bepRupiah = bepUnit * pricePerUnit;
    } else {
      // If variable cost > price, contribution is negative.
      // Technically BEP is impossible.
      bepUnit = 0; 
      bepRupiah = 0;
    }

    // ROI (Annualized)
    // ROI = (Annual Profit / Total Investment) * 100
    double annualProfit = profit * 12;
    double roi = 0;
    if (totalCapex > 0) {
      roi = (annualProfit / totalCapex) * 100;
    }

    result = SimulationResult(
      bepUnit: bepUnit,
      bepRupiah: bepRupiah,
      profitPerMonth: profit,
      roiPercentage: roi,
      totalRevisionRevenue: totalRevenue,
      totalVariableCost: totalVariableCost,
      totalFixedCost: totalFixedCost,
    );
  }
  
  // Reset
  void reset() {
    capex = Capex();
    opex = Opex();
    productionData = ProductionData();
    result = null;
    notifyListeners();
  }
}
