
# ss2json

**ss2json** is a SpreadSheet To Json converter. It follow a few rules for generating nested hash.

For example, this document:

![Excel](https://github.com/guillermo/ss2json/raw/master/doc/ss2json-2.png "Title is optional")

We download as an OpenOffice document (ods), and run:

```ss2json -f document.ods```

Will converted in this:

```javscript
[
  {
    "id": 1,
    "name": {
      "first": "Guillermo",
      "last": "Alvarez"
    },
    "child": [
      {
        "name": "pepe",
        "age": 2
      },
      {
        "name": "Juanjo"
      }
    ]
  },
  {
    "id": 2,
    "name": {
      "first": "Martin",
      "last": "Luther"
    },
    "child": [
      {
        "name": "Jr"
      }
    ]
  },
  {
    "id": 3,
    "name": {
      "first": "Jesper"
    }
  }
]
```

## Install

    gem install ss2json

## Usage


Run ```ss2json -h```

```sh
You need to at least specify a file
Usage: ss2json -f FILENAME [options]

    -s, --sheet SHEET_NAME           Use other that the first table
    -r, --first-row ROW_NUMBER       Set the default first row
    -f, --file FILENAME              Use the filename
    -i, --ignore-value VALUE         Ignore the fields with that value. Could be use several times
    -b, --include-blank              Generate a json with the values included in the ignore list
    -c, --check-column NAME          Only output objects wich his property NAME is not in IGNORED VALUES
    -d, --disable-conversion         Disable the conversion from floats to integers

    -l, --list-sheets                Return the list of sheets

    -h, --help                       Show this help
```

## License

BSD
