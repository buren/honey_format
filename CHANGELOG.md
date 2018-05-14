# v0.7.0

- Don't sanitize each row :rocket: (improves performance from ~1.4x times slower than raw CSV to ~1.1)
- Fold `Columns` class into `Header`
- Remove `Sanitize` class

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
