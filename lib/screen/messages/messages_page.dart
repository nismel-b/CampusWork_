import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:campuswork/auth/auth_service.dart';
import 'package:campuswork/model/user.dart';


class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });
}

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  String? _selectedUserId;
  List<User> _availableUsers = [];

  // Clé globale pour accéder aux méthodes depuis l'extérieur
  static final GlobalKey<_MessagesPageState> _messagesPageKey = GlobalKey<_MessagesPageState>();

  // Méthode statique pour afficher le dialog depuis MainNavigation
  static void showNewMessageDialog(BuildContext context) {
    final state = _messagesPageKey.currentState;
    if (state != null) {
      state._showNewMessageDialog();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    // Simuler le chargement des utilisateurs disponibles
    // En réalité, cela viendrait d'un service
    setState(() {
      _availableUsers = [
        User(
          userId: 'user1',
          username: 'admin',
          firstName: 'Admin',
          lastName: 'System',
          email: 'admin@campuswork.com',
          phonenumber: '',
          password: '',
          userRole: UserRole.admin,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        User(
          userId: 'user2',
          username: 'lecturer',
          firstName: 'Prof',
          lastName: 'Enseignant',
          email: 'lecturer@campuswork.com',
          phonenumber: '',
          password: '',
          userRole: UserRole.lecturer,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        User(
          userId: 'user3',
          username: 'student',
          firstName: 'Étudiant',
          lastName: 'Test',
          email: 'student@campuswork.com',
          phonenumber: '',
          password: '',
          userRole: UserRole.student,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    });
  }

  Future<void> _loadMessages() async {
    // Simuler le chargement des messages
    final currentUser = AuthService().currentUser;
    if (currentUser == null) return;

    setState(() {
      _messages.addAll([
        Message(
          id: '1',
          senderId: 'user1',
          senderName: 'Admin System',
          receiverId: currentUser.userId,
          content: 'Bienvenue sur CampusWork ! N\'hésitez pas à explorer toutes les fonctionnalités.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: false,
        ),
        Message(
          id: '2',
          senderId: currentUser.userId,
          senderName: '${currentUser.firstName} ${currentUser.lastName}',
          receiverId: 'user1',
          content: 'Merci pour l\'accueil ! L\'application est très bien conçue.',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: true,
        ),
      ]);
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _selectedUserId == null) return;

    final currentUser = AuthService().currentUser;
    if (currentUser == null) return;

    final selectedUser = _availableUsers.firstWhere((u) => u.userId == _selectedUserId);

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: currentUser.userId,
      senderName: '${currentUser.firstName} ${currentUser.lastName}',
      receiverId: _selectedUserId!,
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
      isRead: false,
    );

    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });

    // Simuler une réponse automatique
    Future.delayed(const Duration(seconds: 2), () {
      final response = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _selectedUserId!,
        senderName: '${selectedUser.firstName} ${selectedUser.lastName}',
        receiverId: currentUser.userId,
        content: 'Merci pour votre message ! Je vous répondrai bientôt.',
        timestamp: DateTime.now(),
        isRead: false,
      );

      if (mounted) {
        setState(() {
          _messages.add(response);
        });
      }
    });
  }

  void _showNewMessageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedUserId,
              decoration: const InputDecoration(
                labelText: 'Destinataire',
                border: OutlineInputBorder(),
              ),
              items: _availableUsers.map((user) {
                return DropdownMenuItem<String>(
                  value: user.userId,
                  child: Text('${user.firstName} ${user.lastName} (${user.userRole.toString().split('.').last})'),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedUserId = value),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              _sendMessage();
              Navigator.pop(context);
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService().currentUser;
    if (currentUser == null) {
      return const Center(child: Text('Utilisateur non connecté'));
    }

    final userMessages = _messages.where((m) => 
      m.senderId == currentUser.userId || m.receiverId == currentUser.userId
    ).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return userMessages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun message',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Commencez une conversation',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _showNewMessageDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Nouveau message'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userMessages.length,
              itemBuilder: (context, index) {
                final message = userMessages[index];
                final isFromCurrentUser = message.senderId == currentUser.userId;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: isFromCurrentUser 
                        ? MainAxisAlignment.end 
                        : MainAxisAlignment.start,
                    children: [
                      if (!isFromCurrentUser) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            message.senderName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isFromCurrentUser
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isFromCurrentUser)
                                Text(
                                  message.senderName,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              if (!isFromCurrentUser) const SizedBox(height: 4),
                              Text(
                                message.content,
                                style: TextStyle(
                                  color: isFromCurrentUser ? Colors.white : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTimestamp(message.timestamp),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isFromCurrentUser 
                                      ? Colors.white.withOpacity(0.7)
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isFromCurrentUser) ...[
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            currentUser.firstName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}j';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min';
    } else {
      return 'maintenant';
    }
  }
}