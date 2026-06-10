## Swift code conventions

- Use 4-space indentation
- Prefer SwiftUI over UIKit unless explicitly targeting UIKit
- Target iOS 15 and Swift 6.2
- Use the backport mechanism for newer APIs
- Use async/await over completion handlers
- Prefer structured concurrency over unstructured tasks
- Do not add an extra newline at the end of the file

## Architecture

- Use MVVM with ObservableObject for view models
- Keep views thin; move logic into view models or dedicated services
- Never put networking code directly in a view

## Testing

- Write tests for all new logic using Swift Testing in the given / when / then format
- Write snapshot test for all view states using snapshottesting from the MGOTest package
- Use the spies for mocking the desired input
- Run tests before creating a pull request
- Prefer testing behavior over implementation details

## Gotchas

- Empty closures need a comment (`{ /* no-op */ }`); bare `{ }` is rejected by CI
- Extract deeply nested SwiftUI expressions into `@ViewBuilder` methods; CI rejects more than 2 nested result-builder expressions
- Run snapshot tests on `iPhone 17 Pro, OS=26.4` — recordings are pinned to that simulator
