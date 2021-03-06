import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouping/blocks/signup/gender_birth.dart';
import 'package:grouping/common/colors.dart';
import 'package:grouping/common/form_frame.dart';
import 'package:grouping/common/radio_button.dart';

class GenderNBirthPage extends StatefulWidget {
  @override
  _GenderNBirthPageState createState() => _GenderNBirthPageState();
}

class _GenderNBirthPageState extends State<GenderNBirthPage> {
  final _genderBirthBloc = GenderBirthBloc();

  @override
  void dispose() {
    _genderBirthBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _genderBirthBloc,
      builder: (BuildContext context, GenderBirthFormState state) {
        return FormFrame(
          content: Container(
            margin: const EdgeInsets.only(top: 40, left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: RadioButton(
                          value: Gender.Male,
                          groupValue: state.gender,
                          onChanged: _onGenderChanged,
                          child: const Text(
                            '\u{2642}', // ♂
                            style: TextStyle(
                              fontFamily: 'NotoSansCJKkr',
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: RadioButton(
                          value: Gender.Female,
                          groupValue: state.gender,
                          onChanged: _onGenderChanged,
                          child: const Text(
                            '\u{2640}', // ♀
                            style: TextStyle(
                              fontFamily: 'NotoSansCJKkr',
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FlatButton(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  onPressed: _selectBirthday,
                  child: Text(
                    state.isBirthValid
                        ? '${state.birthDay.year}.${state.birthDay.month}.${state.birthDay.day}'
                        : 'Select birthday',
                    style: TextStyle(
                      color: state.isBirthValid ? SelectedButtonText : UnselectedButtonText,
                      fontSize: 18,
                    ),
                  ),
                  color: state.isBirthValid ? SelectedButton : UnselectedButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: state.isBirthValid ? SelectedButtonBorder : UnselectedButtonBorder,
                    ),
                  ),
                )
              ],
            ),
          ),
          onSubmit: state.isValid ? _nextPage : null,
        );
      },
    );
  }

  void _nextPage() => Navigator.pushNamed(context, '/signup/validate');

  void _onGenderChanged(Gender newGender) {
    _genderBirthBloc.dispatch(GenderChanged(gender: newGender));
  }

  Future<void> _selectBirthday() async {
    final oldBirthDay = _genderBirthBloc.currentState.birthDay;

    final DateTime newBirthDay = await showDatePicker(
      context: context,
      initialDate: oldBirthDay != null ? oldBirthDay : DateTime.now(),
      firstDate: DateTime(1910),
      lastDate: DateTime.now(),
    );

    _genderBirthBloc.dispatch(BirthdayChanged(birthDay: newBirthDay));
  }
}
