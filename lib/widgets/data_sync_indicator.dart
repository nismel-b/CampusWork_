import 'package:flutter/material.dart';
import 'package:campuswork/services/data_sync_service.dart';

/// Widget indicateur de synchronisation des données
class DataSyncIndicator extends StatefulWidget {
  final Widget child;
  final bool showSyncStatus;

  const DataSyncIndicator({
    super.key,
    required this.child,
    this.showSyncStatus = true,
  });

  @override
  State<DataSyncIndicator> createState() => _DataSyncIndicatorState();
}

class _DataSyncIndicatorState extends State<DataSyncIndicator> {
  final DataSyncService _syncService = DataSyncService();
  DateTime? _lastSync;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSyncStatus();
  }

  Future<void> _loadSyncStatus() async {
    final lastSync = await _syncService.getLastSyncTime();
    if (mounted) {
      setState(() => _lastSync = lastSync);
    }
  }

  Future<void> _forceSync() async {
    setState(() => _isLoading = true);
    
    try {
      await _syncService.forceSyncAll();
      await _loadSyncStatus();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Données synchronisées avec succès'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Erreur de synchronisation: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatSyncTime(DateTime? dateTime) {
    if (dateTime == null) return 'Jamais';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'À l\'instant';
    } else if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        
        // Indicateur de synchronisation
        if (widget.showSyncStatus)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoading ? null : _forceSync,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isLoading)
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        else
                          const Icon(
                            Icons.sync,
                            size: 12,
                            color: Colors.white,
                          ),
                        const SizedBox(width: 6),
                        Text(
                          _formatSyncTime(_lastSync),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Widget pour afficher les statistiques de synchronisation
class SyncStatsWidget extends StatefulWidget {
  const SyncStatsWidget({super.key});

  @override
  State<SyncStatsWidget> createState() => _SyncStatsWidgetState();
}

class _SyncStatsWidgetState extends State<SyncStatsWidget> {
  final DataSyncService _syncService = DataSyncService();
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _syncService.getSyncStats();
    if (mounted) {
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_stats == null) {
      return const Center(child: Text('Aucune donnée disponible'));
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sync, color: Color(0xFF4A90E2)),
                const SizedBox(width: 12),
                Text(
                  'Synchronisation des données',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildStatRow('Groupes', _stats!['groupsCount']),
            _buildStatRow('Projets', _stats!['projectsCount']),
            _buildStatRow('Utilisateurs', _stats!['usersCount']),
            
            const SizedBox(height: 12),
            
            if (_stats!['lastSync'] != null)
              Text(
                'Dernière sync: ${DateTime.parse(_stats!['lastSync']).toLocal().toString().split('.')[0]}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toString(),
              style: const TextStyle(
                color: Color(0xFF4A90E2),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}