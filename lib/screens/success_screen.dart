import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_button.dart';
import '../ui/design_tokens.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(DesignTokens.spacingSection),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _opacityAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: DesignTokens.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: DesignTokens.spacingSection),
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: Column(
                    children: [
                      Text(
                        '제출이 완료되었습니다!',
                        style: Theme.of(context).textTheme.displayLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: DesignTokens.spacingBase),
                      Text(
                        '전문 행정사가 입력하신 내용을 검토하여\n빠른 시일 내에 연락드리겠습니다.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: DesignTokens.textMuted,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: DesignTokens.spacingSection * 2),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(DesignTokens.spacingSection),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: DesignTokens.primary,
                                  ),
                                  SizedBox(width: DesignTokens.spacingBase),
                                  Text(
                                    '예상 처리 시간',
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                ],
                              ),
                              SizedBox(height: DesignTokens.spacingBase),
                              _buildInfoRow(
                                Icons.access_time,
                                '평일 기준 1~2일 이내',
                              ),
                              SizedBox(height: DesignTokens.spacingBase / 2),
                              _buildInfoRow(
                                Icons.notifications_active,
                                '카카오톡 또는 SMS로 알림 발송',
                              ),
                              SizedBox(height: DesignTokens.spacingBase / 2),
                              _buildInfoRow(
                                Icons.mail_outline,
                                '상세 내용은 이메일로 전송',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingSection),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: '홈으로 돌아가기',
                          onPressed: () => context.go('/'),
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingBase),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          label: '새로운 상담 시작',
                          variant: AppButtonVariant.outline,
                          onPressed: () {
                            // Clear data and start new consultation
                            context.go('/');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: DesignTokens.textMuted,
        ),
        SizedBox(width: DesignTokens.spacingBase / 2),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DesignTokens.textMuted,
                ),
          ),
        ),
      ],
    );
  }
}