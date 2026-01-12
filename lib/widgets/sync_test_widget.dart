import 'package:flutter/material.dart';
import 'package:campuswork/services/group_service.dart';
import 'package:campuswork/services/data_sync_service.dart';
import 'package:campuswork/model/group.dart';
import 'package:campuswork/model/user.dart';
import 'package:uuid/uuid.dart';

/// Widget de test pour démontrer la synchronisation des données
class SyncTestWidget extends StatefulWidget {
  final User currentUser;

  const SyncTestWidget({super.key, required this.currentUser});

  @override
  State<SyncTestWidget> createState() => _SyncTestWidgetState();
}

class _SyncTestWidgetState extends State<SyncTestWidget> {
  final GroupService _groupService = GroupService();
  final DataSyncService _syncService = DataSyncService();
  List<Group> _groups = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() => _isLoading = true);
    
    try {
      final groups = await _groupService.getAllGroupsAsync();
      setState(() {
        _groups = groups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Future<void> _createTestGroup() async {
    setState(() => _isLoading = true);
    
    try {
      final testGroup = Group(
        name: 'Groupe Test ${DateTime.now().millisecondsSinceEpoch}',
        description: 'Groupe créé pour tester la synchronisation des données',
        createdBy: widget.currentUser.userId,
        type: GroupType.project,
        maxMembers: 5,
        members: [widget.currentUser.userId],
        projects: [],
        isOpen: true,
        createdAt: DateTime.now(),
      );

      final success = await _groupService.createGroup(testGroup);
      
      if (success) {
        await _loadGroups();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Groupe de test créé avec succès !'),
                ],
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Échec de la création du groupe');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la création: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshData() async {
    await _loadGroups();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.refresh, color: Colors.white),
              SizedBox(width: 12),
              Text('Données actualisées'),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.sync,
                    color: Color(0xFF4A90E2),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test de Synchronisation',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1D29),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Testez la synchronisation des données en temps réel',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8EDF2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${_groups.length}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Groupes totaux',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: const Color(0xFFE8EDF2),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${_groups.where((g) => g.createdBy == widget.currentUser.userId).length}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Mes groupes',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _createTestGroup,
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add_circle_outline),
                    label: const Text('Créer Groupe Test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A90E2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _refreshData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Actualiser'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4A90E2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFF59E0B),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Créez un groupe ici, puis vérifiez qu\'il apparaît dans la liste des groupes des autres utilisateurs.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}