import 'package:flutter/material.dart';

class ServerConfigForm extends StatefulWidget {
  const ServerConfigForm(BuildContext ctx, {super.key});

  @override
  _ServerConfigFormState createState() => _ServerConfigFormState();
}

class _ServerConfigFormState extends State<ServerConfigForm> {
  final _formKey = GlobalKey<FormState>();

  bool _useIpAddress = false;
  final _ipControllers =
      List<TextEditingController>.generate(4, (_) => TextEditingController());
  final _domainController = TextEditingController();

  String _domainName = '';
  String _ipAddress = '';
  int _portNumber = 80;
  int _apiVersion = 0;

  @override
  void dispose() {
    for (var controller in _ipControllers) {
      controller.dispose();
    }
    _domainController.dispose();
    super.dispose();
  }

  void _toggleIPMode(bool useIpAddress) {
    setState(() {
      _useIpAddress = useIpAddress;
    });
  }

  String _buildIpAddress() {
    return _ipControllers.map((controller) => controller.text).join('.');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 300,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Server Configuration', textAlign: TextAlign.center),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Use IP Address:'),
                Switch(
                  value: _useIpAddress,
                  onChanged: _toggleIPMode,
                ),
              ],
            ),
            if (_useIpAddress)
              Row(
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: _ipControllers[index],
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        // decoration: InputDecoration(labelText: 'Part ${index + 1}'),
                      ),
                    ),
                  ),
                ),
              ),
            if (!_useIpAddress)
              TextFormField(
                controller: _domainController,
                decoration: const InputDecoration(labelText: 'Domain Name'),
              ),
            Row(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Port number'),
                  onSaved: (newValue) => _portNumber = (newValue as int),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'API version'),
                  onSaved: (newValue) => _apiVersion = (newValue as int),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.purple)),
              onPressed: () {
                String address =
                    _useIpAddress ? _buildIpAddress() : _domainController.text;
                // Use the captured address for further processing (e.g., saving, validation)
                print('Address: $address');
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
