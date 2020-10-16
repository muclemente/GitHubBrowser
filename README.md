**Application Scope:**

An iOS application that you can use to search for GitHub users, their repositories and profile stats;

**Concepts:**

- XcodeGen project generation to help with conflict mitigation in a team environment;
- Separate framework modules for isolating code and delitiming responsibilities/property accessors:
    - App: Main target with executable and initialization code;
    - Core: Reusable extensions, constants and mechanisms in the app;
    - Features: Presentation and business layer code;
    - Provider: Network access and abstractions for any data input;
- View Model/Rx/Coordinator patterns;
- Dependency injection pattern to help with test dependency mocking;
- PromiseKit to help with async code readability;
- Feature toggle implementation demonstration;
- ViewCode practices for better UI componentization;
- Unit tests using Mockolo to help with boilerplate code in the test project;

**Setup:**

- Uses GitHub's Personal Access token to authenticate. Setup this using the Makefile (ex: `make muclemente 123456`)

**Features:**

- 