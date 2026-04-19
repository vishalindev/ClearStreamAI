import 'package:flutter/material.dart';

import '../../core/roles.dart';
import '../auth/auth_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.authController});

  final AuthController authController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tenantController = TextEditingController();
  final _inviteEmailController = TextEditingController();
  final _inviteNameController = TextEditingController();
  RoleName _inviteRole = RoleName.platformUser;

  @override
  void dispose() {
    _tenantController.dispose();
    _inviteEmailController.dispose();
    _inviteNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ClearStreamAI SaaS')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Tenant: ${widget.authController.tenantName}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<RoleName>(
            value: widget.authController.activeRole,
            decoration: const InputDecoration(labelText: 'Current role'),
            items: RoleName.values
                .map((role) => DropdownMenuItem(value: role, child: Text(role.label)))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => widget.authController.updateRole(value));
            },
          ),
          const SizedBox(height: 24),
          Text('Create tenant', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          TextFormField(
            controller: _tenantController,
            decoration: const InputDecoration(labelText: 'Tenant name'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              if (_tenantController.text.trim().isEmpty) return;
              widget.authController.updateTenant(_tenantController.text.trim());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tenant set locally. Wire API next.')),
              );
            },
            child: const Text('Save Tenant'),
          ),
          const Divider(height: 36),
          Text('Invite tenant member', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          TextFormField(
            controller: _inviteNameController,
            decoration: const InputDecoration(labelText: 'Full name'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _inviteEmailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<RoleName>(
            value: _inviteRole,
            decoration: const InputDecoration(labelText: 'Role'),
            items: RoleName.values
                .where((role) => role != RoleName.corporate)
                .map((role) => DropdownMenuItem(value: role, child: Text(role.label)))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _inviteRole = value);
            },
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              if (_inviteNameController.text.isEmpty || _inviteEmailController.text.isEmpty) {
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Invite prepared for ${_inviteEmailController.text} (${_inviteRole.label}).'),
                ),
              );
            },
            child: const Text('Invite Member'),
          ),
        ],
      ),
    );
  }
}
