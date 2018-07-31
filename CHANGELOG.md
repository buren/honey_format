# HEAD


* Require `set` class in `ConvertBoolean` - fixes crash when set is already required in environment
* Allow symbols to be passed to `HeaderColumnConverter`
* Replace `.` and `,` with `_` in header column converter

## v0.17.0

:warning: This release contains some backwards compatible changes.

* Add global config for CSV `delimiter`, `row_delimiter`, `quote_character` and `skip_lines`
* Add `header_deduplicator` support to Matrix & CSV
* Make `HeaderColumnConverter` normalization even more aggressive [PR#32](https://github.com/buren/honey_format/pull/32)
  - :warning: Backwards incompatible
* Add `blank` type [PR#34](https://github.com/buren/honey_format/pull/34)
* Rename `ValueConverter` => `Registry` and generalize implementation
* Rename `UnknownValueTypeError` => `UnknownTypeError`
  - :warning: Backwards incompatible
* Allow unregister of existing value converters
* Add `hex` and `blank` converters to registry

## v0.16.0

* Add `--type-map` option to CLI

## v0.15.0

:warning: This release contains some backwards compatible changes.

* Add `--skip-lines` argument to CLI [PR#22](https://github.com/buren/honey_format/pull/22)
* Add support for CSV skip lines [PR#22](https://github.com/buren/honey_format/pull/22)
* CLI have input file argument on tail instead of head [PR #21](https://github.com/buren/honey_format/pull/21)
  - :warning: Backwards incompatible

## v0.14.0

* Additional converters
  + `integer_or_zero`
  + `decimal_or_zero`

## v0.13.0

:warning: This release contains some backwards compatible changes.

* Extract `Matrix` super class from `CSV`
* Add `Header#empty?` and `Rows#empty?`
* Value converters [[#PR15](https://github.com/buren/honey_format/pull/15)]
  + Convert column value to number, date, etc..
  + Additional converters in [[#PR20](https://github.com/buren/honey_format/pull/20)]
* Add support for CSV row delimiter and quote character [[#PR15](https://github.com/buren/honey_format/pull/15)]
* :warning: `CSV#header` now returns an instance of `Header` instead of an array of the original header columns [[#PR15](https://github.com/buren/honey_format/pull/15)]
* Add `--[no-]rows-only` CLI option
* Rename `--[no-]only-header` CLI option to `--[no-]header-only`

## v0.12.0

* Add `--[no-]only-header` option to CLI
* _[Bugfix]_: Handle missing --columns argument in CLI

## v0.11.0

* Add CLI: `honey_format` executable
* Swap `RowBuilder` <> `Row` class names [[#PR12](https://github.com/buren/honey_format/pull/12)]

## v0.10.0

* Add support for filtering what rows are included in `#to_csv` [[#PR11](https://github.com/buren/honey_format/pull/11)]

## v0.9.0

:warning: This release contains some backwards compatible changes.

* Add support for missing header values [[#PR10](https://github.com/buren/honey_format/pull/10)]
* Don't mutate original CSV header [[#PR10](https://github.com/buren/honey_format/pull/10)]
* Output converted columns, instead of original, when `#to_csv` is called [[#PR10](https://github.com/buren/honey_format/pull/10)]
* Update error class names [[#PR10](https://github.com/buren/honey_format/pull/10)]
  - There are now two super classes for errors `HeaderError` and `RowError`
  - All errors are under an `Errors` namespace, which `HoneyFormat` includes

## v0.8.2

* _[Bugfix]_ `#to_csv` now outputs nil values as empty string instead of `""`

## v0.8.1

* _[Bugfix]_ Properly quote cells with special CSV-characters in them. ([PR#7](https://github.com/buren/honey_format/pull/7))

## v0.8.0

* _[Feature]_ Add `#size` and `#length` methods to `Header` and `Rows` objects
* _[Bugfix]_ Improved Row error handling for when row size differs from header column


## v0.7.0

* Don't sanitize each row :rocket: (improves performance from ~1.4x times slower than raw CSV to ~1.1)
* Fold `Columns` class into `Header`
* Remove `Sanitize` class

## v0.6.0

* Add `CSV#to_csv` ([PR#2](https://github.com/buren/honey_format/pull/2))
* `csv#rows` returns an instance of `Rows` instead of `Array`

## v0.3.0 - v0.5.0

* Add CSV `row_builder` option
* ...

## v0.2.0

* More explicit exception classes
* Restructured internals

### v0.1.0

Initial release
