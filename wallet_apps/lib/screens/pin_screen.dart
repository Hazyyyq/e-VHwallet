import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class PinScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(String) onPinComplete;
  final bool isConfirmation;

  const PinScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPinComplete,
    this.isConfirmation = false,
  });

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';
  String? _firstPin;
  String? _error;

  void _onKeyPressed(String key) {
    HapticFeedback.lightImpact();
    
    if (key == 'delete') {
      if (_pin.isNotEmpty) {
        setState(() {
          _pin = _pin.substring(0, _pin.length - 1);
          _error = null;
        });
      }
    } else if (key == 'clear') {
      setState(() {
        _pin = '';
        _error = null;
      });
    } else {
      if (_pin.length < 6) {
        setState(() {
          _pin += key;
          _error = null;
        });
        
        if (_pin.length == 6) {
          if (widget.isConfirmation) {
            if (_firstPin == null) {
              setState(() {
                _firstPin = _pin;
                _pin = '';
              });
            } else if (_firstPin == _pin) {
              widget.onPinComplete(_pin);
            } else {
              setState(() {
                _error = 'PINs do not match';
                _pin = '';
                _firstPin = null;
              });
            }
          } else {
            widget.onPinComplete(_pin);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.lock_rounded,
                size: 60,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.isConfirmation && _firstPin != null
                    ? 'Confirm your PIN'
                    : widget.subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildPinDots(),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ],
              const Spacer(),
              _buildKeypad(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final isFilled = index < _pin.length;
        return Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isFilled ? AppColors.primary : Colors.white.withOpacity(0.5),
              width: 2,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['clear', '0', 'delete'],
    ];

    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: row.map((key) {
              if (key == 'clear' || key == 'delete') {
                return _buildKeyButton(
                  child: key == 'delete'
                      ? const Icon(Icons.backspace_outlined, color: Colors.white)
                      : const Text(
                          'Clear',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                  onTap: () => _onKeyPressed(key),
                  isText: key == 'clear',
                );
              }
              return _buildKeyButton(
                child: Text(
                  key,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                onTap: () => _onKeyPressed(key),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKeyButton({
    required Widget child,
    required VoidCallback onTap,
    bool isText = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: isText
                ? null
                : Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
