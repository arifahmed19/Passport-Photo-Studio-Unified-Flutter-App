import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.05),
                  Theme.of(context).scaffoldBackgroundColor,
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  children: [
                    // Avatar & Name
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white10,
                      child: Icon(Icons.person_rounded, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      user?.email ?? 'Developer',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Free Account',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 13),
                    ),
                    const SizedBox(height: 40),
                    
                    // About Info Card
                    _buildGlassCard(
                      context,
                      title: 'About The Project',
                      content: 'Passport Photo Studio is an automated studio-grade application for creating official photos. Built with Flutter, Supabase, and a custom Glassmorphism UI.\n\nVersion: 1.0.0 (Release Build)',
                      icon: Icons.info_outline_rounded,
                    ),
                    const SizedBox(height: 16),
                    
                    // Developer Card
                    _buildGlassCard(
                      context,
                      title: 'Developer',
                      content: 'Created by Arif Ahmed\nGitHub: @arifahmed19',
                      icon: Icons.code_rounded,
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Sign Out Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          authProvider.logout();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Sign Out'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent, width: 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context, {required String title, required String content, required IconData icon}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 12),
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
