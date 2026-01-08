
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Color color;
  final IconData? icon;

  const FormSection({
    Key? key,
    required this.title,
    required this.children,
    this.color = Colors.blue,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon ?? Icons.edit, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class SmartSimulationInput extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final double max;
  final bool isCurrency;
  final String suffix;

  const SmartSimulationInput({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.max = 100000000, // Default distinct max
    this.isCurrency = true,
    this.suffix = '',
  }) : super(key: key);

  @override
  State<SmartSimulationInput> createState() => _SmartSimulationInputState();
}

class _SmartSimulationInputState extends State<SmartSimulationInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.value));
  }

  @override
  void didUpdateWidget(SmartSimulationInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
       // Check if the text matches the value (avoid loop issues)
       final currentVal = double.tryParse(_controller.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
       if (currentVal != widget.value) {
           // Only update text if it's external change
           _controller.text = _formatValue(widget.value);
       }
    }
  }

  String _formatValue(double v) {
    return v == 0 ? '' : v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              labelText: widget.label,
              prefixText: widget.isCurrency ? 'Rp ' : null,
              suffixText: widget.suffix,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            onChanged: (val) {
              final double v = double.tryParse(val) ?? 0;
              widget.onChanged(v);
            },
          ),
          // Optional Slider logic: 
          // If value is within a "slide-able" range, show slider.
          // For huge numbers (Capex), slider is hard. For capacity/price, it's cool.
          // Let's enable Slider only if max < 10B. But to make it useful, we need dynamic max?
          // For this MVP, let's add a "Simulation Slider" that goes from 0 to 2*Value (or a fixed reasonable max)
          // If the user hasn't typed anything, slider is 0.
          if (widget.value > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: SizedBox(
                height: 24,
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                  ),
                  child: Slider(
                    value: (widget.value > widget.max) ? widget.max : widget.value,
                    min: 0,
                    max: widget.max > widget.value ? widget.max : widget.value * 2, 
                    activeColor: Theme.of(context).primaryColor.withOpacity(0.7),
                    inactiveColor: Colors.grey[200],
                    onChanged: (val) {
                      widget.onChanged(val);
                      _controller.text = val.toStringAsFixed(0);
                    },
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
