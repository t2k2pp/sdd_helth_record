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
      appBar: AppBar(title: const Text('Add Record')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: ListTile(
                  title: Text(
                    'Date: ${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day} ${_selectedDate.hour}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tempController,
                decoration: const InputDecoration(
                  labelText: 'Temperature (°C)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _waistController,
                decoration: const InputDecoration(
                  labelText: 'Waist (cm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: 'Steps',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _exerciseController,
                decoration: const InputDecoration(
                  labelText: 'Exercise Note',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diaryController,
                decoration: const InputDecoration(
                  labelText: 'Diary Note',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              FilledButton(
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
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
