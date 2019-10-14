# frozen_string_literal: true
#!/usr/bin/env ruby

require "pg"

connection = PG.connect(dbname: "memo_app")
connection.exec(
  "CREATE TABLE memo(
    id    VARCHR(100) NOT NULL,
    title VARCHR(max),
    body  VARCHR(max),
    PRIMARY KEY (id)
  );"
)

