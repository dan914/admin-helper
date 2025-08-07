import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/steps.dart';
import '../providers/wizard_provider.dart';
import '../widgets/progress_bar.dart';
import '../widgets/step_card.dart';
import '../widgets/radio_option.dart';
import '../widgets/app_button.dart';
import '../ui/design_tokens.dart';

class WizardScreen extends ConsumerStatefulWidget {
  const WizardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends ConsumerState<WizardScreen> {
  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(wizardProvider);
    final wizardNotifier = ref.read(wizardProvider.notifier);
    final currentStep = wizardNotifier.getCurrentStep();
    final currentSubStep = wizardNotifier.getCurrentSubStep();

    if (currentStep == null) {
      return const Scaffold(
        body: Center(child: Text('오류가 발생했습니다')),
      );
    }

    final stepKey = wizardNotifier.getCurrentStepKey();
    final currentAnswer = wizardState.answers[stepKey];
    final stepNumber = wizardNotifier.getCurrentStepNumber();
    final totalSteps = wizardNotifier.getTotalSteps();
    final isLastStep = wizardNotifier.isLastStep();
    
    // Use sub-step if available, otherwise main step
    final displayTitle = currentSubStep?.title ?? currentStep.title;
    final displayOptions = currentSubStep?.options ?? currentStep.options;

    return Scaffold(
      appBar: AppBar(
        title: const Text('행정도우미'),
        leading: wizardState.stepHistory.length > 1 || wizardState.isInSubStep
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => wizardNotifier.previousStep(),
              )
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(DesignTokens.spacingBase),
              child: ProgressBar(
                currentStep: stepNumber,
                totalSteps: totalSteps,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(DesignTokens.spacingBase),
                child: StepCard(
                  stepNumber: wizardState.isInSubStep 
                      ? '$stepNumber-${wizardState.currentSubStepIndex + 1}'
                      : stepNumber.toString(),
                  title: displayTitle,
                  subtitle: wizardState.isInSubStep ? '세부 선택' : '',
                  child: _buildStepContent(displayOptions, currentAnswer, stepKey),
                ),
              ),
            ),
            _buildNavigationButtons(currentAnswer, isLastStep),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(List<StepOption> options, dynamic currentAnswer, String stepKey) {
    return Column(
      children: options.map((option) {
        final isUnknown = option.code == 'UNK';
        return Padding(
          padding: EdgeInsets.only(bottom: DesignTokens.spacingBase),
          child: RadioOption<String>(
            value: option.code,
            groupValue: currentAnswer as String?,
            label: option.label,
            subtitle: '',
            isUnknown: isUnknown,
            onChanged: (value) {
              ref.read(wizardProvider.notifier).setAnswer(stepKey, value);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNavigationButtons(dynamic currentAnswer, bool isLastStep) {
    final canProceed = currentAnswer != null && currentAnswer.toString().isNotEmpty;
    final wizardNotifier = ref.read(wizardProvider.notifier);
    final stepNumber = wizardNotifier.getCurrentStepNumber();
    final totalSteps = wizardNotifier.getTotalSteps();

    return Container(
      padding: EdgeInsets.all(DesignTokens.spacingBase),
      decoration: BoxDecoration(
        color: DesignTokens.bgAlt,
        border: Border(
          top: BorderSide(color: DesignTokens.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: AppButton(
              label: isLastStep ? '완료' : '다음',
              onPressed: canProceed
                  ? () {
                      print('🎯 Button pressed - isLastStep: $isLastStep, stepNumber: $stepNumber, totalSteps: $totalSteps');
                      print('📍 Current step: $stepNumber/${totalSteps}');
                      print('📋 Current answer: $currentAnswer');
                      if (isLastStep) {
                        print('✅ This is the last step, navigating to summary');
                        context.go('/summary');
                      } else {
                        print('➡️ Not the last step, going to next step');
                        ref.read(wizardProvider.notifier).nextStep();
                      }
                    }
                  : null,
            ),
          ),
          if (stepNumber == totalSteps) ...[
            SizedBox(width: DesignTokens.spacingBase),
            TextButton(
              onPressed: () {
                print('🔧 DEBUG: Manual navigation to summary');
                context.go('/summary');
              },
              child: const Text('Debug: Summary'),
            ),
          ],
        ],
      ),
    );
  }
}