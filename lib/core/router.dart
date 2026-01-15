GoRoute(
  path: '/invite/confirm',
  builder: (context, state) {
    final code = state.uri.queryParameters['code']; // 取得 URL 中的 8 位碼
    return ConfirmInvitePage(inviteCode: code ?? '');
  },
),