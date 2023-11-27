# Locker

Locker is a Flutter library designed to prevent duplicate actions, such as multiple taps on a button by a user. This simple yet effective solution ensures that actions are not performed multiple times, even if the UI element (like a button) is triggered multiple times in quick succession. Locker is perfect for preventing repeated form submissions, API calls, or any other actions that should not be executed more than once at the same time.

## Features
- Prevents multiple function executions when UI elements are activated multiple times.
- Easy to integrate with any Flutter application.
- Utilizes `LockerScope` and `LockerKey` to manage lock states seamlessly.


## Installation
To use Locker in your Flutter app, add `locker` to your `pubspec.yaml` file:

```yaml
dependencies:
  locker: ^1.0.0
```

Then run `flutter packages get` to install the new dependency.

## Usage

To integrate Locker into your Flutter application, wrap your root widget with `LockerScope`:

```dart
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LockerScope(
      child: MaterialApp(
        // ...
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
```

Then, use `LockerKey` to create a unique key for each action you want to lock:

```dart
class _MyHomePageState extends State<MyHomePage> {
  final _countKey = LockerKey.unique();
  // ...
}
```

Use `watchLocked` to listen for the lock status and provide a visual indicator like `CircularProgressIndicator` when the action is locked:

```dart
@override
Widget build(BuildContext context) {
  final isLocked = context.watchLocked(_countKey);
  // ...
}
```

Lock your function execution by calling `lock` on the context with the locker key:

```dart
floatingActionButton: FloatingActionButton(
  onPressed: () async {
    await context.ofLocker(_countKey).lock(
      () => _incrementCounter(),
    );
  },
  // ...
),
```

## Contributing

Contributions to Locker are welcome! Feel free to report issues, open a pull request, or suggest improvements to the documentation.

## License

Locker is released under the MIT License. See the LICENSE file for more information.

---

Please replace the `^1.0.0` in the installation section with the current version of your Locker library.