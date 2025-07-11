import 'package:flutter/material.dart';
import 'package:monitor_fso/repositories/database/db_defines.dart';

import '../../results_screen/result_utils.dart';

class PatientTitle extends StatefulWidget {
  const PatientTitle({
    super.key,
    required this.patient,
    required this.isLast,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  final RecordPatient patient;
  final bool isLast;
  final Function onSelect;
  final Function onEdit;
  final Function onDelete;

  @override
  State<PatientTitle> createState() => _PatientTitleState();
}

class _PatientTitleState extends State<PatientTitle> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        widget.onSelect(widget.patient);
      },
      child: _buildTitle(context, theme),
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 0,
        left: 10,
        right: 10,
      ),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  children: [
                    Text(
                      widget.patient.fio,
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                    Text(
                      '${pdt(widget.patient.born.day)}:${pdt(widget.patient.born.month)}:${pdt(widget.patient.born.year)}',
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      textScaler: const TextScaler.linear(1.0),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              /// Редактирование записи о пациенте
              GestureDetector(
                onTap: () {
                  widget.onEdit(widget.patient);
                },
//                child: Icon(Icons.close),
                child: Image.asset('lib/assets/icons/kard_file48_01.png'),
              ),
              /// Удаление записи о пациенте
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  widget.onDelete(widget.patient);
                },
                child: Image.asset('lib/assets/icons/delete48_01.png'), //Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!widget.isLast)
            const Padding(
              padding: EdgeInsets.only(left: 58),
              child: Divider(
                height: 0,
                indent: 0,
                thickness: 1,
              ),
            ),
        ],
      ),
    );
  }
}
