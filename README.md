# lualinks

Lua and Sailor bookmark management.

**Screenshot:**

![Screenshot](/screenshot.png?raw=true "Screenshot")

## Dependencies

* [Lua >= 5.1, < 5.4](https://www.lua.org/home.html)
* [LuaRocks](https://luarocks.org/)
* [MariaDB >= 10.6.8](https://mariadb.org/)

[Valua](https://github.com/sailorproject/valua) (Validation for Lua):

    git clone https://github.com/sailorproject/valua.git
    cd valua
    sudo luarocks make

[Sailor](https://github.com/sailorproject/sailor) (A Lua MVC Web Framework):

    git clone https://github.com/sailorproject/sailor.git
    cd sailor
    sudo luarocks make

[LuaSQL](https://github.com/keplerproject/luasql) with MySQL driver (A simple interface from Lua to a DBMS):

    sudo luarocks install luasql-mysql

[LuaDate v2.2](https://github.com/Tieske/date) (Lua Date and Time module for Lua 5.x):

    sudo luarocks install date

[lua-requests](https://github.com/JakobGreen/lua-requests) (Requests for Lua!):

    sudo luarocks install lua-requests

## Installation

    git clone https://github.com/ricardogj08/lualinks.git
    cd lualinks

1. Create the lualinks database in MariaDB with the `db/db.sql` script.
2. Modify the lualinks database access credentials in `conf/conf.lua`.

## Run

    cd lualinks
    sailor s

<http://localhost:8080>

* username: `admin`
* password: `admin`

## Thanks

* [linkding - Self-hosted bookmark service.](https://github.com/sissbruecker/linkding)
* [Espial - An Open-source web-based bookmarking server.](https://github.com/jonschoning/espial)
* [bookmarks - A simple self-hosted bookmarking app that can import bookmarks from delicious and chrome.](https://github.com/dyu/bookmarks)
* [xBrowserSync - An open-source alternative to browser syncing tools.](https://www.xbrowsersync.org/)
* [Lobsters - Computing-focused community centered around link aggregation and discussion.](https://github.com/lobsters/lobsters)

## License

    lualinks - Lua and Sailor bookmark management.

    Copyright (C) 2022 - Ricardo García Jiménez <ricardogj08@riseup.net>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
