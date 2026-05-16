# Clean Architecture layout

- **Domain**: entities, use cases, repository interfaces
- **Data**: datasources, repository implementations, models (DTOs + mappers)
- **Presentation**: pages, widgets, bloc

Cross-cutting code lives in `lib/src/core/` (routing, firebase, error handling).
Feature code lives in `lib/src/features/<feature>/`.
DI is configured in `lib/injection.dart` using `get_it`.
