import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduExpense',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'EduExpense'),
    );
  }
}

enum Gender {
  No_Transaction, Buisness_Transaction, Friendly_Transaction ,
}

enum Interest {
  Grocerry, Maintainance, Travel , Clothing , Food , Movies  , Work , Daily_expenditure , Education , Tourism
}

class SignupUser {
  String name;
  Gender transaction_type;
  DateTime date;
  List<Interest> interests;
  bool ethicsAgreement;

  SignupUser({
    this.name,
    this.transaction_type,
    this.date,
    List<Interest> interests,
    this.ethicsAgreement = false,
  }) {
    this.interests = interests ?? [];
  }
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': transaction_type.toString(),
    'birthdate': date.toString(),
    'interests': interests.toString(),
    'ethicsAgreement': ethicsAgreement,
  };
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final _formResult = SignupUser();

  final nameFocusNode = FocusNode();
  final genderFocusNodes = [FocusNode(), FocusNode(), FocusNode()];
  final birthdateFocusNodes = [FocusNode(), FocusNode(), FocusNode()];
  final interestsFocusNode = FocusNode();
  final ethicsAgreementFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
          top: false,
          bottom: false,
          child: Form(
              key: _formKey,
              autovalidate: false,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  MyTextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter name',
                      labelText: 'Name',
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(30)],
                    initialValue: _formResult.name,
                    validator: (userName) {
                      if (userName.isEmpty) {
                        return 'Name is required';
                      }
                      if (userName.length < 3) {
                        return 'Name is too short';
                      }
                      return null;
                    },
                    onSaved: (userName) {
                      _formResult.name = userName;
                    },
                    autofocus: true,
                    focusNode: nameFocusNode,
                    textInputAction: TextInputAction.next,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(nameFocusNode);
                    },
                  ),
                  SizedBox(height: 8.0),
                  MyToggleButtonsFormField<Gender>(
                    decoration: InputDecoration(
                      labelText: 'Transaction Type',
                    ),
                    initialValue: _formResult.transaction_type,
                    items: Gender.values,
                    itemBuilder: (BuildContext context, Gender genderItem) => Text(describeEnum(genderItem)),
                    selectedItemBuilder: (BuildContext context, Gender genderItem) => Text(describeEnum(genderItem)),
                    validator: (transaction_type) => transaction_type == null ? 'transaction type is required' : null,
                    onSaved: (transaction_type) {
                      _formResult.transaction_type = transaction_type;
                    },
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    focusNodes: genderFocusNodes,
                    onChanged: (transaction_type) {
                      final genderIndex = Gender.values.indexOf(transaction_type);
                      if (genderIndex >= 0) {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).requestFocus(genderFocusNodes[genderIndex]);
                      }
                    },
                  ),
                  SizedBox(height: 8.0),
                  MyDateFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                    ),
                    validator: (date) {
                      if (date == null) {
                        return 'A valid Date is required';
                      }
                      final now = DateTime.now();
                      if (date.isAfter(now)) {
                        return 'Transaction not done yet !';
                      }
                      
                      return null;
                    },
                    onSaved: (date) {
                      _formResult.date = date;
                    },
                    dayFocusNode: birthdateFocusNodes[0],
                    dayOnTap: () {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(birthdateFocusNodes[0]);
                    },
                    monthFocusNode: birthdateFocusNodes[1],
                    monthOnTap: () {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(birthdateFocusNodes[1]);
                    },
                    yearFocusNode: birthdateFocusNodes[2],
                    yearOnTap: () {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(birthdateFocusNodes[2]);
                    },
                  ),
                  SizedBox(height: 8.0),
                  MyMultiSelectionFormField<Interest>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                    ),
                    hint: Text('Select Category'),
                    isDense: true,
                    focusNode: interestsFocusNode,
                    options: Interest.values,
                    titleBuilder: (interest) => Text(describeEnum(interest)),
                    chipLabelBuilder: (interest) => Text(describeEnum(interest)),
                    initialValues: _formResult.interests,
                    validator: (interests) => interests.length < 1 ? 'Please select any one category ' : null,
                    onSaved: (interests) {
                      _formResult.interests = interests;
                    },
                    onChanged: (_) {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(interestsFocusNode);
                    },
                  ),
                  SizedBox(height: 8.0),
                  MySwitchFormField(
                    decoration: InputDecoration(
                      labelText: 'Ethics agreement',
                      hintText: null,
                    ),
                    focusNode: ethicsAgreementFocusNode,
                    initialValue: _formResult.ethicsAgreement,
                    validator: (userHasAgreedWithEthics) => userHasAgreedWithEthics == false ? 'Please agree with ethics' : null,
                    onSaved: (userHasAgreedWithEthics) {
                      _formResult.ethicsAgreement = userHasAgreedWithEthics;
                    },
                    onChanged: (_) {
                      FocusScope.of(context).unfocus();
                      FocusScope.of(context).requestFocus(ethicsAgreementFocusNode);
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _submitForm,
            tooltip: 'Save',
            child: Icon(
              Icons.check,
              size: 36.0,
            ),
          ),
    );
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      print('New data saved with form :\n');
      print(_formResult.toJson());
    }
  }
}

// formFields/mySwitchFormField.dart ********************

class MySwitchFormField extends FormField<bool> {
  MySwitchFormField({
    Key key,
    bool initialValue,
    this.decoration = const InputDecoration(),
    this.onChanged,
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
    bool autovalidate = false,
    this.constraints = const BoxConstraints(),
    Color activeColor,
    Color activeTrackColor,
    Color inactiveThumbColor,
    Color inactiveTrackColor,
    ImageProvider<dynamic> activeThumbImage,
    ImageProvider<dynamic> inactiveThumbImage,
    MaterialTapTargetSize materialTapTargetSize,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    Color focusColor,
    Color hoverColor,
    FocusNode focusNode,
    bool autofocus = false,
  }) : assert(decoration != null),
    assert(initialValue != null),
    assert(autovalidate != null),
    assert(autofocus != null),
    assert(dragStartBehavior != null),
    assert(constraints != null),
    super(
      key: key,
      onSaved: onSaved,
      initialValue: initialValue,
      validator: validator,
      autovalidate: autovalidate,
      builder: (FormFieldState<bool> field) {
        final InputDecoration effectiveDecoration = decoration.applyDefaults(
          Theme.of(field.context).inputDecorationTheme,
        );
        return InputDecorator(
          decoration: effectiveDecoration.copyWith(errorText: field.errorText),
          isEmpty: field.value == null,
          isFocused: focusNode?.hasFocus,
          child: Row(
            children: <Widget>[
              ConstrainedBox(
                  constraints: constraints,
                  child: Switch(
                    value: field.value,
                    onChanged: field.didChange,
                    activeColor: activeColor,
                    activeTrackColor: activeTrackColor,
                    inactiveThumbColor: inactiveThumbColor,
                    inactiveTrackColor: inactiveTrackColor,
                    activeThumbImage: activeThumbImage,
                    inactiveThumbImage: inactiveThumbImage,
                    materialTapTargetSize: materialTapTargetSize,
                    dragStartBehavior: dragStartBehavior,
                    focusColor: focusColor,
                    hoverColor: hoverColor,
                    focusNode: focusNode,
                    autofocus: autofocus,
                ),
              ),
            ],
          ),
        );
      },
    );

  final ValueChanged<bool> onChanged;
  final InputDecoration decoration;
  final BoxConstraints constraints;

  @override
  FormFieldState<bool> createState() => _MySwitchFormFieldState();
}

class _MySwitchFormFieldState extends FormFieldState<bool> {
  @override
  MySwitchFormField get widget => super.widget;

  @override
  void didChange(bool value) {
    super.didChange(value);
    if (this.hasError) {
      this.validate();
    }
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }
}

// formFields/myToggleButtonsFormField.dart ********************

class MyToggleButtonsFormField<T> extends FormField<T> {
  MyToggleButtonsFormField({
    Key key,
    this.initialValue,
    @required this.items,
    @required this.itemBuilder,
    @required this.selectedItemBuilder,
    this.decoration = const InputDecoration(),
    this.onChanged,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    bool autovalidate = false,
    TextStyle textStyle,
    BoxConstraints constraints,
    Color color,
    Color selectedColor,
    Color disabledColor,
    Color fillColor,
    Color focusColor,
    Color highlightColor,
    Color hoverColor,
    Color splashColor,
    List<FocusNode> focusNodes,
    bool renderBorder = true,
    Color borderColor,
    Color selectedBorderColor,
    Color disabledBorderColor,
    BorderRadius borderRadius,
    double borderWidth,
  }) : assert(decoration != null),
    assert(renderBorder != null),
    assert(autovalidate != null),
    assert(items != null),
    assert(itemBuilder != null),
    assert(selectedItemBuilder != null),
    assert(initialValue == null || items.contains(initialValue)),
    super(
      key: key,
      onSaved: onSaved,
      initialValue: initialValue,
      validator: validator,
      autovalidate: autovalidate,
      builder: (FormFieldState<T> field) {
        final InputDecoration effectiveDecoration = decoration.applyDefaults(
          Theme.of(field.context).inputDecorationTheme,
        );
        return InputDecorator(
          decoration: effectiveDecoration.copyWith(errorText: field.errorText),
          isFocused: focusNodes?.any((focusNode) => focusNode.hasFocus),
          child: MyToggleButtons(
            items: items,
            value: field.value,
            itemBuilder: itemBuilder,
            selectedItemBuilder: selectedItemBuilder,
            onPressed: field.didChange,
            textStyle: textStyle,
            constraints: constraints,
            color: color,
            selectedColor: selectedColor,
            disabledColor: disabledColor,
            fillColor: fillColor,
            focusColor: focusColor,
            highlightColor: highlightColor,
            hoverColor: hoverColor,
            splashColor: splashColor,
            focusNodes: focusNodes,
            renderBorder: renderBorder,
            borderColor: borderColor,
            selectedBorderColor: selectedBorderColor,
            disabledBorderColor: disabledBorderColor,
            borderRadius: borderRadius,
            borderWidth: borderWidth,
          ),
        );
      },
    );

  final List<T> items;
  final ValueChanged<T> onChanged;
  final T initialValue;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, T) selectedItemBuilder;
  final InputDecoration decoration;

  @override
  FormFieldState<T> createState() => _MyToggleButtonsFormFieldState<T>();
}

class _MyToggleButtonsFormFieldState<T> extends FormFieldState<T> {
  @override
  MyToggleButtonsFormField<T> get widget => super.widget;

  @override
  void didChange(T value) {
    super.didChange(value);
    if (this.hasError) {
      this.validate();
    }
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }
}

// formFields/myDateFormField.dart ********************

class MyDateFormField extends FormField<DateTime> {
  MyDateFormField({
    Key key,
    DateTime initialValue,
    this.dayFocusNode,
    double dayWidth = 40,
    this.monthFocusNode,
    double monthWidth = 40,
    this.yearFocusNode,
    double yearWidth = 60,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    InputDecoration decoration = const InputDecoration(),
    InputDecoration inputDecoration = const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(0)),
    Widget separator = const Text('/'),
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction,
    TextStyle style,
    StrutStyle strutStyle,
    TextDirection textDirection,
    TextAlign textAlign = TextAlign.center,
    TextAlignVertical textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions toolbarOptions,
    bool showCursor,
    bool obscureText = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    bool autovalidate = false,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int minLines,
    bool expands = false,
    int maxLength,
    this.onChanged,
    GestureTapCallback dayOnTap,
    GestureTapCallback monthOnTap,
    GestureTapCallback yearOnTap,
    VoidCallback onEditingComplete,
    FormFieldSetter<DateTime> onSaved,
    FormFieldValidator<DateTime> validator,
    bool enabled = true,
    double cursorWidth = 2.0,
    Radius cursorRadius,
    Color cursorColor,
    Brightness keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder buildCounter,
  }) : assert(initialValue == null),
       assert(textAlign != null),
       assert(separator != null),
       assert(autofocus != null),
       assert(readOnly != null),
       assert(obscureText != null),
       assert(autocorrect != null),
       assert(enableSuggestions != null),
       assert(autovalidate != null),
       assert(maxLengthEnforced != null),
       assert(scrollPadding != null),
       assert(maxLines == null || maxLines > 0),
       assert(minLines == null || minLines > 0),
       assert(
         (maxLines == null) || (minLines == null) || (maxLines >= minLines),
         'minLines can\'t be greater than maxLines',
       ),
       assert(expands != null),
       assert(
         !expands || (maxLines == null && minLines == null),
         'minLines and maxLines must be null when expands is true.',
       ),
       assert(!obscureText || maxLines == 1, 'Obscured fields cannot be multiline.'),
       assert(maxLength == null || maxLength > 0),
       assert(enableInteractiveSelection != null),
       super(
    key: key,
    initialValue: initialValue,
    onSaved: onSaved,
    validator: validator,
    autovalidate: autovalidate,
    enabled: enabled,
    builder: (FormFieldState<DateTime> field) {
      final _MyDateFormFieldState state = field;
      final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration())
        .applyDefaults(Theme.of(field.context).inputDecorationTheme);

      String toOriginalFormatString(DateTime dateTime) {
        final y = dateTime.year.toString().padLeft(4, '0');
        final m = dateTime.month.toString().padLeft(2, '0');
        final d = dateTime.day.toString().padLeft(2, '0');
        return "$y$m$d";
      }
      bool isValidDate(String input) {
        try {
          final date = DateTime.parse(input);
          final originalFormatString = toOriginalFormatString(date);
          return input == originalFormatString;
        } catch(e) {
          return false;
        }
      }

      return InputDecorator(
        decoration: effectiveDecoration.copyWith(errorText: field.errorText),
        isEmpty: false,
        isFocused: state._effectiveYearFocusNode.hasFocus || state._effectiveMonthFocusNode.hasFocus || state._effectiveDayFocusNode.hasFocus,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            SizedBox(
              width: dayWidth,
              child: TextField(
                controller: state._effectiveDayController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                decoration: inputDecoration,
                focusNode: state._effectiveDayFocusNode,
                keyboardType: TextInputType.number,
                textInputAction: textInputAction,
                style: style,
                strutStyle: strutStyle,
                textAlign: textAlign,
                textAlignVertical: textAlignVertical,
                textDirection: textDirection, 
                textCapitalization: textCapitalization,
                autofocus: autofocus,
                toolbarOptions: toolbarOptions,
                readOnly: readOnly,
                showCursor: showCursor,
                obscureText: obscureText,
                autocorrect: autocorrect,
                enableSuggestions: enableSuggestions,
                maxLengthEnforced: maxLengthEnforced,
                maxLines: maxLines,
                minLines: minLines,
                expands: expands,
                maxLength: maxLength,
                onChanged: (value) {
                  if (value.length == 2 && int.parse(value) > 0 && int.parse(value) <= 31 ) {
                    state._effectiveMonthFocusNode.requestFocus();
                  }
                  if (value != '' && state._effectiveMonthController.text != '' && state._effectiveYearController.text != '') {
                    final date = '${state._effectiveYearController.text}${state._effectiveMonthController.text}$value';
                    if (isValidDate(date)) {
                      field.didChange(
                        DateTime.utc(
                         int.parse(state._effectiveYearController.text),
                          int.parse(state._effectiveMonthController.text),
                          int.parse(value),
                        )
                      );
                    } else {
                      field.didChange(null);
                    }
                  }
                },
                onTap: dayOnTap,
                onEditingComplete: () {
                  state._effectiveMonthFocusNode.requestFocus();
                },
                enabled: enabled,
                cursorWidth: cursorWidth,
                cursorRadius: cursorRadius,
                cursorColor: cursorColor,
                scrollPadding: scrollPadding,
                keyboardAppearance: keyboardAppearance,
                enableInteractiveSelection: enableInteractiveSelection,
                buildCounter: buildCounter,
              ),
            ),
            separator,
            SizedBox(
              width: monthWidth,
              child: TextField(
                controller: state._effectiveMonthController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(2),
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                decoration: inputDecoration,
                focusNode: state._effectiveMonthFocusNode,
                keyboardType: TextInputType.number,
                textInputAction: textInputAction,
                style: style,
                strutStyle: strutStyle,
                textAlign: textAlign,
                textAlignVertical: textAlignVertical,
                textDirection: textDirection,
                textCapitalization: textCapitalization,
                autofocus: autofocus,
                toolbarOptions: toolbarOptions,
                readOnly: readOnly,
                showCursor: showCursor,
                obscureText: obscureText,
                autocorrect: autocorrect,
                enableSuggestions: enableSuggestions,
                maxLengthEnforced: maxLengthEnforced,
                maxLines: maxLines,
                minLines: minLines,
                expands: expands,
                maxLength: maxLength,
                onChanged: (value) {
                  if (value.length == 2 && int.parse(value) > 0 && int.parse(value) <= 12 ) {
                    state._effectiveYearFocusNode.requestFocus();
                  }
                  if (value != '' && state._effectiveDayController.text != '' && state._effectiveYearController.text != '') {
                    final date = '${state._effectiveYearController.text}$value${state._effectiveDayController.text}';
                    if (isValidDate(date)) {
                      field.didChange(
                        DateTime.utc(
                          int.parse(state._effectiveYearController.text),
                          int.parse(value),
                          int.parse(state._effectiveDayController.text),
                        )
                      );
                    } else {
                      field.didChange(null);
                    }
                  }
                },
                onTap: monthOnTap,
                onEditingComplete: () {
                  state._effectiveYearFocusNode.requestFocus();
                },
                enabled: enabled,
                cursorWidth: cursorWidth,
                cursorRadius: cursorRadius,
                cursorColor: cursorColor,
                scrollPadding: scrollPadding,
                keyboardAppearance: keyboardAppearance,
                enableInteractiveSelection: enableInteractiveSelection,
                buildCounter: buildCounter,
              ),
            ),
            separator,
            SizedBox(
              width: yearWidth,
              child: TextField(
                controller: state._effectiveYearController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                decoration: inputDecoration,
                focusNode: state._effectiveYearFocusNode,
                keyboardType: TextInputType.number,
                textInputAction: textInputAction,
                style: style,
                strutStyle: strutStyle,
                textAlign: textAlign,
                textAlignVertical: textAlignVertical,
                textDirection: textDirection,
                textCapitalization: textCapitalization,
                autofocus: autofocus,
                toolbarOptions: toolbarOptions,
                readOnly: readOnly,
                showCursor: showCursor,
                obscureText: obscureText,
                autocorrect: autocorrect,
                enableSuggestions: enableSuggestions,
                maxLengthEnforced: maxLengthEnforced,
                maxLines: maxLines,
                minLines: minLines,
                expands: expands,
                maxLength: maxLength,
                onChanged: (value) {
                  if (value != '' && state._effectiveDayController.text != '' && state._effectiveMonthController.text != '') {
                    final date = '$value${state._effectiveMonthController.text}${state._effectiveDayController.text}';
                    if (isValidDate(date)) {
                      field.didChange(
                        DateTime.utc(
                          int.parse(value),
                          int.parse(state._effectiveMonthController.text),
                          int.parse(state._effectiveDayController.text),
                        )
                      );
                    } else {
                      field.didChange(null);
                    }
                  }
                },
                onTap: yearOnTap,
                onEditingComplete: onEditingComplete,
                enabled: enabled,
                cursorWidth: cursorWidth,
                cursorRadius: cursorRadius,
                cursorColor: cursorColor,
                scrollPadding: scrollPadding,
                keyboardAppearance: keyboardAppearance,
                enableInteractiveSelection: enableInteractiveSelection,
                buildCounter: buildCounter,
              ),
            ),
          ]
        )
      );
    },
  );

  final ValueChanged<DateTime> onChanged;
  final FocusNode dayFocusNode;
  final FocusNode monthFocusNode;
  final FocusNode yearFocusNode;

  @override
  _MyDateFormFieldState createState() => _MyDateFormFieldState();
}

class _MyDateFormFieldState extends FormFieldState<DateTime> {
  @override
  MyDateFormField get widget => super.widget;

  TextEditingController _dayController;
  TextEditingController get _effectiveDayController => _dayController;
  TextEditingController _monthController;
  TextEditingController get _effectiveMonthController => _monthController;
  TextEditingController _yearController;
  TextEditingController get _effectiveYearController => _yearController;

  FocusNode _dayFocusNode;
  FocusNode get _effectiveDayFocusNode => widget.dayFocusNode ?? _dayFocusNode;
  FocusNode _monthFocusNode;
  FocusNode get _effectiveMonthFocusNode => widget.monthFocusNode ?? _monthFocusNode;
  FocusNode _yearFocusNode;
  FocusNode get _effectiveYearFocusNode => widget.yearFocusNode ?? _yearFocusNode;


  @override
  void initState() {
    super.initState();
    _dayController = TextEditingController(text: widget.initialValue != null ? widget.initialValue.day.toString() : '');
    _monthController = TextEditingController(text: widget.initialValue != null ? widget.initialValue.month.toString() : '');
    _yearController = TextEditingController(text: widget.initialValue != null ? widget.initialValue.year.toString() : '');

    if (widget.dayFocusNode == null) {
      _dayFocusNode = FocusNode();
    }
    if (widget.monthFocusNode == null) {
      _monthFocusNode = FocusNode();
    }
    if (widget.yearFocusNode == null) {
      _yearFocusNode = FocusNode();
    }
  }

  @override
  void didChange(DateTime value) {
    super.didChange(value);
    if (this.hasError) {
      this.validate();
    }
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveDayController.text = widget.initialValue != null ? widget.initialValue.day.toString() : null;
      _effectiveMonthController.text = widget.initialValue != null ? widget.initialValue.month.toString() : null;
      _effectiveYearController.text = widget.initialValue != null ? widget.initialValue.year.toString() : null;
    });
  }
}

// formFields/myMultiselectionFormField.dart ********************

class MyMultiSelectionFormField<T> extends FormField<List<T>> {
  MyMultiSelectionFormField({
    Key key,
    @required List<T> initialValues,
    @required List<T> options,
    @required Widget Function(T) titleBuilder,
    Widget Function(T) subtitleBuilder,
    Widget Function(T) secondaryBuilder,
    @required Widget Function(T) chipLabelBuilder,
    Widget Function(T) chipAvatarBuilder,
    Widget hint,
    this.decoration = const InputDecoration(),
    this.onChanged,
    FormFieldSetter<List<T>> onSaved,
    FormFieldValidator<List<T>> validator,
    bool autovalidate = false,
    Widget disabledHint,
    int elevation = 8,
    TextStyle style,
    TextStyle chipLabelStyle,
    Widget underline,
    Widget icon,
    Color iconDisabledColor,
    Color iconEnabledColor,
    Color activeColor,
    Color checkColor,
    double iconSize = 24.0,
    bool isDense = false,
    bool isExpanded = false,
    double itemHeight,
    bool autofocus = false,
    FocusNode focusNode,
    Color focusColor,
    bool isItemdense,
    bool isItemThreeLine = false,
    String deleteButtonTooltipMessage,
    double chipListSpacing = 8.0,
    WrapAlignment chipListAlignment = WrapAlignment.start,
    EdgeInsetsGeometry chipLabelPadding,
    EdgeInsetsGeometry chipPadding,
    Widget chipDeleteIcon,
    Color chipDeleteIconColor,
    ShapeBorder chipShape,
    Clip chipClipBehavior = Clip.none,
    Color chipBackgroundColor,
    Color chipShadowColor,
    MaterialTapTargetSize chipMaterialTapTargetSize,
    double chipElevation,
  }) : assert(options == null || options.isEmpty || initialValues == null ||
      initialValues.every(
        (value) => options.where((T option) {
          return option == value;
        }).length == 1),
        'There should be exactly one item with [DropdownButton]\'s value: '
        '$initialValues. \n'
        'Either zero or 2 or more [DropdownMenuItem]s were detected '
        'with the same value',
      ),
      assert(decoration != null),
      assert(elevation != null),
      assert(iconSize != null),
      assert(isDense != null),
      assert(isExpanded != null),
      assert(itemHeight == null || itemHeight > 0),
      assert(autofocus != null),
      assert(isItemThreeLine != null),
      assert(chipListSpacing != null),
      assert(chipListAlignment != null),
      assert(chipClipBehavior != null),
      super(
        key: key,
        onSaved: onSaved,
        initialValue: initialValues,
        validator: validator,
        autovalidate: autovalidate,
        builder: (FormFieldState<List<T>> field) {
          final InputDecoration effectiveDecoration = decoration.applyDefaults(
            Theme.of(field.context).inputDecorationTheme,
          );
          return InputDecorator(
            decoration: effectiveDecoration.copyWith(errorText: field.errorText),
            isEmpty: field.value.isEmpty,
            isFocused: focusNode?.hasFocus,
            child: MyMultiSelectionField<T>(
              values: field.value,
              options: options,
              titleBuilder: titleBuilder,
              subtitleBuilder: subtitleBuilder,
              secondaryBuilder: secondaryBuilder,
              chipLabelBuilder: chipLabelBuilder,
              chipAvatarBuilder: chipAvatarBuilder,
              hint: field.value.isNotEmpty ? hint : null,
              onChanged: field.didChange,
              disabledHint: disabledHint,
              elevation: elevation,
              style: style,
              chipLabelStyle: chipLabelStyle,
              underline: underline,
              icon: icon,
              iconDisabledColor: iconDisabledColor,
              iconEnabledColor: iconEnabledColor,
              activeColor: activeColor,
              checkColor: checkColor,
              iconSize: iconSize,
              isDense: isDense,
              isExpanded: isExpanded,
              itemHeight: itemHeight,
              focusNode: focusNode,
              focusColor: focusColor,
              autofocus: autofocus,
              isItemdense: isItemdense,
              isItemThreeLine: isItemThreeLine,
              deleteButtonTooltipMessage: deleteButtonTooltipMessage,
              chipListSpacing: chipListSpacing,
              chipListAlignment: chipListAlignment,
              chipLabelPadding: chipLabelPadding,
              chipPadding: chipPadding,
              chipDeleteIcon: chipDeleteIcon,
              chipDeleteIconColor: chipDeleteIconColor,
              chipShape: chipShape,
              chipClipBehavior: chipClipBehavior,
              chipBackgroundColor: chipBackgroundColor,
              chipShadowColor: chipShadowColor,
              chipMaterialTapTargetSize: chipMaterialTapTargetSize,
              chipElevation: chipElevation,
            ),
           );
         },
       );

  final ValueChanged<List<T>> onChanged;

  final InputDecoration decoration;

  @override
  FormFieldState<List<T>> createState() => _MyMultiSelectionFormFieldState<T>();
}

class _MyMultiSelectionFormFieldState<T> extends FormFieldState<List<T>> {
  @override
  MyMultiSelectionFormField<T> get widget => super.widget;

  @override
  void didChange(List<T> values) {
    super.didChange(values);
    if (this.hasError) {
      this.validate();
    }
    if (widget.onChanged != null) {
      widget.onChanged(values);
    }
  }
}

// fields/myMultiselectionField.dart ************************

class MyMultiSelectionField<T> extends StatelessWidget {
  MyMultiSelectionField({
    Key key,
    this.values,
    @required this.options,
    this.titleBuilder,
    this.subtitleBuilder,
    this.secondaryBuilder,
    @required this.chipLabelBuilder,
    this.chipAvatarBuilder,
    this.hint,
    @required this.onChanged,
    this.disabledHint,
    this.elevation = 8,
    this.style,
    this.chipLabelStyle,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.activeColor,
    this.checkColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.isExpanded = false,
    this.itemHeight,
    this.autofocus = false,
    this.focusNode,
    this.focusColor,
    this.isItemdense,
    this.isItemThreeLine = false,
    this.deleteButtonTooltipMessage,
    this.chipListSpacing = 8.0,
    this.chipListAlignment = WrapAlignment.start,
    this.chipLabelPadding,
    this.chipPadding,
    this.chipDeleteIcon,
    this.chipDeleteIconColor,
    this.chipShape,
    this.chipClipBehavior = Clip.none,
    this.chipBackgroundColor,
    this.chipShadowColor,
    this.chipMaterialTapTargetSize,
    this.chipElevation,
  }): assert(options == null || options.isEmpty || values == null ||
      values.every(
        (value) => options.where((T option) {
          return option == value;
        }).length == 1
      )
    ),
    assert(chipLabelBuilder != null),
    assert(onChanged != null),
    assert(iconSize != null),
    assert(isDense != null),
    assert(isExpanded != null),
    assert(autofocus != null),
    assert(isItemThreeLine != null),
    assert(chipListSpacing != null),
    assert(chipListAlignment != null),
    assert(chipClipBehavior != null),
    super(key: key);

  final ValueChanged<List<T>> onChanged;
  final List<T> values;
  final List<T> options;
  final Widget hint;
  final Widget disabledHint;
  final Widget Function(T) titleBuilder;
  final Widget Function(T) subtitleBuilder;
  final Widget Function(T) secondaryBuilder;
  final Widget Function(T) chipLabelBuilder;
  final Widget Function(T) chipAvatarBuilder;
  final int elevation;
  final TextStyle style;
  final TextStyle chipLabelStyle;
  final Widget underline;
  final Widget icon;
  final Color iconDisabledColor;
  final Color iconEnabledColor;
  final Color activeColor;
  final Color checkColor;
  final double iconSize;
  final bool isDense;
  final bool isExpanded;
  final double itemHeight;
  final Color focusColor;
  final FocusNode focusNode;
  final bool autofocus;
  final bool isItemThreeLine;
  final bool isItemdense;
  final String deleteButtonTooltipMessage;
  final double chipListSpacing;
  final WrapAlignment chipListAlignment;
  final EdgeInsetsGeometry chipLabelPadding;
  final EdgeInsetsGeometry chipPadding;
  final Widget chipDeleteIcon;
  final Color chipDeleteIconColor;
  final ShapeBorder chipShape;
  final Clip chipClipBehavior;
  final Color chipBackgroundColor;
  final Color chipShadowColor;
  final MaterialTapTargetSize chipMaterialTapTargetSize;
  final double chipElevation;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: null,
            items: options.map<DropdownMenuItem<T>>(
                  (T option) => DropdownMenuItem<T>(
                    value: option,
                    child: MyCheckboxListTile<T>(
                      selected: values.contains(option),
                      title: titleBuilder(option),
                      subtitle: subtitleBuilder != null ? subtitleBuilder(option) : null,
                      secondary: secondaryBuilder != null ? secondaryBuilder(option) : null,
                      isThreeLine: isItemThreeLine,
                      dense: isItemdense,
                      activeColor: activeColor,
                      checkColor: checkColor,
                      onChanged: (_) {
                        if (!values.contains(option)) {
                          values.add(option);
                        } else {
                          values.remove(option);
                        }
                        onChanged(values);
                      },
                    ),
                  ),
                )
                .toList(),
            selectedItemBuilder: (BuildContext context) {
              return options.map<Widget>((T option) {
                return Text('');
              }).toList();
            },
            hint: hint,
            onChanged: onChanged == null ? null : (T value) {},
            disabledHint: disabledHint,
            elevation: elevation,
            style: style,
            underline: underline,
            icon: icon,
            iconDisabledColor: iconDisabledColor,
            iconEnabledColor: iconEnabledColor,
            iconSize: iconSize,
            isDense: isDense,
            isExpanded: isExpanded,
            itemHeight: itemHeight,
            focusNode: focusNode,
            focusColor: focusColor,
            autofocus: autofocus,
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: MyChipList<T>(
                values: values,
                spacing: chipListSpacing,
                alignment: chipListAlignment,
                chipBuilder: (T value) {
                  return Chip(
                      label: chipLabelBuilder(value),
                      labelStyle: chipLabelStyle,
                      labelPadding: chipLabelPadding,
                      avatar: chipAvatarBuilder != null ? chipAvatarBuilder(value) : null,
                      onDeleted: () {
                        values.remove(value);
                        onChanged(values);
                      },
                      deleteIcon: chipDeleteIcon,
                      deleteIconColor: chipDeleteIconColor,
                      deleteButtonTooltipMessage: deleteButtonTooltipMessage,
                      shape: chipShape,
                      clipBehavior: chipClipBehavior,
                      backgroundColor: chipBackgroundColor,
                      padding: chipPadding,
                      materialTapTargetSize: chipMaterialTapTargetSize,
                      elevation: chipElevation,
                      shadowColor: chipShadowColor,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MyCheckboxListTile<T> extends StatefulWidget {
  MyCheckboxListTile({
    Key key,
    @required this.title,
    this.subtitle,
    @required this.onChanged,
    @required this.selected,
    this.activeColor,
    this.checkColor,
    this.dense,
    this.isThreeLine = false,
    this.secondary
  }):
    assert(title != null),
    assert(onChanged != null),
    assert(selected != null),
    super(key: key);

  final Widget title;
  final Widget subtitle;
  final dynamic onChanged;
  final bool selected;
  final Color activeColor;
  final Color checkColor;
  final bool isThreeLine;
  final bool dense;
  final Widget secondary;

  @override
  _MyCheckboxListTileState<T> createState() => _MyCheckboxListTileState<T>();
}

class _MyCheckboxListTileState<T> extends State<MyCheckboxListTile<T>> {
  _MyCheckboxListTileState();

  bool _checked;

  @override
  void initState(){
    _checked = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: _checked,
      selected: _checked,
      title: widget.title,
      subtitle: widget.subtitle,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) {
        widget.onChanged(checked);
        setState((){
          _checked = checked;
        });
      },
      activeColor: widget.activeColor,
      checkColor: widget.checkColor,
      isThreeLine: widget.isThreeLine,
      dense: widget.dense,
      secondary: widget.secondary,
    );
  }
}

class MyChipList<T> extends StatelessWidget {
  const MyChipList({
    @required this.values,
    @required this.chipBuilder,
    this.spacing = 8.0,
    this.alignment = WrapAlignment.start,
  });

  final List<T> values;
  final Chip Function(T) chipBuilder;
  final double spacing;
  final WrapAlignment alignment;

  List<Widget> _buildChipList() {
    final List<Widget> items = [];
    for (T value in values) {
      items.add(chipBuilder(value));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      alignment: alignment,
      children: _buildChipList(),
    );
  }
}

// widgets/myToggleButtons.dart ********************

class MyToggleButtons<T> extends StatelessWidget {
  MyToggleButtons({
    Key key,
    @required this.items,
    @required this.itemBuilder,
    @required this.selectedItemBuilder,
    this.value,
    this.onPressed,
    this.textStyle,
    this.constraints,
    this.color,
    this.selectedColor,
    this.disabledColor,
    this.fillColor,
    this.focusColor,
    this.highlightColor,
    this.hoverColor,
    this.splashColor,
    this.focusNodes,
    this.renderBorder = true,
    this.borderColor,
    this.selectedBorderColor,
    this.disabledBorderColor,
    this.borderRadius,
    this.borderWidth,
  }): 
    assert(renderBorder != null),
    assert(items != null),
    assert(itemBuilder != null),
    assert(selectedItemBuilder != null),
    assert(value == null || items.contains(value)),
    super(key: key);

  static const double _defaultBorderWidth = 1.0;

  final List<T> items;
  final T value;
  final Widget Function(BuildContext, T) itemBuilder;
  final Widget Function(BuildContext, T) selectedItemBuilder;
  final ValueChanged<T> onPressed;
  final TextStyle textStyle;
  final BoxConstraints constraints;
  final Color color;
  final Color selectedColor;
  final Color disabledColor;
  final Color fillColor;
  final Color focusColor;
  final Color highlightColor;
  final Color splashColor;
  final Color hoverColor;
  final List<FocusNode> focusNodes;
  final bool renderBorder;
  final Color borderColor;
  final Color selectedBorderColor;
  final Color disabledBorderColor;
  final double borderWidth;
  final BorderRadius borderRadius;

  bool _isFirstIndex(int index, int length, TextDirection textDirection) {
    return index == 0 && textDirection == TextDirection.ltr
        || index == length - 1 && textDirection == TextDirection.rtl;
  }

  bool _isLastIndex(int index, int length, TextDirection textDirection) {
    return index == length - 1 && textDirection == TextDirection.ltr
        || index == 0 && textDirection == TextDirection.rtl;
  }

  bool _isSelected(int index) {
    return items[index] == value;
  }

  BorderRadius _getEdgeBorderRadius(
    int index,
    int length,
    TextDirection textDirection,
    ToggleButtonsThemeData toggleButtonsTheme,
  ) {
    final BorderRadius resultingBorderRadius = borderRadius
      ?? toggleButtonsTheme.borderRadius
      ?? BorderRadius.zero;

    if (_isFirstIndex(index, length, textDirection)) {
      return BorderRadius.only(
        topLeft: resultingBorderRadius.topLeft,
        bottomLeft: resultingBorderRadius.bottomLeft,
      );
    } else if (_isLastIndex(index, length, textDirection)) {
      return BorderRadius.only(
        topRight: resultingBorderRadius.topRight,
        bottomRight: resultingBorderRadius.bottomRight,
      );
    }
    return BorderRadius.zero;
  }

  BorderRadius _getClipBorderRadius(
    int index,
    int length,
    TextDirection textDirection,
    ToggleButtonsThemeData toggleButtonsTheme,
  ) {
    final BorderRadius resultingBorderRadius = borderRadius
      ?? toggleButtonsTheme.borderRadius
      ?? BorderRadius.zero;
    final double resultingBorderWidth = borderWidth
      ?? toggleButtonsTheme.borderWidth
      ?? _defaultBorderWidth;

    if (_isFirstIndex(index, length, textDirection)) {
      return BorderRadius.only(
        topLeft: resultingBorderRadius.topLeft - Radius.circular(resultingBorderWidth / 2.0),
        bottomLeft: resultingBorderRadius.bottomLeft - Radius.circular(resultingBorderWidth / 2.0),
      );
    } else if (_isLastIndex(index, length, textDirection)) {
      return BorderRadius.only(
        topRight: resultingBorderRadius.topRight - Radius.circular(resultingBorderWidth / 2.0),
        bottomRight: resultingBorderRadius.bottomRight - Radius.circular(resultingBorderWidth / 2.0),
      );
    }
    return BorderRadius.zero;
  }

  BorderSide _getLeadingBorderSide(
    int index,
    ThemeData theme,
    ToggleButtonsThemeData toggleButtonsTheme,
  ) {
    if (!renderBorder)
      return BorderSide.none;

    final double resultingBorderWidth = borderWidth
      ?? toggleButtonsTheme.borderWidth
      ?? _defaultBorderWidth;
    if (onPressed != null && (_isSelected(index) || (index != 0 && _isSelected(index - 1)))) {
      return BorderSide(
        color: selectedBorderColor
          ?? toggleButtonsTheme.selectedBorderColor
          ?? theme.colorScheme.onSurface.withOpacity(0.12),
        width: resultingBorderWidth,
      );
    } else if (onPressed != null && !_isSelected(index)) {
      return BorderSide(
        color: borderColor
          ?? toggleButtonsTheme.borderColor
          ?? theme.colorScheme.onSurface.withOpacity(0.12),
        width: resultingBorderWidth,
      );
    } else {
      return BorderSide(
        color: disabledBorderColor
          ?? toggleButtonsTheme.disabledBorderColor
          ?? theme.colorScheme.onSurface.withOpacity(0.12),
        width: resultingBorderWidth,
      );
    }
  }

  BorderSide _getHorizontalBorderSide(
    int index,
    ThemeData theme,
    ToggleButtonsThemeData toggleButtonsTheme,
  ) {
    if (!renderBorder)
      return BorderSide.none;

    final double resultingBorderWidth = borderWidth
      ?? toggleButtonsTheme.borderWidth
      ?? _defaultBorderWidth;
    if (onPressed != null && _isSelected(index)) {
      return BorderSide(
        color: selectedBorderColor
          ?? toggleButtonsTheme.selectedBorderColor
          ?? theme.colorScheme.onSurface.withOpacity(0.12),
        width: resultingBorderWidth,
      );
    } else if (onPressed != null && !_isSelected(index)) {
      return BorderSide(
        color: borderColor
          ?? toggleButtonsTheme.borderColor
          ?? theme.colorScheme.onSurface.withOpacity(0.12),
        width: resultingBorderWidth,
      );
    } else {
      return BorderSide(
        color: disabledBorderColor
          ?? toggleButtonsTheme.disabledBorderColor
          ?? theme.colorScheme.onSurface.withOpacity(0.12),
        width: resultingBorderWidth,
      );
    }
  }

  BorderSide _getTrailingBorderSide(
    int index,
    ThemeData theme,
    ToggleButtonsThemeData toggleButtonsTheme,
  ) {
    if (!renderBorder)
      return BorderSide.none;

    if (index != items.length - 1)
      return null;

    final double resultingBorderWidth = borderWidth
      ?? toggleButtonsTheme.borderWidth
      ?? _defaultBorderWidth;
    if (onPressed != null && (_isSelected(index))) {
      return BorderSide(
        color: selectedBorderColor
          ?? toggleButtonsTheme.selectedBorderColor
          ?? theme.colorScheme.onSurface.withOpacity(0.12),
        width: resultingBorderWidth,
      );
    } else if (onPressed != null && !_isSelected(index)) {
      return BorderSide(
        color: borderColor
          ?? toggleButtonsTheme.borderColor
          ?? theme.colorScheme.onSurface.withOpacity(0.12),
        width: resultingBorderWidth,
      );
    } else {
      return BorderSide(
        color: disabledBorderColor
          ?? toggleButtonsTheme.disabledBorderColor
          ?? theme.colorScheme.onSurface.withOpacity(0.12),
        width: resultingBorderWidth,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(
      value == null || items.contains(value),
      'Selected value should be null or part of the item options'
    );

    final ThemeData theme = Theme.of(context);
    final ToggleButtonsThemeData toggleButtonsTheme = ToggleButtonsTheme.of(context);
    final TextDirection textDirection = Directionality.of(context);

    return Row(
      children: items
        .asMap()
        .map((int itemIndex, T item) {

          final BorderRadius edgeBorderRadius = _getEdgeBorderRadius(itemIndex, items.length, textDirection, toggleButtonsTheme);
          final BorderRadius clipBorderRadius = _getClipBorderRadius(itemIndex, items.length, textDirection, toggleButtonsTheme);

          final BorderSide leadingBorderSide = _getLeadingBorderSide(itemIndex, theme, toggleButtonsTheme);
          final BorderSide horizontalBorderSide = _getHorizontalBorderSide(itemIndex, theme, toggleButtonsTheme);
          final BorderSide trailingBorderSide = _getTrailingBorderSide(itemIndex, theme, toggleButtonsTheme);

          return MapEntry(
            itemIndex,
            Expanded(
              child: _MyToggleButton(
                selected: _isSelected(itemIndex),
                textStyle: textStyle,
                constraints: constraints,
                color: color,
                selectedColor: selectedColor,
                disabledColor: disabledColor,
                fillColor: fillColor ?? toggleButtonsTheme.fillColor,
                focusColor: focusColor ?? toggleButtonsTheme.focusColor,
                highlightColor: highlightColor ?? toggleButtonsTheme.highlightColor,
                hoverColor: hoverColor ?? toggleButtonsTheme.hoverColor,
                splashColor: splashColor ?? toggleButtonsTheme.splashColor,
                focusNode: focusNodes != null ? focusNodes[itemIndex] : null,
                leadingBorderSide: leadingBorderSide,
                horizontalBorderSide: horizontalBorderSide,
                trailingBorderSide: trailingBorderSide,
                borderRadius: edgeBorderRadius,
                clipRadius: clipBorderRadius,
                onPressed: onPressed != null
                  ? () { onPressed(item); }
                  : null,
                isFirstButton: _isFirstIndex(itemIndex, items.length, textDirection),
                isLastButton: _isLastIndex(itemIndex, items.length, textDirection),
                child: _isSelected(itemIndex) ? selectedItemBuilder(context, item) : itemBuilder(context, item),
              )
            ),
          );
        })
        .values
        .toList(),
    );
  }
}

class _MyToggleButton extends StatelessWidget {
  const _MyToggleButton({
    Key key,
    this.selected = false,
    this.textStyle,
    this.constraints,
    this.color,
    this.selectedColor,
    this.disabledColor,
    this.fillColor,
    this.focusColor,
    this.highlightColor,
    this.hoverColor,
    this.splashColor,
    this.focusNode,
    this.onPressed,
    this.leadingBorderSide,
    this.horizontalBorderSide,
    this.trailingBorderSide,
    this.borderRadius,
    this.clipRadius,
    this.isFirstButton,
    this.isLastButton,
    this.child,
  }) : super(key: key);

  final bool selected;
  final TextStyle textStyle;
  final BoxConstraints constraints;
  final Color color;
  final Color selectedColor;
  final Color disabledColor;
  final Color fillColor;
  final Color focusColor;
  final Color hoverColor;
  final Color highlightColor;
  final Color splashColor;
  final FocusNode focusNode;
  final VoidCallback onPressed;
  final BorderSide leadingBorderSide;
  final BorderSide horizontalBorderSide;
  final BorderSide trailingBorderSide;
  final BorderRadius borderRadius;
  final BorderRadius clipRadius;
  final bool isFirstButton;
  final bool isLastButton;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    Color currentColor;
    Color currentFillColor;
    Color currentFocusColor;
    Color currentHoverColor;
    Color currentSplashColor;
    final ThemeData theme = Theme.of(context);
    final ToggleButtonsThemeData toggleButtonsTheme = ToggleButtonsTheme.of(context);

    if (onPressed != null && selected) {
      currentColor = selectedColor
        ?? toggleButtonsTheme.selectedColor
        ?? theme.colorScheme.primary;
      currentFillColor = fillColor
        ?? theme.colorScheme.primary.withOpacity(0.12);
      currentFocusColor = focusColor
        ?? toggleButtonsTheme.focusColor
        ?? theme.colorScheme.primary.withOpacity(0.12);
      currentHoverColor = hoverColor
        ?? toggleButtonsTheme.hoverColor
        ?? theme.colorScheme.primary.withOpacity(0.04);
      currentSplashColor = splashColor
        ?? toggleButtonsTheme.splashColor
        ?? theme.colorScheme.primary.withOpacity(0.16);
    } else if (onPressed != null && !selected) {
      currentColor = color
        ?? toggleButtonsTheme.color
        ?? theme.colorScheme.onSurface.withOpacity(0.87);
      currentFillColor = theme.colorScheme.surface.withOpacity(0.0);
      currentFocusColor = focusColor
        ?? toggleButtonsTheme.focusColor
        ?? theme.colorScheme.onSurface.withOpacity(0.12);
      currentHoverColor = hoverColor
        ?? toggleButtonsTheme.hoverColor
        ?? theme.colorScheme.onSurface.withOpacity(0.04);
      currentSplashColor = splashColor
        ?? toggleButtonsTheme.splashColor
        ?? theme.colorScheme.onSurface.withOpacity(0.16);
    } else {
      currentColor = disabledColor
        ?? toggleButtonsTheme.disabledColor
        ?? theme.colorScheme.onSurface.withOpacity(0.38);
      currentFillColor = theme.colorScheme.surface.withOpacity(0.0);
    }

    final TextStyle currentTextStyle = textStyle ?? toggleButtonsTheme.textStyle ?? theme.textTheme.bodyText2;
    final BoxConstraints currentConstraints = constraints ?? toggleButtonsTheme.constraints ?? const BoxConstraints(minWidth: kMinInteractiveDimension, minHeight: kMinInteractiveDimension);

    final result = ClipRRect(
      borderRadius: clipRadius,
      child: RawMaterialButton(
        textStyle: currentTextStyle.copyWith(
          color: currentColor,
        ),
        constraints: currentConstraints,
        elevation: 0.0,
        highlightElevation: 0.0,
        fillColor: currentFillColor,
        focusColor: currentFocusColor,
        highlightColor: highlightColor
          ?? theme.colorScheme.surface.withOpacity(0.0),
        hoverColor: currentHoverColor,
        splashColor: currentSplashColor,
        focusNode: focusNode,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: onPressed,
        child: child,
      ),
    );

    return _SelectToggleButton(
      key: key,
      leadingBorderSide: leadingBorderSide,
      horizontalBorderSide: horizontalBorderSide,
      trailingBorderSide: trailingBorderSide,
      borderRadius: borderRadius,
      isFirstButton: isFirstButton,
      isLastButton: isLastButton,
      child: result,
    );
  }
}

class _SelectToggleButton extends SingleChildRenderObjectWidget {
  const _SelectToggleButton({
    Key key,
    Widget child,
    this.leadingBorderSide,
    this.horizontalBorderSide,
    this.trailingBorderSide,
    this.borderRadius,
    this.isFirstButton,
    this.isLastButton,
  }) : super(
    key: key,
    child: child,
  );

  // The width and color of the button's leading side border.
  final BorderSide leadingBorderSide;

  // The width and color of the button's top and bottom side borders.
  final BorderSide horizontalBorderSide;

  // The width and color of the button's trailing side border.
  final BorderSide trailingBorderSide;

  // The border radii of each corner of the button.
  final BorderRadius borderRadius;

  // Whether or not this toggle button is the first button in the list.
  final bool isFirstButton;

  // Whether or not this toggle button is the last button in the list.
  final bool isLastButton;

  @override
  _SelectToggleButtonRenderObject createRenderObject(BuildContext context) => _SelectToggleButtonRenderObject(
    leadingBorderSide,
    horizontalBorderSide,
    trailingBorderSide,
    borderRadius,
    isFirstButton,
    isLastButton,
    Directionality.of(context),
  );

  @override
  void updateRenderObject(BuildContext context, _SelectToggleButtonRenderObject renderObject) {
    renderObject
      ..leadingBorderSide = leadingBorderSide
      ..horizontalBorderSide = horizontalBorderSide
      ..trailingBorderSide = trailingBorderSide
      ..borderRadius = borderRadius
      ..isFirstButton = isFirstButton
      ..isLastButton = isLastButton
      ..textDirection = Directionality.of(context);
  }
}

class _SelectToggleButtonRenderObject extends RenderShiftedBox {
  _SelectToggleButtonRenderObject(
    this._leadingBorderSide,
    this._horizontalBorderSide,
    this._trailingBorderSide,
    this._borderRadius,
    this._isFirstButton,
    this._isLastButton,
    this._textDirection, [
    RenderBox child,
  ]) : super(child);

  // The width and color of the button's leading side border.
  BorderSide get leadingBorderSide => _leadingBorderSide;
  BorderSide _leadingBorderSide;
  set leadingBorderSide(BorderSide value) {
    if (_leadingBorderSide == value)
      return;
    _leadingBorderSide = value;
    markNeedsLayout();
  }

  // The width and color of the button's top and bottom side borders.
  BorderSide get horizontalBorderSide => _horizontalBorderSide;
  BorderSide _horizontalBorderSide;
  set horizontalBorderSide(BorderSide value) {
    if (_horizontalBorderSide == value)
      return;
    _horizontalBorderSide = value;
    markNeedsLayout();
  }

  // The width and color of the button's trailing side border.
  BorderSide get trailingBorderSide => _trailingBorderSide;
  BorderSide _trailingBorderSide;
  set trailingBorderSide(BorderSide value) {
    if (_trailingBorderSide == value)
      return;
    _trailingBorderSide = value;
    markNeedsLayout();
  }

  // The border radii of each corner of the button.
  BorderRadius get borderRadius => _borderRadius;
  BorderRadius _borderRadius;
  set borderRadius(BorderRadius value) {
    if (_borderRadius == value)
      return;
    _borderRadius = value;
    markNeedsLayout();
  }

  // Whether or not this toggle button is the first button in the list.
  bool get isFirstButton => _isFirstButton;
  bool _isFirstButton;
  set isFirstButton(bool value) {
    if (_isFirstButton == value)
      return;
    _isFirstButton = value;
    markNeedsLayout();
  }

  // Whether or not this toggle button is the last button in the list.
  bool get isLastButton => _isLastButton;
  bool _isLastButton;
  set isLastButton(bool value) {
    if (_isLastButton == value)
      return;
    _isLastButton = value;
    markNeedsLayout();
  }

  // The direction in which text flows for this application.
  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value)
      return;
    _textDirection = value;
    markNeedsLayout();
  }

  static double _maxHeight(RenderBox box, double width) {
    return box == null ? 0.0 : box.getMaxIntrinsicHeight(width);
  }

  static double _minWidth(RenderBox box, double height) {
    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(RenderBox box, double height) {
    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    // The baseline of this widget is the baseline of its child
    return child.computeDistanceToActualBaseline(baseline) +
      horizontalBorderSide.width;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return horizontalBorderSide.width +
      _maxHeight(child, width) +
      horizontalBorderSide.width;
  }

  @override
  double computeMinIntrinsicHeight(double width) => computeMaxIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double trailingWidth = trailingBorderSide == null ? 0.0 : trailingBorderSide.width;
    return leadingBorderSide.width +
           _maxWidth(child, height) +
           trailingWidth;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final double trailingWidth = trailingBorderSide == null ? 0.0 : trailingBorderSide.width;
    return leadingBorderSide.width +
           _minWidth(child, height) +
           trailingWidth;
  }

  @override
  void performLayout() {
    if (child == null) {
      size = constraints.constrain(Size(
        leadingBorderSide.width + trailingBorderSide.width,
        horizontalBorderSide.width * 2.0,
      ));
      return;
    }

    final double trailingBorderOffset = isLastButton ? trailingBorderSide.width : 0.0;
    double leftConstraint;
    double rightConstraint;

    switch (textDirection) {
      case TextDirection.ltr:
        rightConstraint = trailingBorderOffset;
        leftConstraint = leadingBorderSide.width;

        final BoxConstraints innerConstraints = constraints.deflate(
          EdgeInsets.only(
            left: leftConstraint,
            top: horizontalBorderSide.width,
            right: rightConstraint,
            bottom: horizontalBorderSide.width,
          ),
        );

        child.layout(innerConstraints, parentUsesSize: true);
        final BoxParentData childParentData = child.parentData;
        childParentData.offset = Offset(leadingBorderSide.width, leadingBorderSide.width);

        size = constraints.constrain(Size(
          leftConstraint + child.size.width + rightConstraint,
          horizontalBorderSide.width * 2.0 + child.size.height,
        ));
        break;
      case TextDirection.rtl:
        rightConstraint = leadingBorderSide.width;
        leftConstraint = trailingBorderOffset;

        final BoxConstraints innerConstraints = constraints.deflate(
          EdgeInsets.only(
            left: leftConstraint,
            top: horizontalBorderSide.width,
            right: rightConstraint,
            bottom: horizontalBorderSide.width,
          ),
        );

        child.layout(innerConstraints, parentUsesSize: true);
        final BoxParentData childParentData = child.parentData;

        if (isLastButton) {
          childParentData.offset = Offset(trailingBorderOffset, trailingBorderOffset);
        } else {
          childParentData.offset = Offset(0, horizontalBorderSide.width);
        }

        size = constraints.constrain(Size(
          leftConstraint + child.size.width + rightConstraint,
          horizontalBorderSide.width * 2.0 + child.size.height,
        ));
        break;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    final Offset bottomRight = size.bottomRight(offset);
    final Rect outer = Rect.fromLTRB(offset.dx, offset.dy, bottomRight.dx, bottomRight.dy);
    final Rect center = outer.deflate(horizontalBorderSide.width / 2.0);
    const double sweepAngle = pi / 2.0;

    final RRect rrect = RRect.fromRectAndCorners(
      center,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    ).scaleRadii();

    final Rect tlCorner = Rect.fromLTWH(
      rrect.left,
      rrect.top,
      rrect.tlRadiusX * 2.0,
      rrect.tlRadiusY * 2.0,
    );
    final Rect blCorner = Rect.fromLTWH(
      rrect.left,
      rrect.bottom - (rrect.blRadiusY * 2.0),
      rrect.blRadiusX * 2.0,
      rrect.blRadiusY * 2.0,
    );
    final Rect trCorner = Rect.fromLTWH(
      rrect.right - (rrect.trRadiusX * 2),
      rrect.top,
      rrect.trRadiusX * 2,
      rrect.trRadiusY * 2,
    );
    final Rect brCorner = Rect.fromLTWH(
      rrect.right - (rrect.brRadiusX * 2),
      rrect.bottom - (rrect.brRadiusY * 2),
      rrect.brRadiusX * 2,
      rrect.brRadiusY * 2,
    );

    final Paint leadingPaint = leadingBorderSide.toPaint();
    switch (textDirection) {
      case TextDirection.ltr:
        if (isLastButton) {
          final Path leftPath = Path()
            ..moveTo(rrect.left, rrect.bottom + leadingBorderSide.width / 2)
            ..lineTo(rrect.left, rrect.top - leadingBorderSide.width / 2);
          context.canvas.drawPath(leftPath, leadingPaint);

          final Paint endingPaint = trailingBorderSide.toPaint();
          final Path endingPath = Path()
            ..moveTo(rrect.left + horizontalBorderSide.width / 2.0, rrect.top)
            ..lineTo(rrect.right - rrect.trRadiusX, rrect.top)
            ..addArc(trCorner, pi * 3.0 / 2.0, sweepAngle)
            ..lineTo(rrect.right, rrect.bottom - rrect.brRadiusY)
            ..addArc(brCorner, 0, sweepAngle)
            ..lineTo(rrect.left + horizontalBorderSide.width / 2.0, rrect.bottom);
          context.canvas.drawPath(endingPath, endingPaint);
        } else if (isFirstButton) {
          final Path leadingPath = Path()
            ..moveTo(outer.right, rrect.bottom)
            ..lineTo(rrect.left + rrect.blRadiusX, rrect.bottom)
            ..addArc(blCorner, pi / 2.0, sweepAngle)
            ..lineTo(rrect.left, rrect.top + rrect.tlRadiusY)
            ..addArc(tlCorner, pi, sweepAngle)
            ..lineTo(outer.right, rrect.top);
          context.canvas.drawPath(leadingPath, leadingPaint);
        } else {
          final Path leadingPath = Path()
            ..moveTo(rrect.left, rrect.bottom + leadingBorderSide.width / 2)
            ..lineTo(rrect.left, rrect.top - leadingBorderSide.width / 2);
          context.canvas.drawPath(leadingPath, leadingPaint);

          final Paint horizontalPaint = horizontalBorderSide.toPaint();
          final Path horizontalPaths = Path()
            ..moveTo(rrect.left + horizontalBorderSide.width / 2.0, rrect.top)
            ..lineTo(outer.right - rrect.trRadiusX, rrect.top)
            ..moveTo(rrect.left + horizontalBorderSide.width / 2.0 + rrect.tlRadiusX, rrect.bottom)
            ..lineTo(outer.right - rrect.trRadiusX, rrect.bottom);
          context.canvas.drawPath(horizontalPaths, horizontalPaint);
        }
        break;
      case TextDirection.rtl:
        if (isLastButton) {
          final Path leadingPath = Path()
            ..moveTo(rrect.right, rrect.bottom + leadingBorderSide.width / 2)
            ..lineTo(rrect.right, rrect.top - leadingBorderSide.width / 2);
          context.canvas.drawPath(leadingPath, leadingPaint);

          final Paint endingPaint = trailingBorderSide.toPaint();
          final Path endingPath = Path()
            ..moveTo(rrect.right - horizontalBorderSide.width / 2.0, rrect.top)
            ..lineTo(rrect.left + rrect.tlRadiusX, rrect.top)
            ..addArc(tlCorner, pi * 3.0 / 2.0, -sweepAngle)
            ..lineTo(rrect.left, rrect.bottom - rrect.blRadiusY)
            ..addArc(blCorner, pi, -sweepAngle)
            ..lineTo(rrect.right - horizontalBorderSide.width / 2.0, rrect.bottom);
          context.canvas.drawPath(endingPath, endingPaint);
        } else if (isFirstButton) {
          final Path leadingPath = Path()
            ..moveTo(outer.left, rrect.bottom)
            ..lineTo(rrect.right - rrect.brRadiusX, rrect.bottom)
            ..addArc(brCorner, pi / 2.0, -sweepAngle)
            ..lineTo(rrect.right, rrect.top + rrect.trRadiusY)
            ..addArc(trCorner, 0, -sweepAngle)
            ..lineTo(outer.left, rrect.top);
          context.canvas.drawPath(leadingPath, leadingPaint);
        } else {
          final Path leadingPath = Path()
            ..moveTo(rrect.right, rrect.bottom + leadingBorderSide.width / 2)
            ..lineTo(rrect.right, rrect.top - leadingBorderSide.width / 2);
          context.canvas.drawPath(leadingPath, leadingPaint);

          final Paint horizontalPaint = horizontalBorderSide.toPaint();
          final Path horizontalPaths = Path()
            ..moveTo(rrect.right - horizontalBorderSide.width / 2.0, rrect.top)
            ..lineTo(outer.left - rrect.tlRadiusX, rrect.top)
            ..moveTo(rrect.right - horizontalBorderSide.width / 2.0 + rrect.trRadiusX, rrect.bottom)
            ..lineTo(outer.left - rrect.tlRadiusX, rrect.bottom);
          context.canvas.drawPath(horizontalPaths, horizontalPaint);
        }
        break;
    }
  }
}

class MyTextFormField extends FormField<String> {
  MyTextFormField({
    Key key,
    this.controller,
    String initialValue,
    FocusNode focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction,
    TextStyle style,
    StrutStyle strutStyle,
    TextDirection textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    ToolbarOptions toolbarOptions,
    bool showCursor,
    bool obscureText = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    bool autovalidate = false,
    bool maxLengthEnforced = true,
    int maxLines = 1,
    int minLines,
    bool expands = false,
    int maxLength,
    ValueChanged<String> onChanged,
    GestureTapCallback onTap,
    VoidCallback onEditingComplete,
    ValueChanged<String> onFieldSubmitted,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    List<TextInputFormatter> inputFormatters,
    bool enabled = true,
    double cursorWidth = 2.0,
    Radius cursorRadius,
    Color cursorColor,
    Brightness keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder buildCounter,
  }) : assert(initialValue == null || controller == null),
       assert(textAlign != null),
       assert(autofocus != null),
       assert(readOnly != null),
       assert(obscureText != null),
       assert(autocorrect != null),
       assert(enableSuggestions != null),
       assert(autovalidate != null),
       assert(maxLengthEnforced != null),
       assert(scrollPadding != null),
       assert(maxLines == null || maxLines > 0),
       assert(minLines == null || minLines > 0),
       assert(
         (maxLines == null) || (minLines == null) || (maxLines >= minLines),
         'minLines can\'t be greater than maxLines',
       ),
       assert(expands != null),
       assert(
         !expands || (maxLines == null && minLines == null),
         'minLines and maxLines must be null when expands is true.',
       ),
       assert(!obscureText || maxLines == 1, 'Obscured fields cannot be multiline.'),
       assert(maxLength == null || maxLength > 0),
       assert(enableInteractiveSelection != null),
       super(
    key: key,
    initialValue: controller != null ? controller.text : (initialValue ?? ''),
    onSaved: onSaved,
    validator: validator,
    autovalidate: autovalidate,
    enabled: enabled,
    builder: (FormFieldState<String> field) {
      final _MyTextFormFieldState state = field;
      final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration())
        .applyDefaults(Theme.of(field.context).inputDecorationTheme);
      void onChangedHandler(String value) {
        if (onChanged != null) {
          onChanged(value);
        }
        if (field.hasError) {
          field.validate();
        }
        field.didChange(value);
      }
      return TextField(
        controller: state._effectiveController,
        focusNode: focusNode,
        decoration: effectiveDecoration.copyWith(errorText: field.errorText),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        textDirection: textDirection,
        textCapitalization: textCapitalization,
        autofocus: autofocus,
        toolbarOptions: toolbarOptions,
        readOnly: readOnly,
        showCursor: showCursor,
        obscureText: obscureText,
        autocorrect: autocorrect,
        enableSuggestions: enableSuggestions,
        maxLengthEnforced: maxLengthEnforced,
        maxLines: maxLines,
        minLines: minLines,
        expands: expands,
        maxLength: maxLength,
        onChanged: onChangedHandler,
        onTap: onTap,
        onEditingComplete: onEditingComplete,
        onSubmitted: onFieldSubmitted,
        inputFormatters: inputFormatters,
        enabled: enabled,
        cursorWidth: cursorWidth,
        cursorRadius: cursorRadius,
        cursorColor: cursorColor,
        scrollPadding: scrollPadding,
        keyboardAppearance: keyboardAppearance,
        enableInteractiveSelection: enableInteractiveSelection,
        buildCounter: buildCounter,
      );
    },
  );

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController controller;

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends FormFieldState<String> {
  TextEditingController _controller;

  TextEditingController get _effectiveController => widget.controller ?? _controller;

  @override
  MyTextFormField get widget => super.widget;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(MyTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null)
          _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value)
      didChange(_effectiveController.text);
  }
}
