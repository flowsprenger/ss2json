# ss2json

**ss2json** is a collection of tools to help in the conversion of spreadsheet to json.

* [ss2json-vertical](#ss2json-vertical) Generate an array of rows. Each row is going to be a hash.
* [ss2json-vertical-hash](#ss2json-vertical-hash) Generate a hash of elements. Each element is a hash that represents a column. The key of that hash is a column.
* [ss2json-horizontal](#ss2json-horizontal) Generate a hash from a key value pairs. The keys are in one column and the values in other.
* [merge-jsons](#merge-jsons) Generate a hash that have the filename as a key, and the content as a value.
* [order-json](#order-jsons) Order the keys of the hashes of a json file.
* [compress-json](#compress-json) Compress the given json. The lasts commands output in pretty format (human readable). You can pipe through this command to compress.
* [catss](#catss) Shows on the terminal the content of the sheet

## Tools

### ss2json-vertical

Lets start with this command to show the basic feature of ss2json.
Suppose we have this sheet:

      | A  | B         | C             | D            | E             | F            | G               | H                 | I         |
    1 | id | name      | childs.1.name | childs.1.age | childs.2.name | Childs.2.age | address.street  | address.post_code | i.notes   |
    2 | 1  | Guillermo |               |              |               |              | Calle de Eros 7 | 28018             | nice guy  |
    3 | 2  | Epi       | Carlos        |              |               |              | Castellana      | 28020             |           |
    4 | 3  | Esther    | Roberto       | 3            | Carlos        | 4            |                 |                   |           |
    5 | 4  |           |               |              |               |              |                 |                   | left note |

What we see here is that the column names (row 1) have a special encoding.

### ss2json-hash

### ss2json-horizontal


## Tutorial

### Step 1

For example, this document:

![Excel](https://github.com/wooga/ss2json/raw/master/doc/ss2json-2.png "Title is optional")

We download as an OpenOffice document (ods), and run:

```ss2json -f document.ods```

Will converted in this:

```javascript
[
  {
    "id": 1,
    "name": { "first": "Guillermo", "last": "Alvarez" },
    "child": [ { "name": "pepe", "age": 2 }, { "name": "Juanjo" } ]
  },
  {
    "id": 2,
    "name": { "first": "Martin", "last": "Luther" },
    "child": [ { "name": "Jr" } ]
  },
  {
    "id": 3,
    "name": { "first": "Jesper" }
  },
  { "id": 4 },
  { "id": 5 },
  { "id": 6 }
]
```

### Step 2

We want to remove the last columns, so we need to tell **ss2json** to check for the name. We do that with the __-c__ parameter.

```
ss2json -f documents.ods -c name
```

```javascript
[
  {
    "id": 1,
    "name": { "first": "Guillermo", "last": "Alvarez" },
    "child": [ { "name": "pepe", "age": 2 }, { "name": "Juanjo" } ]
  },
  {
    "id": 2,
    "name": { "first": "Martin","last": "Luther"},
    "child": [{"name": "Jr"}]
  },
  {
    "id": 3,
    "name": {"first": "Jesper"}
  }
]
```

### Step 3

We have a crappy parser, and need to include blank_fieds, so we say that to ss2json.

```
ss2json -f documents.ods -c name -b
```


### Step 4

We have the rows with the title in colum 3, as in:

![Excel](https://github.com/wooga/ss2json/raw/master/doc/ss2json-1.png "Title is optional")

So we say to **ss2json** to start parsing in the row tree:

```
ss2json -f documents.ods -c name -r 3
```

### Step 5

We don't want to open the file to have a list of the sheets:

```
ss2json -f documents.ods -l
```



## Support

Right now ss2json supports ods and xlsx files.



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

## TODO

  * Support all the document formats from **roo** librarly.
  * -c options should be able to check inside the hash, for example name.first should check {"name":{"first": null}}

## License

BSD
