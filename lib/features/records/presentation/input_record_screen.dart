import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sdd_health_record/features/records/models/health_record.dart';
import 'package:sdd_health_record/features/records/repository/health_record_repository.dart';

part 'input_record_screen.g.dart';

@riverpod
class InputRecordController extends _$InputRecordController {
  @override
  FutureOr<void> build() {}

  Future<void> submit({
    required DateTime date,
    double? weight,
    double? temperature,
    double? waist,
    int? steps,
    String? exerciseNote,
    String? diaryNote,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(healthRecordRepositoryProvider.future);
      final record = HealthRecord()
        ..date = date
        ..weight = weight
        ..temperature = temperature
        ..waistCircumference = waist
        ..steps = steps
        ..exerciseNote = exerciseNote
        ..diaryNote = diaryNote
        ..createdAt = DateTime.now();
      await repository.saveRecord(record);
    });
  }
}

class InputRecordScreen extends ConsumerStatefulWidget {
  const InputRecordScreen({super.key});

  @override
  ConsumerState<InputRecordScreen> createState() => _InputRecordScreenState();
}

class _InputRecordScreenState extends ConsumerState<InputRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _selectedDate;
  final _weightController = TextEditingController();
  final _tempController = TextEditingController();
  final _waistController = TextEditingController();
  final _stepsController = TextEditingController();
  final _exerciseController = TextEditingController();
  final _diaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _tempController.dispose();
    _waistController.dispose();
    _stepsController.dispose();
    _exerciseController.dispose();
    _diaryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (time != null) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inputRecordControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Daily Record'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDateCard(context),
              const SizedBox(height: 16),
              _buildSectionTitle('Body Measurements'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberInput(
                      controller: _weightController,
                      label: 'Weight',
                      suffix: 'kg',
                      icon: Icons.monitor_weight_outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildNumberInput(
                      controller: _tempController,
                      label: 'Temp',
                      suffix: '°C',
                      icon: Icons.thermostat_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberInput(
                      controller: _waistController,
                      label: 'Waist',
                      suffix: 'cm',
                      icon: Icons.straighten_outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildNumberInput(
                      controller: _stepsController,
                      label: 'Steps',
                      icon: Icons.directions_walk_outlined,
                      isInt: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Notes'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _exerciseController,
                decoration: const InputDecoration(
                  labelText: 'Exercise',
                  hintText: 'Running, Gym, etc.',
                  prefixIcon: Icon(Icons.fitness_center),
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diaryController,
                decoration: const InputDecoration(
                  labelText: 'Diary / Comments',
                  hintText: 'How was your day?',
                  prefixIcon: Icon(Icons.book),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          await ref
                              .read(inputRecordControllerProvider.notifier)
                              .submit(
                                date: _selectedDate,
                                weight: double.tryParse(_weightController.text),
                                temperature: double.tryParse(
                                  _tempController.text,
                                ),
                                waist: double.tryParse(_waistController.text),
                                steps: int.tryParse(_stepsController.text),
                                exerciseNote: _exerciseController.text,
                                diaryNote: _diaryController.text,
                              );
                          if (context.mounted &&
                              !ref
                                  .read(inputRecordControllerProvider)
                                  .hasError) {
                            context.pop();
                          }
                        }
                      },
                icon: state.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: const Text(
                  'Save Record',
                  style: TextStyle(fontSize: 16),
                ),
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

  Widget _buildDateCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: ListTile(
        leading: const Icon(Icons.calendar_today),
        title: Text(
          '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${_selectedDate.hour}:${_selectedDate.minute.toString().padLeft(2, '0')}',
        ),
        trailing: Tooltip(
          message: 'Change Date/Time',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_calendar),
                onPressed: () => _selectDate(context),
              ),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: () => _selectTime(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNumberInput({
    required TextEditingController controller,
    required String label,
    String? suffix,
    required IconData icon,
    bool isInt = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        prefixIcon: Icon(icon, size: 20),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: !isInt),
    );
  }
}
