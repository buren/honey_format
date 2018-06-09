# v0.9.2

:warning: This release contains some backwards compatible changes.

* Add support for missing header values [[#PR10](https://github.com/buren/honey_format/pull/10)]
* Don't mutate original CSV header [[#PR10](https://github.com/buren/honey_format/pull/10)]
* Output converted columns, instead of original, when `#to_csv` is called [[#PR10](https://github.com/buren/honey_format/pull/10)]
* Update error class names [[#PR10](https://github.com/buren/honey_format/pull/10)]
  - There are now two super classes for errors `HeaderError` and `RowError`
  - All errors are under an `Errors` namespace, which `HoneyFormat` includes

# v0.8.2

* _[Bugfix]_ `#to_csv` now outputs nil values as empty string instead of `""`

# v0.8.1

* _[Bugfix]_ Properly quote cells with special CSV-characters in them. ([PR#7](https://github.com/buren/honey_format/pull/7))

# v0.8.0

* _[Feature]_ Add `#size` and `#length` methods to `Header` and `Rows` objects
* _[Bugfix]_ Improved Row error handling for when row size differs from header column


# v0.7.0

* Don't sanitize each row :rocket: (improves performance from ~1.4x times slower than raw CSV to ~1.1)
* Fold `Columns` class into `Header`
* Remove `Sanitize` class

# v0.6.0

* Add `CSV#to_csv` ([PR#2](https://github.com/buren/honey_format/pull/2))
* `csv#rows` returns an instance of `Rows` instead of `Array`

# v0.3.0 - v0.5.0

* Add CSV `row_builder` option
* ...

# v0.2.0

* More explicit exception classes
* Restructured internals

## v0.1.0

Initial release
