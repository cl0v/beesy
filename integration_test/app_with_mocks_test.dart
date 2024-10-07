// TODO: Implement mocks to integration tests
//
// Steps:
// 1. Create a build.yaml in the root of the project and place the following code
//
// targets:
//   $default:
//     sources:
//       - $package$
//       - lib/$lib$
//       - lib/**.dart
//       - test/**.dart
//       - integration_test/**.dart
//     builders:
//       mockito|mockBuilder:
//         generate_for:
//           - test/**.dart
//           - integration_test/**.dart
//
// 2. Generate the mocks with dart run build_runner ...