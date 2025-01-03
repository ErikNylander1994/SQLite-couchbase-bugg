//
//  SQLiteError.swift
//
//  Copyright 2015-present, Nike, Inc.
//  All rights reserved.
//
//  This source code is licensed under the BSD-stylelicense found in the LICENSE
//  file in the root directory of this source tree.
//

import Foundation
import SQLite3

/// (EJ DELA CENTRAL) Used to encapsulate errors generated by SQLite. OBS MESTADELS ETT INTERNT DELA DEPENDENCY, DÄRAV DOKUMENTATION PÅ ENGELSKA OBS
public struct SQLiteError: Error {

    // MARK: Properties

    /// The [code](https://www.sqlite.org/c3ref/c_abort.html) of the specific error encountered by SQLite.
    public let code: Int32

    /// The [message](https://www.sqlite.org/c3ref/errcode.html) of the specific error encountered by SQLite.
    public var message: String

    /// A textual description of the [error code](https://www.sqlite.org/c3ref/errcode.html).
    public var codeDescription: String { return String(cString: sqlite3_errstr(code)) }

    private static let successCodes: Set = [SQLITE_OK, SQLITE_ROW, SQLITE_DONE]

    // MARK: Initialization

    init?(code: Int32, connection: Connection) {
        guard !SQLiteError.successCodes.contains(code) else { return nil }

        self.code = code
        self.message = String(cString: sqlite3_errmsg(connection.handle))
    }

    init(connection: Connection) {
        self.code = sqlite3_errcode(connection.handle)
        self.message = String(cString: sqlite3_errmsg(connection.handle))
    }

    init(code: Int32, message: String) {
        self.code = code
        self.message = message
    }
}

// MARK: - CustomStringConvertible

extension SQLiteError: CustomStringConvertible {
    /// A textual representation of the error message, code and code description.
    public var description: String {
        let messageArray = [
            "message=\"\(message)\"",
            "code=\(code)",
            "codeDescription=\"\(codeDescription)\""
        ]

        return "{ " + messageArray.joined(separator: ", ") + " }"
    }
}
