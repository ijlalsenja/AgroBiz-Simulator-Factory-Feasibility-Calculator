
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/calculator_provider.dart';
import '../widgets/input_widgets.dart';
import '../widgets/result_card.dart';
import '../widgets/cost_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "AgroBiz Simulator",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<CalculatorProvider>().reset();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Simulasi di-reset')),
              );
            },
            tooltip: 'Reset Simulasi',
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B5E20), // Dark Green
              Color(0xFF4CAF50), // Standard Green
              Color(0xFF81C784), // Light Green
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                // Desktop / Wide Web View
                return Container(
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                       BoxShadow(
                         color: Colors.black.withOpacity(0.1),
                         blurRadius: 20,
                         offset: const Offset(0, 10),
                       )
                    ]
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: const InputSplitView(),
                        ),
                      ),
                      VerticalDivider(width: 1, color: Colors.grey[300]),
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: const ResultSplitView(),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // Mobile View - Use Container for white bg effect or keep transparent?
                // For better readability on mobile, let's use a white container for the body part
                return Container(
                  decoration: const BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.vertical(top: Radius.circular(30))
                  ),
                  margin: const EdgeInsets.only(top: 16),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          labelColor: Color(0xFF1B5E20),
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Color(0xFF1B5E20),
                          tabs: [
                            Tab(icon: Icon(Icons.input), text: "Input Data"),
                            Tab(icon: Icon(Icons.analytics), text: "Hasil Simulasi"),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(20),
                                child: const InputSplitView(),
                              ),
                               SingleChildScrollView(
                                padding: const EdgeInsets.all(20),
                                child: const ResultSplitView(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class InputSplitView extends StatelessWidget {
  const InputSplitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CalculatorProvider>();
    // Using watch here because we want sliders to update smoothly if multiple inputs depend on each other,
    // though here they are independent mostly.
    
    return Column(
      children: [
        FormSection(
          title: "1. Modal Awal (CAPEX)",
          color: Colors.purple,
          icon: Icons.domain,
          children: [
            SmartSimulationInput(
              label: "Harga Mesin / Peralatan",
              value: provider.capex.machineCost,
              max: 500000000, // 500 Juta Max for Slider
              onChanged: (val) => provider.updateCapex(machine: val),
            ),
            SmartSimulationInput(
              label: "Renovasi Bangunan",
              value: provider.capex.renovationCost,
              max: 200000000,
              onChanged: (val) => provider.updateCapex(renovation: val),
            ),
             SmartSimulationInput(
              label: "Perizinan & Lainnya",
              value: provider.capex.licensingCost,
              max: 50000000,
              onChanged: (val) => provider.updateCapex(licensing: val),
            ),
          ],
        ),
        FormSection(
          title: "2. Produksi & Penjualan",
          color: Colors.blue,
          icon: Icons.production_quantity_limits,
          children: [
            SmartSimulationInput(
              label: "Kapasitas Produksi (per Bulan)",
              suffix: " Unit/Kg",
              value: provider.productionData.capacityPerMonth,
              max: 10000, // Reasonable max for SME
              isCurrency: false,
              onChanged: (val) => provider.updateProduction(capacity: val),
            ),
             SmartSimulationInput(
              label: "Harga Jual (per Unit/Kg)",
              value: provider.productionData.salesPricePerUnit,
              max: 200000, // 200rb Max Price
              onChanged: (val) => provider.updateProduction(price: val),
            ),
          ],
        ),
        FormSection(
          title: "3. Biaya Operasional (OPEX)",
          color: Colors.orange,
          icon: Icons.work,
          children: [
            const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text("Biaya Variabel (Per Unit)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey))
            ),
            SmartSimulationInput(
              label: "Bahan Baku",
              value: provider.opex.rawMaterialPerUnit,
              max: 100000,
              onChanged: (val) => provider.updateOpex(rawMaterial: val),
            ),
            SmartSimulationInput(
              label: "Kemasan",
              value: provider.opex.packagingPerUnit,
              max: 10000,
              onChanged: (val) => provider.updateOpex(packaging: val),
            ),
            const Divider(height: 32),
            const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child:Text("Biaya Tetap (Per Bulan)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey))
            ),
             SmartSimulationInput(
              label: "Tenaga Kerja",
              value: provider.opex.laborCostPerMonth,
              max: 50000000, // 50 Juta Gaji
              onChanged: (val) => provider.updateOpex(labor: val),
            ),
             SmartSimulationInput(
              label: "Listrik & Energi",
              value: provider.opex.energyCostPerMonth,
              max: 10000000,
              onChanged: (val) => provider.updateOpex(energy: val),
            ),
             SmartSimulationInput(
              label: "Lain-lain (Maintenance)",
              value: provider.opex.otherFixedCostPerMonth,
              max: 5000000,
              onChanged: (val) => provider.updateOpex(other: val),
            ),
          ],
        ),
      ],
    );
  }
}

class ResultSplitView extends StatelessWidget {
  const ResultSplitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final result = context.watch<CalculatorProvider>().result;
    
    if (result == null) {
      return const EmptyState();
    }
    
    final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final compactFmt = NumberFormat.compactCurrency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dashboard Kinerja", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          childAspectRatio: 1.5,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ResultCard(
              title: "Laba Bersih / Bulan",
              value: compactFmt.format(result.profitPerMonth),
              subtitle: result.profitPerMonth >= 0 ? "Untung" : "Rugi",
              isPositive: result.profitPerMonth >= 0,
              color: Colors.green,
            ),
             ResultCard(
              title: "ROI (Tahunan)",
              value: "${result.roiPercentage.toStringAsFixed(1)}%",
              subtitle: "Return on Investment",
              color: Colors.purple,
            ),
             ResultCard(
              title: "BEP (Unit)",
              value: NumberFormat.decimalPattern('id_ID').format(result.bepUnit),
              subtitle: "Titik Impas Produksi",
              color: Colors.orange,
            ),
             ResultCard(
              title: "BEP (Rupiah)",
              value: compactFmt.format(result.bepRupiah),
              subtitle: "Omzet Minimal",
              color: Colors.blue,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text("Proporsi Biaya", style: Theme.of(context).textTheme.titleMedium),
        CostChart(result: result),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildRow("Total Pendapatan", result.totalRevisionRevenue, currencyFmt, isBold: true),
                const Divider(),
                _buildRow("Total Biaya Variabel", result.totalVariableCost, currencyFmt, color: Colors.blue),
                _buildRow("Total Biaya Tetap", result.totalFixedCost, currencyFmt, color: Colors.orange),
                const Divider(),
                _buildRow("Profit Margin", (result.profitPerMonth / result.totalRevisionRevenue) * 100, null, suffix: "%"),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRow(String label, double value, NumberFormat? fmt, {bool isBold = false, Color? color, String? suffix}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
           Text(
             "${fmt?.format(value) ?? value.toStringAsFixed(1)}${suffix ?? ''}",
             style: TextStyle(
               fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
               color: color,
             ),
           ),
        ],
      ),
    );
  }
}
