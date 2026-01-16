import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// 修正 Import 路徑
import 'package:iron_split/gen/strings.g.dart';
import 'package:iron_split/features/task/presentation/dialogs/d03_task_create_confirm_dialog.dart';

/// Page Key: S05_TaskCreate.Form
/// 職責：讓使用者輸入任務名稱，建立任務後彈出邀請視窗 (D03)。
class S05TaskCreateFormPage extends StatefulWidget {
  const S05TaskCreateFormPage({super.key});

  @override
  State<S05TaskCreateFormPage> createState() => _S05TaskCreateFormPageState();
}

class _S05TaskCreateFormPageState extends State<S05TaskCreateFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);

    final user = FirebaseAuth.instance.currentUser;
    // 理論上由 Router 擋下未登入，這裡做雙重保險
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(t.error.authRequired.message)),
        );
      }
      return;
    }

    try {
      // 1. 在 Firestore 建立真實任務
      final docRef = await FirebaseFirestore.instance.collection('tasks').add({
        'name': _nameController.text.trim(),
        'captainUid': user.uid,
        'memberCount': 1,
        'maxMembers': 10, // MVP 預設值
        'baseCurrency': 'TWD', // MVP 預設值
        'createdAt': FieldValue.serverTimestamp(),
        'members': {
          user.uid: {
            'role': 'captain',
            'displayName': user.displayName ?? 'Captain',
            'joinedAt': FieldValue.serverTimestamp(),
            'avatar': 'cow', // MVP 隊長預設頭像
            'isLinked': true,
          }
        },
        // 關鍵：activeInviteCode 留空，交給 D03 自動生成
        'activeInviteCode': null, 
      });

      if (!mounted) return;

      // 2. 建立成功後，直接彈出 D03 邀請視窗
      // barrierDismissible: false 強制使用者必須點選 D03 上的按鈕來決定下一步
      await showDialog(
        context: context,
        barrierDismissible: false, 
        builder: (ctx) => D03TaskCreateConfirmDialog(
          taskId: docRef.id,
          taskName: _nameController.text.trim(),
          inviteCode: null, // 傳入 null 以觸發 D03 呼叫後端生成新碼
        ),
      );

      // 3. D03 關閉後，導向該任務的 Dashboard
      if (mounted) {
        context.go('/tasks/${docRef.id}');
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() => _isCreating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 依據聖經 UI Block 規則使用 Material 3 元件
    return Scaffold(
      appBar: AppBar(
        title: Text(t.S05_TaskCreate_Form.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 任務名稱輸入框
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: t.S05_TaskCreate_Form.field_name_label,
                  hintText: t.S05_TaskCreate_Form.field_name_hint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.airplane_ticket_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return t.S05_TaskCreate_Form.field_name_error;
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleCreate(),
              ),
              
              const SizedBox(height: 32),

              // 建立按鈕
              FilledButton.icon(
                onPressed: _isCreating ? null : _handleCreate,
                icon: _isCreating 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check),
                label: Text(_isCreating 
                    ? t.S05_TaskCreate_Form.creating 
                    : t.S05_TaskCreate_Form.action_create),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}