#  SQLite-couchbase-bugg

### The bugg: 
Using [json_extract](https://www.sqlite.org/json1.html#the_json_extract_function) on a SQLite database (not couchbase related) while having CouchbaseLiteSwift(3.2.0) as a dependency results in the following error:
```
Error from SQLite: { 
    message="no such column: $.name", code=1, 
    codeDescription="SQL logic error" 
}
```
In this simple swiftui project, i create a SQLite database, insert some json data into a column and then try to fetch it using json_extract.

See the following:

https://github.com/ErikNylander1994/SQLite-couchbase-bugg/blob/main/SQLite-couchbase-bugg/SQLite_couchbase_buggApp.swift

https://github.com/ErikNylander1994/SQLite-couchbase-bugg/blob/main/SQLite-couchbase-bugg/SQLiteDB.swift

When removing CouchbaseLiteSwift from "Link Binary With Libraries" the json_extract works as expected.

Tested with Xcode 15.4 on iOS 18.0 device and simulator.





