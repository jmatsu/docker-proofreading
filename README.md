[![Docker Repository on Quay](https://quay.io/repository/jmatsu/proofreading/status "Docker Repository on Quay")](https://quay.io/repository/jmatsu/proofreading)

# docker-proofreading

The Docker container which can validate text files.

* Redpen as the validation system
* Re:VIEW as the document format

# Usage

This is a base image so you must prepare the following:

```
+ Dockerfile (specifies this image as FROM)
+ .ruby-version
+ redpen-version
+ Gemfile
```

# License

See [MIT License](./LICENSE)
