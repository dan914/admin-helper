import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/steps.dart';
import '../providers/wizard_provider.dart';
import '../widgets/answer_card.dart';
import '../widgets/app_button.dart';
import '../ui/design_tokens.dart';

class SummaryScreen extends ConsumerWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wizardState = ref.watch(wizardProvider);
    final answers = wizardState.answers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('입력 내용 확인'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(DesignTokens.spacingBase),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '입력하신 내용을 확인해주세요',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: DesignTokens.spacingBase),
                  Text(
                    '수정이 필요한 항목은 수정 버튼을 눌러주세요',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: DesignTokens.spacingSection),
                  ..._buildAnswerCards(context, ref, answers),
                  // Add extra space at the bottom to ensure scrolling works
                  SizedBox(height: DesignTokens.spacingSection * 2),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(DesignTokens.spacingBase),
            decoration: BoxDecoration(
              color: DesignTokens.bgAlt,
              border: Border(
                top: BorderSide(color: DesignTokens.border),
              ),
            ),
            child: AppButton(
              label: '연락처 입력하기',
              onPressed: () => context.go('/contact'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnswerCards(BuildContext context, WidgetRef ref, Map<String, dynamic> answers) {
    final List<Widget> cards = [];
    
    print('📋 Building answer cards from answers: $answers');
    
    // Process main steps 1-10
    for (int stepId = 1; stepId <= 10; stepId++) {
      final step = WizardSteps.getStepById(stepId);
      if (step == null) continue;
      
      final stepKey = 'step_$stepId';
      final answer = answers[stepKey];
      
      if (answer != null) {
        final answerText = _getOptionLabel(step.options, answer);
        
        cards.add(
          Padding(
            padding: EdgeInsets.only(bottom: DesignTokens.spacingBase),
            child: AnswerCard(
              stepNumber: stepId.toString(),
              question: step.title,
              answer: answerText,
              onEdit: () {
                ref.read(wizardProvider.notifier).goToStep(stepId);
                context.pop();
              },
            ),
          ),
        );
        
        // Add sub-step answers for step 4
        if (stepId == 4 && step.subSteps != null) {
          final subSteps = step.subSteps![answer];
          if (subSteps != null) {
            for (int subIndex = 0; subIndex < subSteps.length; subIndex++) {
              final subStep = subSteps[subIndex];
              final subStepKey = 'step_4_${answer}_$subIndex';
              final subAnswer = answers[subStepKey];
              
              if (subAnswer != null) {
                final subAnswerText = _getOptionLabel(subStep.options, subAnswer);
                
                cards.add(
                  Padding(
                    padding: EdgeInsets.only(bottom: DesignTokens.spacingBase),
                    child: AnswerCard(
                      stepNumber: '4-${subIndex + 1}',
                      question: subStep.title,
                      answer: subAnswerText,
                      onEdit: () {
                        ref.read(wizardProvider.notifier).goToStep(stepId);
                        context.pop();
                      },
                    ),
                  ),
                );
              }
            }
          }
        }
      }
    }
    
    print('📊 Built ${cards.length} answer cards');
    return cards;
  }

  String _getOptionLabel(List<StepOption> options, String code) {
    try {
      final option = options.firstWhere((opt) => opt.code == code);
      return option.label;
    } catch (e) {
      return code; // Return the code if label not found
    }
  }
}